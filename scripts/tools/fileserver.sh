caddy file-server --browse --listen :8000 --root ./
rclone serve http . --addr :8000
