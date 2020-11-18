#!/usr/bin/env bash
set -e

case "$OSTYPE" in
  darwin*)  os=darwin; ;;
  linux*)   os=linux; ;;
  windows*)   os=linux; ;;
  *)        echo "unknown: $OSTYPE" ;;
esac

[[ -f http2fcgi ]] && exit
wget --quiet -nc -O - https://github.com/fastai/http2fcgi/releases/latest/download/http2fcgi-${os}-amd64.tgz | tar xz
chmod u+x http2fcgi

