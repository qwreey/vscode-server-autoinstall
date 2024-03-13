#!/bin/bash

SPATH="$(realpath "$(dirname "$0")")"
ARCH="$(uname -m)"

# Check arch and get url
if [ "$ARCH" == "x86_64" ]; then
	URL="https://code.visualstudio.com/sha/download?build=stable&os=cli-alpine-x64"
elif [ "$ARCH" == "aarch64_be" ] ||\
	[ "$ARCH" == "aarch64" ] ||\
	[ "$ARCH" == "armv8b" ] ||\
	[ "$ARCH" == "armv8l" ]; then
	URL="https://code.visualstudio.com/sha/download?build=stable&os=cli-alpine-arm64"
elif [ "$ARCH" == "arm" ]; then
	URL="https://code.visualstudio.com/sha/download?build=stable&os=cli-alpine-arm32"
else
	>&2 echo "Unknown arch $ARCH"
	exit 1
fi

# Check version
echo "Fetch version from code.visualstudio.com"
LATEST="$(curl $URL --silent | sed -r 's|Found\. Redirecting to https://vscode.download.prss.microsoft.com/dbazure/download/stable/||;s|/.*||')"
if [ -e "$SPATH/version-sha" ]; then
	CURRENT="$(cat "$SPATH/version-sha")"
	[ "x$CURRENT" == "x$LATEST" ] && echo "Up to date." && exit 0
fi
printf "%s" "$LATEST" > "$SPATH/version-sha"

# Download
echo "Downloading . . ."
curl -L "$URL" | tar xfz - -C "$SPATH"

exit "$?"

