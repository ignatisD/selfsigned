#!/usr/bin/env bash
CAKEYFILE=ca.key
if [[ ! -f "$CAKEYFILE" ]]; then
    openssl genrsa -out ca.key 2048
fi
index=1
CAFILE="ca$index.crt"
while [[ -f "$CAFILE" ]]; do
	index=$(expr "$index" + 1)
	CAFILE="ca$index.crt"
done
openssl req -new -x509 -days 3650 -key "$CAKEYFILE" -out "$CAFILE" -config ca.request.conf
if [[ $? -eq 0 ]]; then
    echo OK
else
    echo FAILED
    exit
fi
if [[ -f ca.crt ]]; then
    rm ca.crt
fi
cp "$CAFILE" ca.crt
