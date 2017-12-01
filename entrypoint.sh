#!/bin/sh

SERVER=${SERVER:-"0.0.0.0"}
PORT=${PORT:-"8443"}
METHOD=${METHOD:-"chacha20-ietf-poly1305"}
PASSWORD=${PASSWORD:-"Shadowsocks"}
PLUGIN=${PLUGIN:-"obfs-server"}
PLUGIN_OPTS=${PLUGIN_OPTS:-"obfs=tls;failover=www.redhat.com"}

ss-server -s ${SERVER} -p ${PORT} -m ${METHOD} -k ${PASSWORD} --plugin ${PLUGIN} --plugin-opts ${PLUGIN_OPTS}
