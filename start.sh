#!/bin/bash

SPATH="$(realpath "$(dirname "$0")")"

function _term() {
	printf '\rTerminate code process . . .'
	if [ "x$INSTALLPID" != "x" ]; then
		kill -s HUP "$INSTALLPID"
		wait "$INSTALLPID"
	fi
	if [ "x$CODEPID" != "x" ]; then
		kill -s HUP "$CODEPID"
		wait "$CODEPID"
	fi
	echo " [OK]"
	exit 0
}
trap "_term" TERM HUP INT

# Update code
"$SPATH/install.sh" &
INSTALLPID="$!"
wait "$INSTALLPID"
INSTALLCODE="$?"
INSTALLPID=""
[ "$INSTALLCODE" != "0" ] && exit "$INSTALLCODE"

# Create folders
[ ! -e "$SPATH/cli-data" ] && mkdir -p "$SPATH/cli-data"
[ ! -e "$SPATH/user-data" ] && mkdir -p "$SPATH/user-data"
[ ! -e "$SPATH/extensions" ] && mkdir -p "$SPATH/extensions"
[ ! -e "$SPATH/logs" ] && mkdir -p "$SPATH/logs"
[ ! -e "$SPATH/projects" ] && mkdir -p "$SPATH/projects"

# Check token
if [ ! -e "$SPATH/token" ]; then
	openssl rand -hex 16 > "$SPATH/token"
fi

# Run code server
LOG="$SPATH/logs/$(date +%Z-%Y.%m.%d-%H.%M.%S)"
"$SPATH/code" serve-web --connection-token "$(cat "$SPATH/token")" --accept-server-license-terms --port 9104 --cli-data-dir "$SPATH/cli-data" --user-data-dir "$SPATH/user-data" --extensions-dir "$SPATH/extensions" |& tee -a "$LOG" &
CODEPID="$!"
wait "$CODEPID"
CODECODE="$?"
CODEPID=""
exit "$CODECODE"

