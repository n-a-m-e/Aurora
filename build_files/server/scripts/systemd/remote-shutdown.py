#!/usr/bin/env python3
import asyncio, socket, subprocess, sys, signal
from pathlib import Path

SOCKET = "/run/remote-shutdown.sock"
active = None  # {"id": str, "op": str, "session": str}


def sh(*args):
    return subprocess.run(args, text=True, capture_output=True).stdout.strip()


def send(msg, reply=False):
    s = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
    s.connect(SOCKET)
    s.sendall((msg + "\n").encode())
    out = b""
    if reply:
        while not out.endswith(b"\n"):
            chunk = s.recv(1024)
            if not chunk:
                break
            out += chunk
    s.close()
    return out.decode().strip()


def op_from_action(action):
    if action.startswith("org.freedesktop.login1.power-off"):
        return "poweroff"
    if action.startswith("org.freedesktop.login1.reboot"):
        return "reboot"
    if action.startswith("org.freedesktop.login1.halt"):
        return "halt"
    raise ValueError("unsupported action")


def word(op):
    return {"poweroff": "shutdown", "reboot": "reboot", "halt": "halt"}[op]


def thinlinc_users():
    users = set()
    for line in sh("loginctl", "list-sessions", "--no-legend").splitlines():
        sid = line.split()[0]
        vals = [sh("loginctl", "show-session", sid, "-p", k, "--value")
                for k in ("Service", "Type", "Class", "Name")]
        if vals[:3] == ["thinlinc", "x11", "user"] and vals[3]:
            users.add(vals[3])
    return sorted(users)


def session_env(user):
    pid = sh("pgrep", "-u", user, "-n", "startplasma-x11")
    if not pid:
        return None
    try:
        raw = Path(f"/proc/{pid}/environ").read_bytes().split(b"\0")
    except Exception:
        return None
    env = dict(
        item.split(b"=", 1) for item in raw if b"=" in item
    )
    env = {k.decode(): v.decode() for k, v in env.items()}
    need = ("DISPLAY", "DBUS_SESSION_BUS_ADDRESS", "XDG_RUNTIME_DIR", "XAUTHORITY")
    return env if all(env.get(k) for k in need) else None


def popup(user, role, reqid, title, msg, yes_text, no_text):
    env = session_env(user)
    if not env:
        return
    subprocess.Popen([
        "runuser", "-u", user, "--", "env",
        f"DISPLAY={env['DISPLAY']}",
        f"DBUS_SESSION_BUS_ADDRESS={env['DBUS_SESSION_BUS_ADDRESS']}",
        f"XDG_RUNTIME_DIR={env['XDG_RUNTIME_DIR']}",
        f"XAUTHORITY={env['XAUTHORITY']}",
        sys.executable, __file__, "popup", role, reqid, title, msg, yes_text, no_text
    ], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)


def popup_mode(role, reqid, title, msg, yes_text, no_text):
    import tkinter as tk
    from tkinter import font

    def yes(*_):
        if role == "requester":
            send(f"CONFIRM|{reqid}")
        root.destroy()

    def no(*_):
        send(f"CANCEL|{reqid}")
        root.destroy()

    def poll():
        if send(f"STATUS|{reqid}", True) != "ACTIVE":
            root.destroy()
        else:
            root.after(500, poll)

    root = tk.Tk()
    root.title(title)
    root.configure(bg="#202020")
    root.attributes("-fullscreen", True)
    root.attributes("-topmost", True)
    try:
        root.grab_set()
    except Exception:
        pass

    title_f = font.Font(size=28, weight="bold")
    text_f = font.Font(size=20)
    btn_f = font.Font(size=18, weight="bold")

    frame = tk.Frame(root, bg="#202020")
    frame.pack(expand=True, fill="both")
    tk.Label(frame, text=title, font=title_f, fg="white", bg="#202020").pack(pady=(50, 20))
    tk.Label(frame, text=msg, font=text_f, fg="white", bg="#202020", justify="center", wraplength=1400).pack(padx=80, pady=20)

    btns = tk.Frame(frame, bg="#202020")
    btns.pack(pady=40)
    b_no = tk.Button(btns, text=no_text, font=btn_f, width=22, height=2, command=no)
    b_yes = tk.Button(btns, text=yes_text, font=btn_f, width=22, height=2, command=yes)
    b_no.pack(side="left", padx=30)
    b_yes.pack(side="left", padx=30)
    b_no.focus_set()

    root.bind("<Escape>", no)
    root.protocol("WM_DELETE_WINDOW", no)
    root.after(500, poll)
    root.mainloop()


async def start_request(requester, session, op):
    global active
    if active:
        return

    others = [u for u in thinlinc_users() if u != requester]
    if not others:
        subprocess.run(["systemctl", op], check=False)
        return

    reqid = str(int(asyncio.get_running_loop().time()))
    active = {"id": reqid, "op": op, "session": session}
    op_word = word(op)

    popup(
        requester, "requester", reqid,
        f"Confirm {op_word.capitalize()}",
        f"Are you sure you want to {op_word}?\n\n"
        f"The following users are still logged in:\n"
        + "\n".join(others)
        + "\n\nDefault action is Cancel and log out.",
        f"Yes, {op_word} now", "Cancel and log out"
    )

    for user in others:
        popup(
            user, "other", reqid,
            f"System {op_word.capitalize()} Requested",
            f"User {requester} requested a system {op_word}.\n\nPress Cancel to stop it.",
            "Allow", "Cancel"
        )


async def handle(line, writer):
    global active
    kind, *rest = line.split("|")

    if kind == "REQUEST" and len(rest) == 3 and not active:
        asyncio.create_task(start_request(rest[0], rest[1], rest[2]))

    elif kind == "CONFIRM" and len(rest) == 1 and active and rest[0] == active["id"]:
        op = active["op"]
        active = None
        subprocess.run(["systemctl", op], check=False)

    elif kind == "CANCEL" and len(rest) == 1 and active and rest[0] == active["id"]:
        session = active["session"]
        active = None
        if session:
            subprocess.run(["loginctl", "terminate-session", session], check=False)

    elif kind == "STATUS" and len(rest) == 1:
        writer.write((("ACTIVE" if active and rest[0] == active["id"] else "GONE") + "\n").encode())
        await writer.drain()


async def client(reader, writer):
    line = (await reader.readline()).decode().strip()
    if line:
        await handle(line, writer)
    writer.close()
    await writer.wait_closed()


async def serve():
    path = Path(SOCKET)
    path.parent.mkdir(parents=True, exist_ok=True)
    if path.exists():
        path.unlink()
    server = await asyncio.start_unix_server(client, path=SOCKET)
    path.chmod(0o666)

    stop = asyncio.Event()
    loop = asyncio.get_running_loop()
    loop.add_signal_handler(signal.SIGTERM, stop.set)
    loop.add_signal_handler(signal.SIGINT, stop.set)

    async with server:
        await stop.wait()

    try:
        path.unlink()
    except FileNotFoundError:
        pass


def main():
    if len(sys.argv) == 5 and sys.argv[1] == "request":
        send(f"REQUEST|{sys.argv[2]}|{sys.argv[3]}|{op_from_action(sys.argv[4])}")
    elif len(sys.argv) == 8 and sys.argv[1] == "popup":
        popup_mode(*sys.argv[2:8])
    elif len(sys.argv) == 2 and sys.argv[1] == "serve":
        asyncio.run(serve())
    else:
        print("usage: remote-shutdown.py request USER SESSION ACTION | popup ROLE REQID TITLE MESSAGE YES NO | serve", file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
