#!/bin/bash

# A script to help me create a masked fastmail address and generate a good password.
# Uses maskedemail-cli https://github.com/dvcrn/maskedemail-cli and pwgen https://linux.die.net/man/1/pwgen

if [ -z "$1" ];
    then
        echo "Need a input ex keygen.sh facebook"
    else
        TOKEN=$(cat $HOME/.config/kpdb/token.key)
        maskedemail-cli -token $TOKEN create $1
        pwgen -s -c 64 -1
fi