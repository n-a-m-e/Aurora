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
rpm-ostree install VirtualGL sendmail /tmp/thinlinc/tl-*-server/packages/thinlinc-server-*.rpm

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
cat > /opt/thinlinc/etc/conf.d/profiles.hconf <<'EOF'
[/profiles]
default=lxqt
order=lxqt
show_intro=false

[/profiles/lxqt]
xdg_session=lxqt
name=LXQt
description=LXQt desktop session.
cmdline=/usr/sbin/start-lxqt.sh
testcmd=test -x /usr/sbin/start-lxqt.sh
description_from_testcmd=false
EOF

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

# disable thinlinc optfix
mkdir -p /etc/tmpfiles.d
ln -sfn /dev/null /etc/tmpfiles.d/99-bluebuild-optfix-thinlinc.conf
