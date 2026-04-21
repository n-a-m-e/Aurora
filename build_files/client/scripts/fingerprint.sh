#!/usr/bin/env bash

# Tell this script to exit if there are any errors.
# You should have this in every custom script, to ensure that your completed
# builds actually ran successfully without any errors!
set -oue pipefail

#for login prepend fingerprint reader to /usr/etc/pam.d/sddm
mkdir -p /usr/etc/pam.d
cat <<EOF > /usr/etc/pam.d/sddm
#%PAM-1.0
auth       [success=1 new_authtok_reqd=1 default=ignore] pam_unix.so try_first_pass likeauth nullok
auth       sufficient   pam_fprintd.so
auth       [success=done ignore=ignore default=bad] pam_selinux_permit.so
auth       substack     password-auth
-auth       optional     pam_gnome_keyring.so
-auth       optional     pam_kwallet5.so
-auth       optional     pam_kwallet.so
auth       include      postlogin

account    required     pam_nologin.so
account    include      password-auth

password   include      password-auth

session    required     pam_selinux.so close
session    required     pam_loginuid.so
-session    optional     pam_ck_connector.so
session    required     pam_selinux.so open
session    optional     pam_keyinit.so force revoke
session    required     pam_namespace.so
session    include      password-auth
-session    optional     pam_gnome_keyring.so auto_start
-session    optional     pam_kwallet5.so auto_start
-session    optional     pam_kwallet.so auto_start
session    include      postlogin
EOF
