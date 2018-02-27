#!/bin/sh

#ENV
BIN=${BIN:-"ss-server"}
SERVER=${SERVER:-"0.0.0.0"}
PORT=${PORT:-"8443"}
METHOD=${METHOD:-"chacha20-ietf-poly1305"}
PASSWORD=${PASSWORD:-"Shadowsocks"}
PLUGIN=${PLUGIN:-"obfs-server"}
PLUGIN_OPTS=${PLUGIN_OPTS:-"obfs=tls;failover=240.0.0.1:443"}
SS_OPTS=${SS_OPTS:-"-u"}
OPTS=${OPTS:-"-s ${SERVER} -p ${PORT} -m ${METHOD} -k ${PASSWORD} --plugin ${PLUGIN} --plugin-opts ${PLUGIN_OPTS} ${SS_OPTS}"}

PROXY=${PROXY:-""}
PROXYDNS=${PROXYDNS:-""}
PROXYCHAINS_CONF=${PROXYCHAINS_CONF:-"/tmp/proxychains.conf"}
PROXYLIST=${PROXYLIST:-"socks5 127.0.0.1 1080"}
PROXYCHAINS=${PROXYCHAINS:-"proxychains4 -f ${PROXYCHAINS_CONF}"}

#RUN
PROXYLIST_STR1=$(echo ${PROXYLIST} | awk -F' ' '{print $1}')
PROXYLIST_STR2=$(echo ${PROXYLIST} | awk -F' ' '{print $2}')
PROXYLIST_STR3=$(echo ${PROXYLIST} | awk -F' ' '{print $3}')
PROXYLIST_IP=$(getent hosts ${PROXYLIST_STR2} | awk '{print $1}')
PROXYLIST="${PROXYLIST_STR1} ${PROXYLIST_IP} ${PROXYLIST_STR3}"
if [ -n "${PROXYDNS}" ]; then
proxy_dns="proxy_dns"
fi
if [ -n "${PROXY}" ]; then
cat > ${PROXYCHAINS_CONF} <<EOF
strict_chain
quiet_mode
${proxy_dns}
localnet 127.0.0.0/255.0.0.0
localnet 10.0.0.0/255.0.0.0
localnet 172.16.0.0/255.240.0.0
localnet 192.168.0.0/255.255.0.0
[ProxyList]
${PROXYLIST}
EOF
nohup ${PROXYCHAINS} ${BIN} ${OPTS} >> /dev/stdout 2>&1 &
while sleep 60; do
if [ "${PROXYLIST_IP}" != "$(getent hosts ${PROXYLIST_STR2} | awk '{print $1}')" ]; then
PROXYLIST_IP=$(getent hosts ${PROXYLIST_STR2} | awk '{print $1}')
PROXYLIST="${PROXYLIST_STR1} ${PROXYLIST_IP} ${PROXYLIST_STR3}"
if [ -n "${PROXYDNS}" ]; then
proxy_dns="proxy_dns"
fi
if [ -n "${PROXY}" ]; then
cat > ${PROXYCHAINS_CONF} <<EOF
strict_chain
quiet_mode
${proxy_dns}
localnet 127.0.0.0/255.0.0.0
localnet 10.0.0.0/255.0.0.0
localnet 172.16.0.0/255.240.0.0
localnet 192.168.0.0/255.255.0.0
[ProxyList]
${PROXYLIST}
EOF
pkill ${BIN}
nohup ${PROXYCHAINS} ${BIN} ${OPTS} >> /dev/stdout 2>&1 &
fi
done
else
${BIN} ${OPTS}
fi
