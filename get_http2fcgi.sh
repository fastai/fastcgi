#!/usr/bin/env bash
set -e

nm=http2fcgi
case "$OSTYPE" in
  darwin*)  os=darwin; ;;
  linux*)   os=linux; ;;
  windows*) os=windows; ;;
  *)        echo "unknown: $OSTYPE" ;;
esac

[[ -f $nm ]] && exit
wget -qO- https://github.com/fastai/$nm/releases/latest/download/$nm-$os-amd64.tgz | tar xz
chmod u+x $nm

