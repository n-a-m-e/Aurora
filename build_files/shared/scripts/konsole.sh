#!/usr/bin/env bash

# Tell this script to exit if there are any errors.
# You should have this in every custom script, to ensure that your completed
# builds actually ran successfully without any errors!
set -oue pipefail

#Override Aurora Changes https://github.com/ublue-os/bluefin/blob/de4cec23b0328857f99bebeb2874679bc23c85d7/build_files/aurora-changes.sh
#sed -i 's|org.gnome.Ptyxis.desktop|org.kde.konsole.desktop|g' /usr/share/plasma/plasmoids/org.kde.plasma.taskmanager/contents/config/main.xml
#sed -i 's|org.gnome.Ptyxis.desktop|org.kde.konsole.desktop|g' /usr/share/plasma/plasmoids/org.kde.plasma.kickoff/contents/config/main.xml
sed -i 's|X-KDE-Shortcuts=Ctrl+Alt+T||g' /usr/share/applications/org.gnome.Ptyxis.desktop
sed -i 's|Keywords=konsole;console;|Keywords=|g' /usr/share/applications/org.gnome.Ptyxis.desktop
sed -i 's|\[Desktop Entry\]|\[Desktop Entry\]\nNoDisplay=true|g' /usr/share/applications/org.gnome.Ptyxis.desktop
rm -f /usr/share/kglobalaccel/org.gnome.Ptyxis.desktop
sed -i 's|NoDisplay=true||g' /usr/share/applications/org.kde.konsole.desktop
cp /usr/share/applications/org.kde.konsole.desktop /usr/share/kglobalaccel/org.kde.konsole.desktop

sed -i 's|TerminalApplication=kde-ptyxis|TerminalApplication=konsole|g' /usr/share/kde-settings/kde-profile/default/xdg/kdeglobals
sed -i 's|TerminalService=org.gnome.Ptyxis.desktop|TerminalService=org.kde.konsole.desktop|g' /usr/share/kde-settings/kde-profile/default/xdg/kdeglobals

#Make Yakuake the default
#sed -i 's|org.kde.konsole.desktop|org.kde.yakuake.desktop|g' /usr/share/plasma/plasmoids/org.kde.plasma.taskmanager/contents/config/main.xml
#sed -i 's|org.kde.konsole.desktop|org.kde.yakuake.desktop|g' /usr/share/plasma/plasmoids/org.kde.plasma.kickoff/contents/config/main.xml
sed -i 's|TerminalApplication=konsole|TerminalApplication=yakuake|g' /usr/share/kde-settings/kde-profile/default/xdg/kdeglobals
sed -i 's|TerminalService=org.kde.konsole.desktop|TerminalService=org.kde.yakuake.desktop|g' /usr/share/kde-settings/kde-profile/default/xdg/kdeglobals
mkdir -p /usr/etc/xdg/autostart
cp /usr/share/applications/org.kde.yakuake.desktop /usr/etc/xdg/autostart/org.kde.yakuake.desktop
