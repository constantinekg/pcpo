#!/usr/bin/env python3

import threading
import network_scanner
import wmiget
import hwdb
import notify
import config
import time
import datetime
import sys
sys.dont_write_bytecode = True

# Enable/disable logging
if (hwdb.getOptionByName('scanner_debug_mode_enabled') == '1'):
    import logging
    if (hwdb.getOptionByName('scanner_debug_level') == '1'):
        logging.basicConfig(format='%(asctime)s - %(name)s - %(levelname)s - %(message)s', level=logging.INFO)
    elif (hwdb.getOptionByName('scanner_debug_level') == '2'):
        logging.basicConfig(format='%(asctime)s - %(name)s - %(levelname)s - %(message)s', level=logging.CRITICAL)
    elif (hwdb.getOptionByName('scanner_debug_level') == '3'):
        logging.basicConfig(format='%(asctime)s - %(name)s - %(levelname)s - %(message)s', level=logging.DEBUG)
    else:
        pass
    logger = logging.getLogger(__name__)
else:
    pass
 
total = 0
count_live_hosts = 0
failedhosts = []
newhosts = []
totalchanges = {'ipaddresschanges':0, 'hostnamechanges':0, 'motherboardchanges':0, 'cpuchanges':0, 'ramchanges':0, 'videochanges':0, 'hddchanges':0}
changestosendbyemail = []
lock = threading.Lock()

ts = time.time()
begin_at = datetime.datetime.fromtimestamp(ts).strftime('%Y-%m-%d %H:%M:%S') # get start time


def update_total(amount):
    """
    Updates the total by the given amount
    """
    global total
    with lock:
        total += amount


def getHostsInfoByChunks(chunk):
    global totalchanges
    global changestosendbyemail
    global count_live_hosts
    global failedhosts
    global newhosts
    print (chunk)
    for i in chunk:
        hostfromscan = wmiget.gethostinfo(i[0],i[1],i[2])
        if hostfromscan != None:
            with lock:
                count_live_hosts += 1
            print ('host scanned: '+i[0])
            hostfromdb = hwdb.queryLastConfigurationByMacAddrress(hostfromscan[2])
            if hostfromdb == False:
                hwdb.addNewConfigurationToDB(hostfromscan)
                message_about_new_configuration = 'New configuration has been found, making a new record for '+hostfromscan[0]
                print (message_about_new_configuration)
                newhosts.append(hostfromscan[0])
                notify.notifyAboutNewConfiguration(message_about_new_configuration)
            else:
                diff = hwdb.compareConfigurations(hostfromscan, hostfromdb)
                totalchanges['ipaddresschanges'] += int(diff[1]['ipaddresschanges'])
                totalchanges['hostnamechanges'] += int(diff[1]['hostnamechanges'])
                totalchanges['motherboardchanges'] += int(diff[1]['motherboardchanges'])
                totalchanges['cpuchanges'] += int(diff[1]['cpuchanges'])
                totalchanges['ramchanges'] += int(diff[1]['ramchanges'])
                totalchanges['videochanges'] += int(diff[1]['videochanges'])
                totalchanges['hddchanges'] += int(diff[1]['hddchanges'])
                if len(diff[0]) != 0:
                    message_about_difference = 'Difference on host '+hostfromscan[0]+' has been found!'
                    print (message_about_difference)
                    print (diff[0])
                    changes = ''
                    for i in diff[0]:
                        changes+=i+' | '
                        changestosendbyemail.append("Host: "+hostfromscan[0]+"\n"+i+' | ')
                    notify.notifyAboutChangesInConfiguration(hostfromscan[0], changes)
                    hwdb.addNewConfigurationToDB(hostfromscan)
                else:
                    pass
        else:
            print ('host scan failed: '+i[0])
            failedhosts.append(i[0])
    


def runMultithread(chunkedhostslst):
    threads = list()
    for i in range(len(chunkedhostslst)):
        scanthread = threading.Thread(target=getHostsInfoByChunks, args=(chunkedhostslst[i],))
        threads.append(scanthread)
        scanthread.start()
    threads_running_state = True
    while threads_running_state != False:
        runstate = []
        for index, thread in enumerate(threads):
            if thread.is_alive():
                runstate.append(1)
            else:
                pass
        if 1 in runstate:
            threads_running_state = True
        else:
            threads_running_state = False
            break

def mainfunc():
    ts = time.time()
    begin_at = datetime.datetime.fromtimestamp(ts).strftime('%Y-%m-%d %H:%M:%S')
    hosts = network_scanner.get_fast_live_hosts()
    hostschunkssize = round(len(hosts)/int(hwdb.getOptionByName('maxscanthreads')))
    if (hostschunkssize <=0):
        hostschunkssize = 2
    else:
        pass
    lol = lambda lst, sz: [lst[i:i+sz] for i in range(0, len(lst), sz)]
    chunkedhostslst = lol(hosts, hostschunkssize)
    runMultithread(chunkedhostslst)
    te = time.time()
    end_at = datetime.datetime.fromtimestamp(te).strftime('%Y-%m-%d %H:%M:%S')
    hwdb.addToScanStat(count_live_hosts, len(failedhosts), len(newhosts), totalchanges['ipaddresschanges'], totalchanges['hostnamechanges'], totalchanges['motherboardchanges'], totalchanges['cpuchanges'], totalchanges['ramchanges'], totalchanges['videochanges'], totalchanges['hddchanges'], begin_at, end_at)
    if (len(failedhosts) > 0):
        print ('Failed hosts by scan: '+str(len(failedhosts)))
    else:
        pass
    if (len(newhosts) > 0):
        print ('New hosts by scan: '+str(len(newhosts)))
    else:
        pass
    if (count_live_hosts == 0):
        notify.notifyAboutScanFailByZeroLiveHosts('Проверка, начавшаяся в '+str(begin_at)+' завершилась неудачно. Не проверено ни одного хоста!')
    else:
        notify.mailReportAboutScan(changestosendbyemail,failedhosts,newhosts)
    print ('Begin time: '+begin_at)
    print('End time: '+end_at)
    print ('Successfully verified hosts: '+str(count_live_hosts))


    
 
if __name__ == '__main__':
    mainfunc()
