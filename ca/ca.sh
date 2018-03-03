#!/usr/bin/env bash
cafile=ca.crt
if [ -f "ca.crt" ]; then
    cafile=ca2.crt
fi
openssl req -new -x509 -days 730 -keyout ca.key -out "$cafile" -config ca.request.conf