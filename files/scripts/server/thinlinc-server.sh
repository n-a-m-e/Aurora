#!/usr/bin/env bash
set -Eeuo pipefail
source /usr/lib/bluebuild-debug.sh

mkdir /tmp/thinlinc
BB_DEBUG_CLEANUP='rm -rf /tmp/thinlinc'
#wget -O /tmp/thinlinc/tl-4.17.0-server.zip https://www.cendio.com/downloads/server/tl-4.17.0-server.zip
#wget -O /tmp/thinlinc/tl-4.20.1-server.zip https://github.com/n-a-m-e/Aurora-Files/releases/download/tl-4.20.1-server/tl-4.20.1-server.zip
wget -O /tmp/thinlinc/tl-4.17.0-server.zip https://github.com/n-a-m-e/Aurora-Files/releases/download/tl-4.17.0-server/tl-4.17.0-server.zip
cd /tmp/thinlinc
unzip tl-*server.zip
rpm-ostree install VirtualGL plasma-workspace-x11 sendmail /tmp/thinlinc/tl-*-server/packages/thinlinc-server-*.rpm

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
setup-selinux=yes
setup-apparmor=no
agent-hostname-choice=ip
setup-firewall-ssh=yes
setup-firewall-tlwebaccess=yes
setup-firewall-tlwebadm=yes
setup-firewall-tlmaster=yes
setup-firewall-tlagent=yes
missing-answer=abort
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
#mv /opt/thinlinc /usr/lib/opt/thinlinc

#create required directories and symlinks at boot
# Create required directories and symlinks at boot
thinlinc_scan="/opt/thinlinc"
thinlinc_src="/usr/lib/opt/thinlinc"
thinlinc_dst="/var/opt/thinlinc"

emit_tmpfiles_entries() {
  local op="$1" rel="$2" attrs="$3" scan_dir dst_dir src_prefix
  shift 3

  if [[ "${rel}" == "." ]]; then
    scan_dir="${thinlinc_scan}"
    dst_dir="${thinlinc_dst}"
    src_prefix="${thinlinc_src}"
  else
    scan_dir="${thinlinc_scan}/${rel}"
    dst_dir="${thinlinc_dst}/${rel}"
    src_prefix="${thinlinc_src}/${rel}"
  fi

  [[ -d "${scan_dir}" ]] || return 0
  find "${scan_dir}" -mindepth 1 -maxdepth 1 "$@" -printf "${op} ${dst_dir}/%f ${attrs} - ${src_prefix}/%f\n" | sort
}
{
  printf 'd %s 755 root root -\n' /var/lib/vsm "${thinlinc_dst}" "${thinlinc_dst}"/{sessions,utils,statistics,etc} "${thinlinc_dst}"/utils/{tl-printer,tl-ldap-certalias} "${thinlinc_dst}"/etc/{licenses,conf.d}
  emit_tmpfiles_entries C  "etc/conf.d" "644 root root" -type f
  emit_tmpfiles_entries L+ "etc/conf.d" "- - -" -type d
  emit_tmpfiles_entries L+ "."     "- - -" ! -name sessions ! -name utils ! -name statistics ! -name etc
  emit_tmpfiles_entries L+ "etc"   "- - -" ! -name licenses ! -name conf.d
  emit_tmpfiles_entries L+ "utils" "- - -" ! -name tl-printer ! -name tl-ldap-certalias
} > /usr/lib/tmpfiles.d/thinlinc.conf

cat <<'EOF' > /usr/lib/tmpfiles.d/sendmail-spool.conf
d /var/spool/clientmqueue 0770 smmsp smmsp -
d /var/spool/mqueue       0700 root  mail  -
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
    var powerActions = {
        "org.freedesktop.login1.power-off": true,
        "org.freedesktop.login1.power-off-multiple-sessions": true,
        "org.freedesktop.login1.power-off-ignore-inhibit": true,
        "org.freedesktop.login1.reboot": true,
        "org.freedesktop.login1.reboot-multiple-sessions": true,
        "org.freedesktop.login1.reboot-ignore-inhibit": true,
        "org.freedesktop.login1.halt": true,
        "org.freedesktop.login1.halt-multiple-sessions": true,
        "org.freedesktop.login1.halt-ignore-inhibit": true
    };

    if (!powerActions[action.id] || subject.local) {
        return;
    }

    try {
        var pid = String(subject.pid || "");
        var exe = pid ? polkit.spawn(["/usr/bin/readlink", "-f", "/proc/" + pid + "/exe"]).trim() : "";
        if (exe == "/usr/libexec/org_kde_powerdevil") {
            polkit.log("Denied remote login1 power action from Powerdevil: pid=" + pid + " action=" + action.id);
            return polkit.Result.NO;
        }
        var now = new Date();
        var day = now.getDay();
        var mins = now.getHours() * 60 + now.getMinutes();
        var businessHours = day >= 1 && day <= 5 && mins >= 510 && mins < 1050;
        if (!businessHours) {
            return polkit.Result.YES;
        }
        var requester = subject.user || "";
        var session = subject.session || "";
        var sessions = polkit.spawn(["/usr/bin/loginctl", "list-sessions", "--no-legend"]).trim();
        if (sessions !== "") {
            var lines = sessions.split("\n");
            for (var i = 0; i < lines.length; i++) {
                var sid = lines[i].trim().split(/\s+/)[0];
                var vals = polkit.spawn(["/usr/bin/loginctl", "show-session", sid, "-p", "Service", "-p", "Type", "-p", "Class", "-p", "Name", "--value"]).trim().split("\n");
                if (vals[0] == "thinlinc" && vals[1] == "x11" && vals[2] == "user" && vals[3] && vals[3] != requester) {
                    polkit.log("remote-shutdown: other user active; logging out " + requester + " instead of shutdown");
                    if (session) {
                        polkit.spawn(["/usr/bin/loginctl", "terminate-session", session]);
                    }
                    return polkit.Result.AUTH_ADMIN;
                }
            }
        }
        return polkit.Result.YES;
    } catch (e) {
        polkit.log("remote-shutdown: failed: " + e);
        return polkit.Result.AUTH_ADMIN;
    }
});
EOF

#add localhost to /usr/etc/hosts
mkdir -p /usr/etc
cat <<'EOF' >> /usr/etc/hosts

# Loopback entries; do not change.
127.0.0.1   aurora.home.arpa aurora
::1         aurora.home.arpa aurora

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
