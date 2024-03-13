#!/bin/bash

SPATH="$(realpath "$(dirname "$0")")"

mkdir -p "$HOME/.config/systemd/user/"

printf "%s" "[Unit]
Description=Visual Studio Code web server
Documentation=https://github.com/qwreey/vscode-server-autosetup

[Service]
ExecStart=$SPATH/start.sh
ExecReload=/bin/kill -s INT \$MAINPID
Restart=always

[Install]
WantedBy=default.target" > "$HOME/.config/systemd/user/code.service"

systemctl enable --now --user code.service
systemctl status --user code.service

