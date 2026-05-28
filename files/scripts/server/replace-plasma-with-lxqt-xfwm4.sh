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

# Sanity checks for the image build.
# These fail the build early if the recipe forgot a required package.
command -v Xorg >/dev/null
command -v sddm >/dev/null
command -v startlxqt >/dev/null
command -v xfwm4 >/dev/null

test -f /usr/share/xsessions/lxqt.desktop
test -d /usr/share/sddm

# Verify NSS can resolve important system groups from /usr/lib/group via nss-altfiles.
# Do not copy /usr/lib/group into /etc/group; minimal /etc/group is normal on rpm-ostree.
getent group video >/dev/null
getent group render >/dev/null
getent group input >/dev/null
getent group tty >/dev/null

# Verify the SDDM user exists after installing sddm.
getent passwd sddm >/dev/null
getent group sddm >/dev/null
