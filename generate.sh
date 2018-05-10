#!/usr/bin/env bash
if [ ! -d "database" ]; then
    mkdir database
fi
if [ ! -f "./database/database.db" ]; then
    touch ./database/database.db
fi
if [ ! -f "./database/serial" ]; then
    echo "01" > ./database/serial
fi
echo -n "Select your main domain name: "
read domain
if [ ! -d "domains/$domain" ]; then
    mkdir domains/$domain
fi
openssl req -new -out domains/$domain/$domain.csr -keyout domains/$domain/$domain.key -config request.conf
cp request.conf domains/$domain/request.conf
cp ./ca/ca.crt domains/$domain/ca.crt
grep -Pzo '# --- cut --- #([\s\S]*)' request.conf > domains/$domain/request.extensions.conf

openssl ca -config ca.conf -out domains/$domain/$domain.crt -extfile domains/$domain/request.extensions.conf -in domains/$domain/$domain.csr
cat ./ca/ca.crt domains/$domain/$domain.crt > domains/$domain/$domain.bundle.crt
cp domains/$domain/ca.crt domains/$domain/ca.pem
cp domains/$domain/$domain.crt domains/$domain/$domain.crt.pem
cp domains/$domain/$domain.key domains/$domain/$domain.key.pem
cp domains/$domain/$domain.bundle.crt domains/$domain/$domain.bundle.pem