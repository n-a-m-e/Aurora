#!/usr/bin/env bash

# Tell this script to exit if there are any errors.
# You should have this in every custom script, to ensure that your completed
# builds actually ran successfully without any errors!
set -oue pipefail

mkdir /tmp/uivision
#curl -o /tmp/uivision/uivision-xmodules-linux-v2.AppImage https://download.ui.vision/x/uivision-xmodules-linux-v2.AppImage
curl -o /tmp/uivision/uivision-xmodules-linux-v2.AppImage https://github.com/n-a-m-e/Aurora-Files/releases/download/uivision-xmodules-linux-v2.AppImage/uivision-xmodules-linux-v2.AppImage
cd /tmp/uivision
7z x uivision*.AppImage
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
