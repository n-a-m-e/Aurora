#!/bin/bash
mkdir -p /home/Shared
setfacl -b -R /home/Shared
chown -R root:users /home/Shared
chmod -R 2775 /home/Shared

mkdir -p /home/Node
setfacl -b -R /home/Node
chown -R root:users /home/Node
chmod -R 2775 /home/Node

docker run -it --rm -p 8080:8080 -v "/home/Node:/home/Node" -v "/home/Shared:/home/Shared" -w "/home/Node" node:lts-slim bash -c "cd ..; node Node/server.js"
