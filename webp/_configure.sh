#!/bin/bash

set -eu

./configure \
  --prefix="/usr" \
  --sysconfdir="/etc" \
  --enable-libwebpmux \
  --enable-libwebpdemux
