#!/usr/bin/env bash
if [[ ! -f "ca/database.db" ]]; then
    touch ca/database.db
fi
if [[ ! -f "ca/serial" ]]; then
    echo "01" > ca/serial
fi
if [[ ! -f "request.conf" ]]; then
    cp request.example.conf request.conf
fi
if [[ ! -z "$1" ]]; then
    domain="$1"
else
    echo -n "Select your main domain name: "
    read domain
fi
if [[ ! -d "domains/$domain" ]]; then
    mkdir "domains/$domain"
fi
if [[ ! -f "domains/$domain/request.conf" ]];then
    cp request.conf "domains/$domain/request.conf"
fi
grep -Pzo '# --- cut --- #([\s\S]*)' "domains/$domain/request.conf" > "domains/$domain/request.extensions.conf"
index=1
domainfile="${domain}$index"
if [[ -f "domains/$domain/$domainfile.crt" ]]; then
    while [[ -f "domains/$domain/$domainfile.crt" ]]; do
        index=$(expr "$index" + 1)
        domainfile="${domain}$index"
    done
    openssl req -new -out "domains/$domain/$domainfile.csr" -key "domains/$domain/$domain.key" -config "domains/$domain/request.conf"
    if [[ !($? -eq 0) ]]; then
        echo FAILED
        exit
    fi
else
    openssl req -new -out "domains/$domain/$domainfile.csr" -keyout "domains/$domain/$domain.key" -config "domains/$domain/request.conf"
    cp "domains/$domain/$domain.key" "domains/$domain/$domain.key.pem"
fi
cp -L ca/ca.crt "domains/$domain/ca.crt"
cp "domains/$domain/ca.crt" "domains/$domain/ca.pem"

openssl ca -batch -config ./ca.conf -out "domains/$domain/$domainfile.crt" -extfile "domains/$domain/request.extensions.conf" -in "domains/$domain/$domainfile.csr"
if [[ $? -eq 0 ]]; then
    echo OK
else
    echo FAILED
    exit
fi
cat "domains/$domain/ca.crt" "domains/$domain/$domainfile.crt" > "domains/$domain/$domainfile.bundle.crt"
cp "domains/$domain/$domainfile.crt" "domains/$domain/$domainfile.crt.pem"
cp "domains/$domain/$domainfile.bundle.crt" "domains/$domain/$domainfile.bundle.pem"

if [[ -f "domains/$domain/$domain.crt.pem" ]]; then
    rm "domains/$domain/$domain.crt.pem"
    rm "domains/$domain/$domain.bundle.pem"
fi
cp "domains/$domain/$domainfile.crt.pem" "domains/$domain/$domain.crt.pem"
cp "domains/$domain/$domainfile.bundle.pem" "domains/$domain/$domain.bundle.pem"