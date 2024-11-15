#!/bin/bash
mkdir -p /home/Shared
setfacl -b -R /home/Shared
chown -R root:users /home/Shared
chmod -R 2775 /home/Shared

mkdir -p /home/Node
setfacl -b -R /home/Node
chown -R root:users /home/Node
chmod -R 2775 /home/Node

mkdir -p /home/Git
setfacl -b -R /home/Git
chown -R root:users /home/Git
chmod -R 2775 /home/Git

mkdir -p /home/Trash
setfacl -b -R /home/Trash
chown -R root:users /home/Trash
chmod -R 2775 /home/Trash

mkdir -p /home/Storage
setfacl -b -R /home/Storage
chown -R root:users /home/Storage
chmod -R 2775 /home/Storage

mkdir -p /home/Secrets
setfacl -b -R /home/Secrets
chown -R root:users /home/Secrets
chmod -R 2775 /home/Secrets

flatpaks=$(flatpak list --columns=application)
for flatpak in $flatpaks; do
    if [ $(flatpak info --show-permissions $flatpak| grep -c "home;") -gt 0 ]; then
        flatpak override --filesystem=/home/Shared --filesystem=/home/Node --filesystem=/home/Git --filesystem=/home/Trash --filesystem=/home/Storage $flatpak
    fi
done

PreviousFilename=""
inotifywait -mqr /home/Shared /home/Node /home/Git /home/Trash /home/Storage /home/Secrets -e create,close_write,modify,moved_to --format "%w%f" | while read Filename; do
    if [ "$PreviousFilename" != "$Filename" ]; then
        PreviousFilename="$Filename"
        (
        sleep 2
        if [[ -e "$Filename" ]]; then
            Permissions=$(stat --format="%a%G" "$Filename")
            if [[ "$Permissions" != "2775users" ]]; then
                setfacl -b -R "$Filename"
                chown -R root:users "$Filename"
                chmod -R 2775 "$Filename"
            fi
        fi
        ) &
    fi
done
