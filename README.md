
# vscode-server-autoinstall

Simple vscode auto update/auto install system.
Works on systemd based system. (or, write the service file yourself)

# Install

Clone the repo to your server.
Then run 'service-install.sh' file. (You can chage host and port)
```
git clone https://github.com/qwreey/vscode-server-autoinstall.git "$HOME/code" --depth 1
cd "$HOME/code"
HOST=127.0.0.1 PORT=9104 ./service-install.sh
```

