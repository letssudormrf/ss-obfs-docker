#!/bin/sh

SERVER=${SERVER:-"0.0.0.0"}
PORT=${PORT:-"8443"}
METHOD=${METHOD:-"chacha20-ietf-poly1305"}
PASSWORD=${PASSWORD:-"Shadowsocks"}
PLUGIN=${PLUGIN:-"obfs-server"}
PLUGIN_OPTS=${PLUGIN_OPTS:-"obfs=tls;failover=240.0.0.1:443"}
SS_OPTS=${SS_OPTS:-"-u"}

ss-server -s ${SERVER} -p ${PORT} -m ${METHOD} -k ${PASSWORD} --plugin ${PLUGIN} --plugin-opts ${PLUGIN_OPTS} ${SS_OPTS}
