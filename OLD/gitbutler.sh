#!/usr/bin/env bash

# Tell this script to exit if there are any errors.
# You should have this in every custom script, to ensure that your completed
# builds actually ran successfully without any errors!
set -oue pipefail

#mkdir /tmp/gitbutler
#wget -O /tmp/gitbutler/GitButler-0.13.12-1.x86_64.rpm https://releases.gitbutler.com/releases/release/0.13.12-1449/linux/x86_64/GitButler-0.13.12-1.x86_64.rpm
#wget -O /tmp/gitbutler/GitButlerNightly-0.0.0-1.x86_64.rpm https://github.com/n-a-m-e/Aurora-Files/releases/download/GitButlerNightly-0.0.0-1.x86_64/GitButlerNightly-0.0.0-1.x86_64.rpm
#cd /tmp/gitbutler
#sudo rpm-ostree install webkit2gtk4.0-devel /tmp/gitbutler/GitButler*.rpm

#add details to /usr/etc/gitconfig
cat <<'EOF' > /usr/etc/gitconfig
[user]
	signingKey = /home/Git/.ssh/id_ed25519_github.pub
	name = n-a-m-e
	email = n-a-m-e@users.noreply.github.com
[gpg]
	format = ssh
	program = ""
[gpg "ssh"]
	program = ""
[safe]
	directory = *
EOF


