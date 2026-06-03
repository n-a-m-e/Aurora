#!/bin/bash

mkdir -p /home/DNS
setfacl -b -R /home/DNS
chown -R root:users /home/DNS
chmod -R 2775 /home/DNS

mkdir -p /home/DNS/pihole
setfacl -b -R /home/DNS/pihole
chown -R root:users /home/DNS/pihole
chmod -R 2775 /home/DNS/pihole

mkdir -p /home/DNS/dnsmasq.d
setfacl -b -R /home/DNS/dnsmasq.d
chown -R root:users /home/DNS/dnsmasq.d
chmod -R 2775 /home/DNS/dnsmasq.d

docker run -d \
    --name aurora \
    -p 53:53/tcp -p 53:53/udp \
    -p 80:80 \
    -e TZ="Australia/Sydney" \
    -v "/home/DNS/pihole:/etc/pihole" \
    -v "/home/DNS/dnsmasq.d:/etc/dnsmasq.d" \
    --dns=127.0.0.1 --dns=1.1.1.1 \
    --restart=unless-stopped \
    --hostname aurora \
    -e VIRTUAL_HOST="aurora" \
    -e PROXY_LOCATION="aurora" \
    -e FTLCONF_LOCAL_IPV4="192.168.1.2" \
    pihole/pihole:latest
