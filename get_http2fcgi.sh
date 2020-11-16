#!/usr/bin/env bash

case "$OSTYPE" in
  darwin*)  os=darwin; ;;
  linux*)   os=linux; ;;
  *)        echo "unknown: $OSTYPE" ;;
esac

[[ -f http2fcgi ]] && exit
wget -nc -O - https://github.com/alash3al/http2fcgi/releases/download/v1.0.0/http2fcgi_${os}_amd64.zip | gunzip - > http2fcgi
chmod u+x http2fcgi

