#!/usr/bin/env bash

# Tell this script to exit if there are any errors.
# You should have this in every custom script, to ensure that your completed
# builds actually ran successfully without any errors!
set -oue pipefail

mkdir /tmp/thinlinc
#wget -O /tmp/thinlinc/tl-4.17.0-server.zip https://www.cendio.com/downloads/server/tl-4.17.0-server.zip
wget -O /tmp/thinlinc/tl-4.17.0-server.zip https://github.com/n-a-m-e/Aurora-Files/releases/download/tl-4.17.0-server/tl-4.17.0-server.zip
cd /tmp/thinlinc
unzip tl-*server.zip
rpm-ostree install plasma-workspace-x11 sendmail /tmp/thinlinc/tl-*-server/packages/thinlinc-server-*.rpm

#Don't know how to build selinux module so disable it
#sudo rpm-ostree install selinux-policy-devel ### checkmodule -M -m -o thinlinc.mod thinlinc.te ### semodule_package -o thinlinc.pp -m thinlinc.mod ### semodule -i thinlinc.pp
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config

cat <<'EOF' > /tmp/thinlinc/tl-setup-answers.conf
accept-eula=yes
server-type=master
migrate-conf=parameters
install-required-libs=no
install-nfs=no
install-sshd=no
install-gtk=no
install-python-ldap=no
email-address=root@localhost
# Password = "password"
tlwebadm-password=$6$e07548c54799799b$Wz7FQKAXvYe5agpnyZVnQ3/kETCjMNnABR4GBWx3nwrQEyemjFNS0YPjP.56IRzi41eHVlE.EfFk0QlbK/A0R/
setup-thinlocal=no
setup-nearest=no
setup-firewall=yes
setup-selinux=yes
setup-apparmor=no
missing-answer=ask
EOF

sed -i 's|LOGFILE = "/var/log/tlsetup.log"|LOGFILE = "/tmp/thinlinc/tlsetup.log"|g' /opt/thinlinc/modules/thinlinc/tlsetup/__init__.py
sed -i 's|import thinlinc . tlsetup . system_check|#import thinlinc . tlsetup . system_check|g' /opt/thinlinc/libexec/tl-setup.py
sed -i 's|import thinlinc . tlsetup . requirements|#import thinlinc . tlsetup . requirements|g' /opt/thinlinc/libexec/tl-setup.py

/opt/thinlinc/sbin/tl-setup -a /tmp/thinlinc/tl-setup-answers.conf

sed -i 's|LOGFILE = "/tmp/thinlinc/tlsetup.log"|LOGFILE = "/var/log/tlsetup.log"|g' /opt/thinlinc/modules/thinlinc/tlsetup/__init__.py
sed -i 's|#import thinlinc . tlsetup . system_check|import thinlinc . tlsetup . system_check|g' /opt/thinlinc/libexec/tl-setup.py
sed -i 's|#import thinlinc . tlsetup . requirements|import thinlinc . tlsetup . requirements|g' /opt/thinlinc/libexec/tl-setup.py

#Remove intro from login
sed -i 's|show_intro=.*|show_intro=false|g' /opt/thinlinc/etc/conf.d/profiles.hconf

#add hostname to /usr/lib/opt/thinlinc/etc/conf.d/vsmagent.hconf
#sed -i 's|agent_hostname=|agent_hostname=aurora|g' /opt/thinlinc/etc/conf.d/vsmagent.hconf

#/opt does not persist after build so move to /usr/lib/opt
mv /opt/thinlinc /usr/lib/opt/thinlinc

#create required directories and symlinks at boot
cat <<'EOF' > /usr/lib/tmpfiles.d/thinlinc.conf
d /var/lib/vsm 755 root root -
d /var/opt/thinlinc 755 root root -
d /var/opt/thinlinc/sessions 755 root root -
d /var/opt/thinlinc/utils 755 root root -
d /var/opt/thinlinc/utils/tl-printer 755 root root -
d /var/opt/thinlinc/utils/tl-ldap-certalias 755 root root -
d /var/opt/thinlinc/statistics 755 root root -
L+ /var/opt/thinlinc/desktops - - - - /usr/lib/opt/thinlinc/desktops
L+ /var/opt/thinlinc/modules - - - - /usr/lib/opt/thinlinc/modules
L+ /var/opt/thinlinc/lib - - - - /usr/lib/opt/thinlinc/lib
L+ /var/opt/thinlinc/lib64 - - - - /usr/lib/opt/thinlinc/lib64
L+ /var/opt/thinlinc/sbin - - - - /usr/lib/opt/thinlinc/sbin
L+ /var/opt/thinlinc/share - - - - /usr/lib/opt/thinlinc/share
L+ /var/opt/thinlinc/etc - - - - /usr/lib/opt/thinlinc/etc
L+ /var/opt/thinlinc/bin - - - - /usr/lib/opt/thinlinc/bin
L+ /var/opt/thinlinc/libexec - - - - /usr/lib/opt/thinlinc/libexec
EOF

#Remove Polkit authentication dialogs during login
cat <<'EOF' > /etc/polkit-1/rules.d/40-thinlinc-no-auth-dialogs.rules
polkit.addRule(function(action, subject) {
   if (action.id == "org.freedesktop.color-manager.create-device" ||
        action.id == "org.freedesktop.color-manager.create-profile" ||
        action.id == "org.freedesktop.color-manager.delete-device" ||
        action.id == "org.freedesktop.color-manager.delete-profile" ||
        action.id == "org.freedesktop.color-manager.modify-device" ||
        action.id == "org.freedesktop.color-manager.modify-profile") {
	if (!subject.local) {
		return polkit.Result.NO;
	}
   }
});

polkit.addRule(function(action, subject) {
   if (action.id == "org.freedesktop.packagekit.system-network-proxy-configure" ||
       action.id == "org.freedesktop.packagekit.system-sources-refresh") {
	if (!subject.local) {
		return polkit.Result.NO;
	}
   }
});

polkit.addRule(function(action, subject) {
   if (action.id == "org.freedesktop.NetworkManager.network-control") {
	if (!subject.local) {
		return polkit.Result.NO;
	}
   }
});

polkit.addRule(function(action, subject) {
   if (action.id == "org.freedesktop.login1.suspend" ||
       action.id == "org.freedesktop.login1.suspend-multiple-sessions" ||
       action.id == "org.freedesktop.login1.suspend-ignore-inhibit" ||
       action.id == "org.freedesktop.login1.hibernate" ||
       action.id == "org.freedesktop.login1.hibernate-multiple-sessions" ||
       action.id == "org.freedesktop.login1.hibernate-ignore-inhibit") {
	if (!subject.local) {
		return polkit.Result.NO;
	}
   }
});

polkit.addRule(function(action, subject) {
   if (action.id == "org.freedesktop.login1.power-off" ||
       action.id == "org.freedesktop.login1.power-off-multiple-sessions" ||
       action.id == "org.freedesktop.login1.power-off-ignore-inhibit" ||
       action.id == "org.freedesktop.login1.reboot" ||
       action.id == "org.freedesktop.login1.reboot-multiple-sessions" ||
       action.id == "org.freedesktop.login1.reboot-ignore-inhibit" ||
       action.id == "org.freedesktop.login1.halt" ||
       action.id == "org.freedesktop.login1.halt-multiple-sessions" ||
       action.id == "org.freedesktop.login1.halt-ignore-inhibit") {
	if (!subject.local) {
		return polkit.Result.YES;
	}
   }
});
EOF

#add localhost to /usr/etc/hosts
mkdir -p /usr/etc
cat <<'EOF' >> /usr/etc/hosts

# Loopback entries; do not change.
127.0.0.1   aurora
::1         aurora

# Loopback entries; do not change.
# For historical reasons, localhost precedes localhost.localdomain:
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6

# Disable wpad
127.0.0.1   wpad wpad.*

EOF

#Block things via hosts file
curl https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/fakenews-gambling-porn/hosts >> /usr/etc/hosts
#Remove Google Ads Blocking
sed -i 's/0.0.0.0 google-analytics.com//g' /usr/etc/hosts
sed -i 's/0.0.0.0 ssl.google-analytics.com//g' /usr/etc/hosts
sed -i 's/0.0.0.0 www.google-analytics.com//g' /usr/etc/hosts
sed -i 's/0.0.0.0 ads.google.com//g' /usr/etc/hosts
sed -i 's/0.0.0.0 adservice.google.com//g' /usr/etc/hosts
sed -i 's/0.0.0.0 s0-2mdn-net.l.google.com//g' /usr/etc/hosts
sed -i 's/0.0.0.0 googleadservices.com//g' /usr/etc/hosts
sed -i 's/0.0.0.0 pagead2.googleadservices.com//g' /usr/etc/hosts
sed -i 's/0.0.0.0 www.googleadservices.com//g' /usr/etc/hosts
#sed -i 's/0.0.0.0 static.googleadsserving.cn//g' /usr/etc/hosts
#sed -i 's/0.0.0.0 googlesyndication.com//g' /usr/etc/hosts
#sed -i 's/0.0.0.0 ade.googlesyndication.com//g' /usr/etc/hosts
#sed -i 's/0.0.0.0 pagead.googlesyndication.com//g' /usr/etc/hosts
#sed -i 's/0.0.0.0 pagead2.googlesyndication.com//g' /usr/etc/hosts
#sed -i 's/0.0.0.0 tpc.googlesyndication.com//g' /usr/etc/hosts
#sed -i 's/0.0.0.0 displayads-formats.googleusercontent.com//g' /usr/etc/hosts
