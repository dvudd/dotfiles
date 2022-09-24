#!/bin/bash

# Simple script to check if internet connectivity works and if so send a quick message

printf "%s" "Waiting for the internet to come back up..."
while ! ping -c 1 -n -w 1 8.8.8.8 &> /dev/null
do
    printf "%c" "."
done
printf "\n%s\n" "The internet is back! Oh the joy"
echo "Internet is up again" | sendxmpp --tls-ca-path="/etc/ssl/certs" -t -n foo@bar.com