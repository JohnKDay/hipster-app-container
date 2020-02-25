#!/usr/bin/env bash


#openssl s_client -showcerts -connect ciscoharbor.10.100.51.200.sslip.io:30003 </dev/null 2>/dev/null|sudo openssl x509 -outform PEM | sudo tee /etc/docker/certs.d/ciscoharbor.10.100.51.200.sslip.io:30003/ca.crt


H=ciscoharbor.10.100.51.200.sslip.io:30003

openssl s_client -showcerts -connect ${H} </dev/null 2>/dev/null|sudo openssl x509 -outform PEM | tee ${H}_CA.crt 
