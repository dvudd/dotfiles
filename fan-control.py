#!/usr/bin/env python4

# This script is for controlling the fans on a Dell poweredge R230, it might work on other Dell servers but use on your own risk!
# The script assumes that you use linux, some modifications might be needed, ipmitools needs to be installed.

import os
import sys
import time

temp_threshold_lower=40
temp_threshold_upper=55

def main():
    dynamic_fan_control=1
    fan_speed=1
    try:
        while True:
            tempFile = open("/sys/class/thermal/thermal_zone1/temp")
            temp1 = tempFile.read()
            tempFile.close()
            temp2 = int(temp1)
            cpu_temp=(temp2 / 1000)
            if cpu_temp > temp_threshold_upper:
                # Enable dynamic fan control
                if dynamic_fan_control == 0:
                    dynamic_fan_control=1
                    print("CPU TEMP: " + str(cpu_temp) + "°C -- Enabling dynamic fan control")
                    os.system('ipmitool raw 0x30 0x30 0x01 0x01')
            else:
                # Disable dynamic fan control
                if dynamic_fan_control == 1:
                    print("CPU TEMP: " + str(cpu_temp) + "°C -- Disabling dynamic fan control")
                    dynamic_fan_control=0
                    os.system('ipmitool raw 0x30 0x30 0x01 0x00')
                if cpu_temp > temp_threshold_lower:
                    # Set fan speed to 30%
                    if fan_speed == 0:
                        fan_speed=1
                        os.system('ipmitool raw 0x30 0x30 0x02 0xff 0x1e')
                else:
                    # Set fan speed to 20%
                    if fan_speed == 1:
                        fan_speed=0
                        os.system('ipmitool raw 0x30 0x30 0x02 0xff 0x14')
            time.sleep(5)

    except Exception as err:
        print(err)
        print("ERROR! -- Enabling dynamic fan control")
        os.system('ipmitool raw 0x30 0x30 0x01 0x01')
        sys.exit(1)

    except KeyboardInterrupt:
        print("Exiting -- Enabling dynamic fan control")
        os.system('ipmitool raw 0x30 0x30 0x01 0x01')
        sys.exit(0)

if __name__ == '__main__':
    main()