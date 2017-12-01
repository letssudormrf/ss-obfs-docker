# ss-obfs-docker

Quick Start
-----------

For docker run command.

    docker run -d -p 443:8443/tcp -p 443:8443/udp --name ss-obfs-docker letssudormrf/ss-obfs-docker

Keep the Docker container running automatically after starting, add **--restart always**.

    docker run --restart always -d -p 443:8443/tcp -p 443:8443/udp --name ss-obfs-docker letssudormrf/ss-obfs-docker
