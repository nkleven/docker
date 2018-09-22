#!/bin/bash
# Lookups may not work for VPN / tun0
IP_LOOKUP="$(ip route get 8.8.8.8 | awk '{ print $NF; exit }')"
IPv6_LOOKUP="$(ip -6 route get 2001:4860:4860::8888 | awk
'{for(i=1;i<=NF;i++) if ($i=="src") print $(i+1)}')"

# Just hard code these to your docker server's LAN IP if lookups aren't
working
IP="${IP:-$IP_LOOKUP}"  # use $IP, if set, otherwise IP_LOOKUP
IPv6="${IPv6:-$IPv6_LOOKUP}"  # use $IPv6, if set, otherwise IP_LOOKUP

# Default of directory you run this from, update to where ever.
DOCKER_CONFIGS="$(pwd)"

echo "### Make sure your IPs are correct, hard code ServerIP ENV VARs if
necessary\nIP: ${IP}\nIPv6: ${IPv6}"
docker-compose up

echo -n "Your password for https://${IP}/admin/ is "
docker logs pihole 2> /dev/null | grep 'password:'
