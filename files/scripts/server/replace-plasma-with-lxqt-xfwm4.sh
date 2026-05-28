#!/usr/bin/env bash
set -Eeuo pipefail
source /usr/lib/bluebuild-debug.sh

# Allow KDE polkit agent to autostart in LXQt as well as KDE.
# This lets us keep the KDE polkit agent instead of installing lxqt-policykit.
for file in \
  /usr/share/applications/org.kde.polkit-kde-authentication-agent-1.desktop \
  /usr/etc/xdg/autostart/org.kde.polkit-kde-authentication-agent-1.desktop \
  /etc/xdg/autostart/org.kde.polkit-kde-authentication-agent-1.desktop
do
  if [[ -f "$file" ]]; then
    sed -i 's/^OnlyShowIn=.*/OnlyShowIn=KDE;LXQt;/' "$file"
  fi
done

# Make LXQt use xfwm4 instead of Openbox/KWin.
mkdir -p /etc/xdg/lxqt

cat > /etc/xdg/lxqt/session.conf <<'EOF'
[General]
window_manager=xfwm4
EOF

# Configure SDDM for an X11 greeter/session path.
# In BlueBuild/rpm-ostree images, write system defaults to /etc during build;
# rpm-ostree will deploy them appropriately.
mkdir -p /etc/sddm.conf.d

cat > /etc/sddm.conf.d/10-lxqt.conf <<'EOF'
[General]
DisplayServer=x11
GreeterEnvironment=QT_QPA_PLATFORM=xcb
EOF

echo "Checking required LXQt/SDDM binaries and files..."

for cmd in sddm startlxqt xfwm4; do
  if ! command -v "$cmd" >/dev/null; then
    echo "ERROR: Missing required command: $cmd" >&2
    exit 1
  fi
done

if command -v Xorg >/dev/null; then
  echo "Found Xorg: $(command -v Xorg)"
else
  echo "WARNING: Xorg not found during build. SDDM is configured for X11, so ensure xorg-x11-server-Xorg is installed." >&2
fi

if [[ -f /usr/share/xsessions/lxqt.desktop ]]; then
  echo "Found LXQt X11 session: /usr/share/xsessions/lxqt.desktop"
else
  echo "ERROR: Missing LXQt X11 session file: /usr/share/xsessions/lxqt.desktop" >&2
  echo "Install lxqt-x11-session explicitly." >&2
  exit 1
fi

if [[ -d /usr/share/sddm ]]; then
  echo "Found SDDM data dir: /usr/share/sddm"
else
  echo "ERROR: Missing SDDM data dir: /usr/share/sddm" >&2
  exit 1
fi

for group in video render input tty; do
  if getent group "$group" >/dev/null; then
    echo "Resolved group: $group"
  else
    echo "WARNING: group not resolved during build: $group" >&2
  fi
done

for entry in "passwd sddm" "group sddm"; do
  set -- $entry
  if getent "$1" "$2" >/dev/null; then
    echo "Resolved $1 entry: $2"
  else
    echo "WARNING: $1 entry not resolved during build: $2" >&2
  fi
done
