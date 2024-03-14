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
[ ! -e "$SPATH/custom" ] && mkdir -p "$SPATH/custom"

# Run code server
LOG="$SPATH/logs/$(date +%Z-%Y.%m.%d-%H.%M.%S)"
codeargs=()
if [ -e "$SPATH/token" ]; then
	# import token
	codeargs+=( "--connection-token" "$(cat "$SPATH/token")" )
elif [ ! -z "$TOKEN" ]; then
	codeargs+=( "--connection-token" "$TOKEN" )
else
	# without token
	codeargs+=( "--without-connection-token" )
fi
if [ ! -z "$PORT" ]; then
	codeargs+=( "--port" "$PORT" )
fi
if [ ! -z "$HOST" ]; then
	codeargs+=( "--host" "$HOST" )
fi

"$SPATH/code" serve-web --accept-server-license-terms --cli-data-dir "$SPATH/cli-data" --user-data-dir "$SPATH/user-data" --extensions-dir "$SPATH/extensions" ${codeargs[@]} |& tee -a "$LOG" &
CODEPID="$!"
wait "$CODEPID"
CODECODE="$?"
CODEPID=""
exit "$CODECODE"

