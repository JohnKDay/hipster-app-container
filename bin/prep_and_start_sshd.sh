#!/usr/bin/env bash

sudo -i -u hipster -- git clone https://github.com/johnkday/hipster-app

xpra start --start=multi-x-windows.sh --bind-tcp=0.0.0.0:14500 --ssl-cert=/usr/local/bin/ssl-cert.pem --ssl=on --html=on --tcp-auth=password:value=hipster

/usr/sbin/sshd -D


