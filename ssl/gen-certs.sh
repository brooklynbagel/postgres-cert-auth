#!/usr/bin/env bash

set -e

rm -f *.csr *.crt *.key *.srl

# root ca cert
openssl req -new -nodes -text -out root.csr \
  -keyout root.key -subj "/CN=root"
openssl x509 -req -in root.csr -text -days 365 \
  -extfile openssl.cnf -extensions v3_ca \
  -signkey root.key -out root.crt

# server cert
openssl req -new -nodes -text -out server.csr \
  -keyout server.key -subj "/CN=localhost"
openssl x509 -req -in server.csr -text -days 365 \
  -CA root.crt -CAkey root.key -CAcreateserial \
  -out server.crt

# user cert
openssl req -new -nodes -text -out testuser.csr \
  -keyout testuser.key -subj "/CN=testuser"
openssl x509 -req -in testuser.csr -text -days 365 \
  -CA root.crt -CAkey root.key -CAcreateserial \
  -out testuser.crt
