#!/bin/bash

# Reads the temperature readings from the server and the NVME SSD

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

echo "================== DELL R230 ====================="
ipmitool sdr type Temperature
ipmitool sdr type Fan
echo "------------------ NVME SSD  ---------------------"
nvme smart-log /dev/nvme0 | grep -i '^temperature'
echo "=================================================="