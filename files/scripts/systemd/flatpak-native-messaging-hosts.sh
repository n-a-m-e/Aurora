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
