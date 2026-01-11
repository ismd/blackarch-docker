# BlackArch Docker

Docker image based on [BlackArch Linux](https://github.com/BlackArch/blackarch-docker) with browser-accessible GUI.

## Quick Start

**Terminal mode (default):**
```bash
docker run -it --rm -v "$PWD":/app ismd/blackarch
```

**GUI mode (noVNC):**
```bash
docker run -d --security-opt seccomp=unconfined -p 8080:8080 -v "$PWD":/app --name ismd-blackarch ismd/blackarch /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf
```
Open http://localhost:8080 — **Login:** `root` / `blackarch`
