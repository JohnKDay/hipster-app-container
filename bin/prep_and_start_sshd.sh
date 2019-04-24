#!/usr/bin/env bash

sudo -i -u hipster -- git clone https://github.com/johnkday/hipster-app

/usr/sbin/sshd -D
