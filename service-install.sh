#!/bin/bash

SPATH="$(realpath "$(dirname "$0")")"
SERVICE_FILE="$HOME/.config/systemd/user/code.service"

if [ -e "$SERVICE_FILE" ]; then
	echo "Service file $SERVICE_FILE exist"
	exit 1
fi

mkdir -p "$HOME/.config/systemd/user/"

printf "%s\n" "[Unit]
Description=Visual Studio Code web server
Documentation=https://github.com/qwreey/vscode-server-autosetup

[Service]
ExecStart=$SPATH/start.sh
ExecReload=/bin/kill -s INT \$MAINPID
Restart=always" > "$SERVICE_FILE"
[ ! -z "$PORT" ] && echo "Environment=\"PORT=$PORT\"" >> "$SERVICE_FILE"
[ ! -z "$HOST" ] && echo "Environment=\"HOST=$HOST\"" >> "$SERVICE_FILE"
[ ! -z "$TOKEN" ] && echo "Environment=\"TOKEN=$TOKEN\"" >> "$SERVICE_FILE"
printf "%s\n" "
[Install]
WantedBy=default.target" >> "$SERVICE_FILE"

systemctl enable --now --user code.service
systemctl status --user code.service

