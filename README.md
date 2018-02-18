# ss-obfs-docker

Quick Start
-----------

For docker run command.

    docker run -d -p 443:8443/tcp -p 443:8443/udp --name ss-obfs-docker letssudormrf/ss-obfs-docker

Keep the Docker container running automatically after starting, add **--restart always**.

    docker run --restart always -d -p 443:8443/tcp -p 443:8443/udp --name ss-obfs-docker letssudormrf/ss-obfs-docker

Use Proxychains4 to enable the socks5 proxy (socks5://proxycontainer:1080)

    docker run --network overlay -e PROXY="ON" -e PROXYLIST="socks5 proxycontainer 1080"

Settings
-----------

Default Environment:

```
BIN="ss-server"
SERVER="0.0.0.0"
PORT="8443"
PASSWORD="Shadowsocks"
PLUGIN="obfs-server"
PLUGIN_OPTS="obfs=tls;failover=240.0.0.1:443"
SS_OPTS="-u"
OPTS="-s ${SERVER} -p ${PORT} -m ${METHOD} -k ${PASSWORD} --plugin ${PLUGIN} --plugin-opts ${PLUGIN_OPTS} ${SS_OPTS}"
```

Change the Environment by **-e ENV="Value"**

    docker run -e PORT="443" -e PASSWORD="passwd" -e SS_OPTS="-u -t 300 -d 8.8.8.8" -e PLUGIN_OPTS="obfs=tls;failover=www.example.com:443" ...

Default entrypoint.sh:

```
${BIN} ${OPTS}
```
