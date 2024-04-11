#!/usr/bin/env python3

import hwdb
from datetime import datetime, timedelta
import math

dont_touch_hosts_older_than_x_hours = 72
alert_for_hosts_which_not_responed_more_than_hours = 3

# Вернуть True если время последней проверки старше X часов, в противном случае False
def calculateDifefrenceBetweenDatesInHours(currentdatetime: datetime, lastupdateddatetime: datetime, hoursdifference: int):
    difference = (currentdatetime - lastupdateddatetime)
    difhours = math.floor(difference.total_seconds()/60/60)
    if difhours >= hoursdifference:
        return True
    else: 
        return False

def runCheck():
    allhostsmacs = hwdb.getUniqueHostsMacs()
    ini_time_for_now = datetime.now()
    hosts_that_are_not_subject_to_verification = []
    hosts_that_are_in_subject_to_verification = []
    shutdown_hosts = []
    for mac in allhostsmacs:
        #TODO: 72 заменить на опцию (хосты, которые не определялись x дней - не проверять) из БД:
        notolderdays = calculateDifefrenceBetweenDatesInHours(ini_time_for_now, hwdb.getUpdatedAtByMacAddress(mac[0]), dont_touch_hosts_older_than_x_hours)
        if notolderdays != True:
            hosts_that_are_in_subject_to_verification.append(mac[0] + ' ' + str(hwdb.getUpdatedAtByMacAddress(mac[0])))
            #TODO: 3 заменить на опцию (алертить хосты, которые не отвечали x часов) из БД:
            olderthanhours = calculateDifefrenceBetweenDatesInHours(ini_time_for_now, hwdb.getUpdatedAtByMacAddress(mac[0]), alert_for_hosts_which_not_responed_more_than_hours)
            if olderthanhours == True:
                shutdown_hosts.append(mac[0] + ' ' + str(hwdb.getUpdatedAtByMacAddress(mac[0])))
                # print (mac[0] + ' ' + str(hwdb.getUpdatedAtByMacAddress(mac[0])))
            else:
                pass
        else:
            hosts_that_are_not_subject_to_verification.append(mac[0] + ' ' + str(hwdb.getUpdatedAtByMacAddress(mac[0])))

    print ('Total hosts in db: ' + str(len(allhostsmacs)))
    print ('Old hosts: '+str(len(hosts_that_are_not_subject_to_verification)))
    print ('Hosts in shutdown (need to alert): ' + str(len(shutdown_hosts)))
    print ('===========================================================')
    print ('Hosts that are not in online more than ' + str(dont_touch_hosts_older_than_x_hours) + ':')
    for host in hosts_that_are_not_subject_to_verification:
        print (host.split(' ')[0] + " ".join(hwdb.queryHostNameAndIpAddressByMacAddrress(host.split(' ')[0])) + ' - ' + host.split(' ')[1] + ' ' + host.split(' ')[2])
    print ('===========================================================')
    print ('Hosts that are not responding more than ' + str(alert_for_hosts_which_not_responed_more_than_hours) + ' hours:')
    for host in shutdown_hosts:
        print (host.split(' ')[0] + " ".join(hwdb.queryHostNameAndIpAddressByMacAddrress(host.split(' ')[0])) + ' - ' + host.split(' ')[1] + ' ' + host.split(' ')[2])

if __name__ == '__main__':
    runCheck()