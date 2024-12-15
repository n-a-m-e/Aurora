#for login prepend fingerprint reader to /usr/etc/pam.d/sddm
cat <<EOF > /usr/etc/pam.d/sddm
#%PAM-1.0
auth    [success=1 new_authtok_reqd=1 default=ignore]   pam_unix.so try_first_pass likeauth nullok
auth    sufficient      pam_fprintd.so

$(cat /usr/etc/pam.d/sddm)
EOF

#for lockscreen prepend fingerprint reader to /usr/etc/pam.d/kde
cat <<EOF > /usr/etc/pam.d/kde
auth 			sufficient  	pam_unix.so try_first_pass likeauth nullok
auth 			sufficient  	pam_fprintd.so

$(cat /usr/etc/pam.d/kde)
EOF
