#!/usr/bin/env bash

# Tell this script to exit if there are any errors.
# You should have this in every custom script, to ensure that your completed
# builds actually ran successfully without any errors!
set -oue pipefail

#Override Aurora Changes https://github.com/ublue-os/bluefin/blob/de4cec23b0328857f99bebeb2874679bc23c85d7/build_files/aurora-changes.sh
sed -i 's|org.gnome.Ptyxis.desktop|org.kde.konsole.desktop|g' /usr/share/plasma/plasmoids/org.kde.plasma.taskmanager/contents/config/main.xml
sed -i 's|org.gnome.Ptyxis.desktop|org.kde.konsole.desktop|g' /usr/share/plasma/plasmoids/org.kde.plasma.kickoff/contents/config/main.xml
sed -i 's|X-KDE-Shortcuts=Ctrl+Alt+T||g' /usr/share/applications/org.gnome.Ptyxis.desktop
sed -i 's|Keywords=konsole;console;|Keywords=|g' /usr/share/applications/org.gnome.Ptyxis.desktop
sed -i 's|\[Desktop Entry\]|\[Desktop Entry\]\nNoDisplay=true|g' /usr/share/applications/org.gnome.Ptyxis.desktop
rm -f /usr/share/kglobalaccel/org.gnome.Ptyxis.desktop
sed -i 's|NoDisplay=true||g' /usr/share/applications/org.kde.konsole.desktop
cp /usr/share/applications/org.kde.konsole.desktop /usr/share/kglobalaccel/org.kde.konsole.desktop

sed -i 's|TerminalApplication=kde-ptyxis|TerminalApplication=konsole|g' /usr/share/kde-settings/kde-profile/default/xdg/kdeglobals
sed -i 's|TerminalService=org.gnome.Ptyxis.desktop|TerminalService=org.kde.konsole.desktop|g' /usr/share/kde-settings/kde-profile/default/xdg/kdeglobals

#Block things via hosts file
curl https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/fakenews-gambling-porn/hosts >> /usr/etc/hosts

#Change Umask to make shared folders possible
sed -i 's/UMASK		022/UMASK		002/g' /etc/login.defs
sed -i 's/HOME_MODE	0700/HOME_MODE	0770/g' /etc/login.defs
sed -i 's/PASS_MIN_LEN	8/PASS_MIN_LEN	1/g' /etc/login.defs

mkdir /tmp/uivision
curl -o /tmp/uivision/xmodules.AppImage https://download.ui.vision/x/uivision-xmodules-linux-v2.AppImage
cd /tmp/uivision
7z x xmodules.AppImage
mkdir /usr/lib/opt/uivision
mv /tmp/uivision/usr/xmodules/kantu-cv-host /usr/lib/opt/uivision/kantu-cv-host
mv /tmp/uivision/usr/xmodules/kantu-xy-host /usr/lib/opt/uivision/kantu-xy-host
mv /tmp/uivision/usr/xmodules/kantu-file-access-host /usr/lib/opt/uivision/kantu-file-access-host
chmod a+x "/usr/lib/opt/uivision/kantu-cv-host"
chmod a+x "/usr/lib/opt/uivision/kantu-xy-host"
chmod a+x "/usr/lib/opt/uivision/kantu-file-access-host"

mkdir -p "/usr/lib64/mozilla/native-messaging-hosts"
cat <<'EOF' > "/usr/lib64/mozilla/native-messaging-hosts/com.a9t9.kantu.cv.json"
{
  "name": "com.a9t9.kantu.cv",
  "description": "UI.Vision Computer Vision",
  "path": "/usr/lib/opt/uivision/kantu-cv-host",
  "type": "stdio",
  "allowed_extensions": [
    "{190d04a6-e387-4f5b-9751-e0d222cf8275}",
	  "kantu@a9t9.com",
	  "copyfish@a9t9.com",
	  "colorfish@a9t9.com"	
  ]
}
EOF
chmod a+r "/usr/lib64/mozilla/native-messaging-hosts/com.a9t9.kantu.cv.json"
cat <<'EOF' > "/usr/lib64/mozilla/native-messaging-hosts/com.a9t9.kantu.xy.json"
{
  "name": "com.a9t9.kantu.xy",
  "description": "UI.Vision Mouse and Keyboard Control",
  "path": "/usr/lib/opt/uivision/kantu-xy-host",
  "type": "stdio",
  "allowed_extensions": [
    "{190d04a6-e387-4f5b-9751-e0d222cf8275}",
	  "kantu@a9t9.com",
	  "copyfish@a9t9.com",
	  "colorfish@a9t9.com"
  ]
}
EOF
chmod a+r "/usr/lib64/mozilla/native-messaging-hosts/com.a9t9.kantu.xy.json"
cat <<'EOF' > "/usr/lib64/mozilla/native-messaging-hosts/com.a9t9.kantu.file_access.json"
{
  "name": "com.a9t9.kantu.file_access",
  "description": "UI.Vision File Access",
  "path": "/usr/lib/opt/uivision/kantu-file-access-host",
  "type": "stdio",
  "allowed_extensions": [
    "{190d04a6-e387-4f5b-9751-e0d222cf8275}",
    "kantu@a9t9.com",
    "copyfish@a9t9.com",
    "colorfish@a9t9.com"
  ]
}
EOF
chmod a+r "/usr/lib64/mozilla/native-messaging-hosts/com.a9t9.kantu.file_access.json"
mkdir -p "/usr/etc/chromium/native-messaging-hosts"
cat <<'EOF' > "/usr/etc/chromium/native-messaging-hosts/com.a9t9.kantu.cv.json"
{
  "name": "com.a9t9.kantu.cv",
  "description": "UI.Vision Computer Vision",
  "path": "/usr/lib/opt/uivision/kantu-cv-host",
  "type": "stdio",
  "allowed_origins": [
    "chrome-extension://dpdlhdbnlaefobeejcgfidghdllhemkl/",
    "chrome-extension://chfonhilonimekkjdiojngiemaajoele/",
    "chrome-extension://kknkjjhfadpnkmbdhmemjlklhhffkgal/",
    "chrome-extension://fffapfncphmnlbhgcmbkdhpbjfbjcfco/",
    "chrome-extension://gcbalfbdmfieckjlnblleoemohcganoc/",
    "chrome-extension://ngkbmimfhhaabikggkeidhgfgjddfidk/",
    "chrome-extension://mkplanokebelajeokbfnigdkhkefgdif/",
    "chrome-extension://eenjdnjldapjajjofmldgmkjaienebbj/",
    "chrome-extension://fpfipmndcbfnofbedjokcjlfogdpmcop/",
    "chrome-extension://ejfgcoabhgdgaafjeindjmegacbklcin/",
    "chrome-extension://cacjdaggjlpecjdbjgjmiphpkmoaijgg/",
    "chrome-extension://goapmjinbaeomoemgdcnnhoedopjnddd/",
    "chrome-extension://jlefpjinggjhccheobegboicdcacepfg/",
    "chrome-extension://ngkbmimfhhaabikggkeidhgfgjddfidk/",
    "chrome-extension://ankheondabfngkjomknppbpkjcdabdlg/"
  ]
}
EOF
chmod a+r "/usr/etc/chromium/native-messaging-hosts/com.a9t9.kantu.cv.json"
cat <<'EOF' > "/usr/etc/chromium/native-messaging-hosts/com.a9t9.kantu.xy.json"
{
  "name": "com.a9t9.kantu.xy",
  "description": "UI.Vision Mouse and Keyboard Control",
  "path": "/usr/lib/opt/uivision/kantu-xy-host",
  "type": "stdio",
  "allowed_origins": [
    "chrome-extension://dpdlhdbnlaefobeejcgfidghdllhemkl/",
    "chrome-extension://chfonhilonimekkjdiojngiemaajoele/",
    "chrome-extension://kknkjjhfadpnkmbdhmemjlklhhffkgal/",
    "chrome-extension://fffapfncphmnlbhgcmbkdhpbjfbjcfco/",
    "chrome-extension://gcbalfbdmfieckjlnblleoemohcganoc/",
    "chrome-extension://ngkbmimfhhaabikggkeidhgfgjddfidk/",
    "chrome-extension://mkplanokebelajeokbfnigdkhkefgdif/",
    "chrome-extension://eenjdnjldapjajjofmldgmkjaienebbj/",
    "chrome-extension://fpfipmndcbfnofbedjokcjlfogdpmcop/",
    "chrome-extension://ejfgcoabhgdgaafjeindjmegacbklcin/",
    "chrome-extension://cacjdaggjlpecjdbjgjmiphpkmoaijgg/",
    "chrome-extension://goapmjinbaeomoemgdcnnhoedopjnddd/",
    "chrome-extension://jlefpjinggjhccheobegboicdcacepfg/",
    "chrome-extension://ngkbmimfhhaabikggkeidhgfgjddfidk/",
    "chrome-extension://ankheondabfngkjomknppbpkjcdabdlg/"
  ]
}
EOF
chmod a+r "/usr/etc/chromium/native-messaging-hosts/com.a9t9.kantu.xy.json"
cat <<'EOF' > "/usr/etc/chromium/native-messaging-hosts/com.a9t9.kantu.file_access.json"
{
  "name": "com.a9t9.kantu.file_access",
  "description": "UI.Vision File Access",
  "path": "/usr/lib/opt/uivision/kantu-file-access-host",
  "type": "stdio",
  "allowed_origins": [
    "chrome-extension://dpdlhdbnlaefobeejcgfidghdllhemkl/",
    "chrome-extension://chfonhilonimekkjdiojngiemaajoele/",
    "chrome-extension://kknkjjhfadpnkmbdhmemjlklhhffkgal/",
    "chrome-extension://fffapfncphmnlbhgcmbkdhpbjfbjcfco/",
    "chrome-extension://gcbalfbdmfieckjlnblleoemohcganoc/",
    "chrome-extension://ngkbmimfhhaabikggkeidhgfgjddfidk/",
    "chrome-extension://mkplanokebelajeokbfnigdkhkefgdif/",
    "chrome-extension://eenjdnjldapjajjofmldgmkjaienebbj/",
    "chrome-extension://fpfipmndcbfnofbedjokcjlfogdpmcop/",
    "chrome-extension://ejfgcoabhgdgaafjeindjmegacbklcin/",
    "chrome-extension://cacjdaggjlpecjdbjgjmiphpkmoaijgg/",
    "chrome-extension://goapmjinbaeomoemgdcnnhoedopjnddd/",
    "chrome-extension://jlefpjinggjhccheobegboicdcacepfg/",
    "chrome-extension://ngkbmimfhhaabikggkeidhgfgjddfidk/",
    "chrome-extension://ankheondabfngkjomknppbpkjcdabdlg/"
  ]
}
EOF
chmod a+r "/usr/etc/chromium/native-messaging-hosts/com.a9t9.kantu.file_access.json"

otherbrowsers="/usr/etc/opt/chrome/native-messaging-hosts /etc/opt/edge/native-messaging-hosts"
for browser in $otherbrowsers; do
  mkdir -p "$browser"
  cp "/usr/etc/chromium/native-messaging-hosts/com.a9t9.kantu.cv.json" "$browser/com.a9t9.kantu.cv.json"
  cp "/usr/etc/chromium/native-messaging-hosts/com.a9t9.kantu.xy.json" "$browser/com.a9t9.kantu.xy.json"
  cp "/usr/etc/chromium/native-messaging-hosts/com.a9t9.kantu.file_access.json" "$browser/com.a9t9.kantu.file_access.json"
done
