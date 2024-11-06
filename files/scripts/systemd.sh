#!/usr/bin/env bash

# Tell this script to exit if there are any errors.
# You should have this in every custom script, to ensure that your completed
# builds actually ran successfully without any errors!
set -oue pipefail

sed -i 's|SocketGroup=docker|SocketGroup=users|' /usr/lib/systemd/system/docker.socket

cat <<'EOF' > /usr/lib/systemd/system/http-server.service
[Unit]
Description=http-server

[Service]
User=root
WorkingDirectory=/home
ExecStart=/bin/bash -c 'mkdir -p /home/Shared && cd /home/Shared && python3 -m http.server'
Restart=always
RestartSec=3

[Install]
WantedBy=multi-user.target
EOF

cat <<'EOF' > /usr/lib/systemd/system/shared-folder.service
[Unit]
Description=shared-folder

[Service]
User=root
WorkingDirectory=/
ExecStart=/usr/sbin/shared-folder.sh
Restart=always
RestartSec=3

[Install]
WantedBy=multi-user.target
EOF

cat <<'EOF' > /usr/sbin/shared-folder.sh
#!/bin/bash
flatpak override --nosocket=wayland --socket=fallback-x11 --socket=x11

mkdir -p /home/Shared
setfacl -b -R /home/Shared
chown -R root:users /home/Shared
chmod -R 2775 /home/Shared

mkdir -p /home/Node
setfacl -b -R /home/Node
chown -R root:users /home/Node
chmod -R 2775 /home/Node

mkdir -p /home/Trash
setfacl -b -R /home/Trash
chown -R root:users /home/Trash
chmod -R 2775 /home/Trash

mkdir -p /home/Storage
setfacl -b -R /home/Storage
chown -R root:users /home/Storage
chmod -R 2775 /home/Storage

PreviousFilename=""
inotifywait -mqr /home/Shared /home/Node /home/Trash /home/Storage -e create,close_write,modify,moved_to --format "%w%f" | while read Filename; do
    if [ "$PreviousFilename" != "$Filename" ]; then
        PreviousFilename="$Filename"
        (
        sleep 2
        if [[ -e "$Filename" ]]; then
            setfacl -b -R "$Filename"
            chown -R root:users "$Filename"
            chmod -R 2775 "$Filename"
        fi
        ) &
    fi
done
EOF
chmod a+x "/usr/sbin/shared-folder.sh"

cat <<'EOF' > /usr/lib/systemd/system/flatpak-native-messaging-hosts.service
[Unit]
Description=flatpak-native-messaging-hosts
After=local-fs.target
After=network.target

[Service]
User=root
WorkingDirectory=/
ExecStart=/usr/sbin/flatpak-native-messaging-hosts.sh
RemainAfterExit=true
Type=oneshot

[Install]
WantedBy=multi-user.target
EOF

cat <<'EOF' > /usr/sbin/flatpak-native-messaging-hosts.sh
#!/bin/bash
flatpaks="org.mozilla.firefox one.ablaze.floorp org.garudalinux.firedragon net.waterfox.waterfox org.chromium.Chromium io.github.ungoogled_software.ungoogled_chromium com.brave.Browser com.vivaldi.Vivaldi com.opera.Opera com.google.Chrome com.google.ChromeDev com.microsoft.Edge com.microsoft.EdgeDev"
for flatpak in $flatpaks; do
    if [ $(flatpak list | grep -c $flatpak) -gt 0 ]; then
        flatpak override --talk-name=org.freedesktop.Flatpak --filesystem=~/.local/share/applications --filesystem=~/.local/share/icons --filesystem=/home/Shared $flatpak
    fi
done
counter=0
until [ $counter -gt 1 ]; do
    if [ $counter = 0 ]; then
        sources="/lib64/mozilla/native-messaging-hosts /lib/mozilla/native-messaging-hosts"
        targets=".var/app/org.mozilla.firefox/.mozilla .mozilla .var/app/one.ablaze.floorp/.floorp .floorp .var/app/org.garudalinux.firedragon/.firedragon .firedragon .var/app/net.waterfox.waterfox/.waterfox .waterfox"
        manifestfolder="native-messaging-hosts"
    elif [ $counter = 1 ]; then
        sources="/etc/chromium/native-messaging-hosts /etc/opt/chrome/native-messaging-hosts /etc/opt/edge/native-messaging-hosts"
        targets=".var/app/org.chromium.Chromium/config/chromium .config/chromium .var/app/io.github.ungoogled_software.ungoogled_chromium/config/chromium .config/chromium .var/app/com.brave.Browser/config/BraveSoftware/Brave-Browser .config/BraveSoftware/Brave-Browser .var/app/com.vivaldi.Vivaldi/config/vivaldi .config/vivaldi .var/app/com.opera.Opera/config/google-chrome .config/google-chrome .var/app/com.google.Chrome/config/google-chrome .config/google-chrome .var/app/com.google.ChromeDev/config/google-chrome-unstable .config/google-chrome-unstable .var/app/com.microsoft.Edge/config/microsoft-edge .config/microsoft-edge .var/app/com.microsoft.EdgeDev/config/microsoft-edge-dev .config/microsoft-edge-dev"
        manifestfolder="NativeMessagingHosts"
    fi
    for source in $sources; do
        if [[ -d ${source} && -n "$(ls -A ${source})" ]]; then
            cd "${source}"
            for manifest in * ; do
                path=$(grep '"path":' "${source}/${manifest}" | cut -d ":" -f 2 | cut -d '"' -f 2)
                binary=$(basename ${path})
                cd /home
                for user in */ ; do
                    for target in $targets; do
                        browser="/home/${user}${target}"
                        localpath="${browser}/${manifestfolder}/${binary}.sh"
                        if [ -d "${browser}" ]; then
                            mkdir -p "${browser}/${manifestfolder}"
                            if [ ! -f "${browser}/${manifestfolder}/${manifest}" ]; then
                                cp "${source}/${manifest}" "${browser}/${manifestfolder}/${manifest}"
                                sed -i "s|$path|$localpath|g" "${browser}/${manifestfolder}/${manifest}"
                            fi
                            if [ ! -f "${localpath}" ]; then
                                echo '#!/bin/bash' >> "${localpath}"
                                echo 'flatpak-spawn --host '"${path}"' "$@"' >> "${localpath}"
                                chmod a+x "${localpath}"
                            fi
                        fi
                    done
                done
            done
        fi
    done
    ((counter++))
done
EOF
chmod a+x "/usr/sbin/flatpak-native-messaging-hosts.sh"
