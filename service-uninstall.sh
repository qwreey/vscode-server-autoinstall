#!/bin/bash

systemctl disable --user --now code.service
rm "$HOME/.config/systemd/user/code.service"

