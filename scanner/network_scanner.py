#!/usr/bin/env python3

import ipaddress
import config
import socket
import hwdb
from datetime import datetime
import subprocess
import shlex
import re
import sys
import sshwmiget
sys.dont_write_bytecode = True

def scan(addr):
   s = socket.socket(socket.AF_INET,socket.SOCK_STREAM)
   socket.setdefaulttimeout(1)
   result = s.connect_ex((addr,135))
   if result == 0:
      return 1
   else :
      return 0


def get_fast_scan_one_host(host):
    nmapcommand = "nmap -T5 -sT -p 135 -n "+host+" --open -oG -"
    args = shlex.split(nmapcommand)
    nmout = subprocess.run(args, universal_newlines=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE).stdout
    for line in nmout.split('\n'):
        if re.search('Up', line):
            return 1
        else:
            return 0


def get_life_hosts():
    live_hosts = []
    networksforscan = hwdb.getHostsWithCredentials()
    for nets in networksforscan:
        hosts = []
        for i in list(ipaddress.ip_network(nets[0]).hosts()):
            hosts.append(str(i))
        if int(nets[0].split("/")[1]) > 31:
            hosts.append(nets[0].split("/")[0])
        else:
            pass
        # print ('Total hosts for scan: '+str(len(hosts)))
        user = nets[1]
        password = nets[2]
        for h in hosts:
            # print (h+' '+user+' '+password)
            # check_host = scan(str(h))
            check_host = get_fast_scan_one_host(str(h))
            if (check_host == 1):
                hostandcredentials = []
                hostandcredentials.append(str(h))
                hostandcredentials.append(user)
                hostandcredentials.append(password)
                live_hosts.append(hostandcredentials)
            else:
                pass
    # print ('Live hosts found: '+str(len(live_hosts)))
    return live_hosts

def get_fast_live_hosts():
    networksforscan = hwdb.getHostsWithCredentials()
    print ('Total networks/hosts for scan: '+str(len(networksforscan)))
    live_hosts = []
    for i in networksforscan:
        nmapcommand = "nmap -T5 -sT -p 135 -n "+i[0]+" --open -oG -"
        args = shlex.split(nmapcommand)
        nmout = subprocess.run(args, universal_newlines=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE).stdout
        for line in nmout.split('\n'):
            if re.search('Up', line):
                lh = []
                lh.append(line.split(' ')[1])
                lh.append(i[1])
                lh.append(i[2])
                lh.append(i[3])
                live_hosts.append(lh)
            else:
                pass
    print ('Live hosts found: '+str(len(live_hosts)))
    return live_hosts
