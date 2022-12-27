
#! /usr/bin/env bash

[[ ${DEBUG_BASHRC} -eq 1 ]] && echo "rosenberg.golang.sh" && echo

if [[ "$OS" == "Linux" ]]; then
  export GOROOT=
else
# Only set the following on Mac; managed by the package manager on Linux
  export GOROOT="/usr/local/opt/go/libexec"
  export PATH="$PATH:$GOROOT/bin"
fi

export GOPATH="${HOME}/go"
export GO111MODULE=on
export PATH="$PATH:$GOPATH/bin"