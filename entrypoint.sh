#!/bin/bash
# This script configures `runit` and `socat` to run one or more tcp proxies.
#
# Which proxies to run is determined by environment variables in the following
# format:
#
# export PROXY_name=listenport:targethost:targetport

export GATEWAY_PROXY_IP=$(/sbin/ip route | awk '/default/ { print $3 }')

export proxies=$(env | sed -n 's/^PROXY_\([^=]\+\)=\(.*\):\(.*\):\(.*\)$/\1 \2 \3 \4/p')
while read name listenport targethost targetport; do
  export runitdir=/etc/service/$name
  export runitrun=$runitdir/run

  mkdir -p "$runitdir"

  echo "#!/bin/bash" > $runitrun
cat >> $runitrun <<- EOM
  exec socat \
    TCP4-LISTEN:$listenport,bind=0.0.0.0,fork,su=worker \
    PROXY:$GATEWAY_PROXY_IP:$targethost:$targetport,proxyport=$GATEWAY_PROXY_PORT
EOM

  chmod +x $runitrun
done <<< "$proxies"

exec runsvdir -P /etc/service
