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

process_file() {
    local filename="$1"
    if [[ -e "$filename" ]]; then
        if ! fuser "$filename" >/dev/null 2>&1; then
            local permissions=$(stat --format="%a%G" "$filename")
            if [[ "$permissions" != "2775users" ]]; then
                setfacl -b -R "$filename"
                chown -R root:users "$filename"
                chmod -R 2775 "$filename"
            fi
        else
            sleep 30
            process_file "$filename"
        fi
    fi
}

# Use inotifywait to monitor directories for file changes
previousFilename=""
inotifywait -mqr /home/Shared /home/Node /home/Git /home/Trash /home/Storage /home/Secrets -e create,close_write,modify,moved_to --format "%w%f" |
while read filename; do
    if [ "$previousFilename" != "$filename" ]; then
        previousFilename="$filename"
        (
        sleep 3
        process_file "$filename"
        ) &
    fi
done
