#!/usr/bin/env python3

# Monitor your connection to the internet by pinging $PINGTARGET
# It logs the time when to connection is lost and when it's restored as a CSV in data.csv

import socket
import time
import datetime
import os
import csv
import sys

PINGTAGET="1.1.1.1"
DB_LOC="/opt/wan_monitor"

os.chdir(DB_LOC)

def record_file_exist():
    return os.path.isfile('data.csv')

def create_record_file():
    with open('data.csv', 'a') as csvfile:
        columns = ['connection_lost', 'connection_restored', 'down_time']
        writer = csv.DictWriter(csvfile, fieldnames=columns)
        writer.writeheader()

def send_ping_request(host=PINGTAGET, port=53, timeout=3):
    try:
        socket.setdefaulttimeout(timeout)
        s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        s.connect((host,port))
    except OSError as error:
        return False
    except Exception as err:
        print(err)
        sys.exit(1)
    except KeyboardInterrupt:
        sys.exit(0)
    else:
        s.close()
        return True

def current_timestamp():
    return datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")

def calculate_time(start, stop):
    time_difference = stop - start
    seconds = float(str(time_difference.total_seconds()))
    return str(datetime.timedelta(seconds=seconds)).split(".")[0]

def main(ping_freq=2):
    while True:
        if send_ping_request():
            time.sleep(ping_freq)
        else:
            down_time = datetime.datetime.now()
            print("WAN Lost connection")
            with open('data.csv', 'a') as csvfile:
                columns = ['connection_lost', 'connection_restored', 'down_time']
                writer = csv.DictWriter(csvfile, fieldnames=columns)
                writer.writerow({'connection_lost': str(current_timestamp())})
            while not send_ping_request():
                time.sleep(1)
            
            up_time = datetime.datetime.now()  
            calc_down_time = calculate_time(down_time, up_time)
            print("WAN connection restored!")

            with open('data.csv', 'r') as f:
                reader = csv.DictReader(f, delimiter=',')
                rows = list(reader)
                rows[-1].update({'connection_restored': str(current_timestamp()), 'down_time': calc_down_time})

            with open('data.csv', 'w') as f:
                writer = csv.DictWriter(f, fieldnames = rows[-1].keys())
                writer.writeheader()
                writer.writerows(rows)

            # Since I couldn't get xmpppy to work to save my life, I resorted to use sendxmpprc instead.
            # Note: $XMPP_TARGET is a global variable leading to my XMPP address
            xmpp_message = "Internet connectivity was lost! The connection was restored at " + str(up_time).split(".")[0] + " and lasted for " + calc_down_time
            os.system('echo ' + xmpp_message + ' | sendxmpp --tls-ca-path="/etc/ssl/certs" -t -n $XMPP_TARGET')
            
if not record_file_exist():
        create_record_file()
main()