#!/bin/bash
flatpak override --nosocket=wayland --socket=fallback-x11 --socket=x11

mkdir -p /home/Shared
setfacl -b -R /home/Shared
chown -R root:users /home/Shared
chmod -R 2775 /home/Shared

mkdir -p /home/Node
setfacl -b -R /home/Node
chown -R root:users /home/Node
chmod -R 2775 /home/Node

mkdir -p /home/Trash
setfacl -b -R /home/Trash
chown -R root:users /home/Trash
chmod -R 2775 /home/Trash

mkdir -p /home/Storage
setfacl -b -R /home/Storage
chown -R root:users /home/Storage
chmod -R 2775 /home/Storage

PreviousFilename=""
inotifywait -mqr /home/Shared /home/Node /home/Trash /home/Storage -e create,close_write,modify,moved_to --format "%w%f" | while read Filename; do
    if [ "$PreviousFilename" != "$Filename" ]; then
        PreviousFilename="$Filename"
        (
        sleep 2
        if [[ -e "$Filename" ]]; then
            setfacl -b -R "$Filename"
            chown -R root:users "$Filename"
            chmod -R 2775 "$Filename"
        fi
        ) &
    fi
done
