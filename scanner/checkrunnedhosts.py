#!/usr/bin/env python3

import hwdb
import notify
from datetime import datetime, timedelta
import math

dont_touch_hosts_older_than_x_hours = int(hwdb.getOptionByName('telegram_old_shutdown_hosts_time'))
alert_for_hosts_which_not_responed_more_than_hours = int(hwdb.getOptionByName('telegram_new_shutdown_hosts_time'))

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
    shutdownhostsreport = ''
    shutdownhostsreport += ('Total hosts in db: ' + str(len(allhostsmacs))) + "\n"
    shutdownhostsreport += ('Old hosts: '+str(len(hosts_that_are_not_subject_to_verification))) + "\n"
    shutdownhostsreport += ('Hosts in shutdown (need to alert): ' + str(len(shutdown_hosts))) + "\n"
    shutdownhostsreport += ('===========================================================') + "\n"
    shutdownhostsreport += ('Hosts that are not in online more than ' + str(dont_touch_hosts_older_than_x_hours) + ':') + "\n"
    oldshutdownedhosts = ''
    for host in hosts_that_are_not_subject_to_verification:
        oldshutdownedhost = (host.split(' ')[0] + " " + " ".join(hwdb.queryHostNameAndIpAddressByMacAddrress(host.split(' ')[0])) + ' - ' + host.split(' ')[1] + ' ' + host.split(' ')[2]) + "\n"
        shutdownhostsreport += oldshutdownedhost
        if (hwdb.getOptionByName('telegram_notify_about_old_shutdown_hosts') == '1'):
            oldshutdownedhosts += oldshutdownedhost
        else:
            pass
    if (hwdb.getOptionByName('telegram_notify_about_old_shutdown_hosts') == '1'):
        notify.notifyAboutShutdwonHostsIntoTelegram(oldshutdownedhosts)
    else:
        pass
    shutdownhostsreport += ('===========================================================')
    shutdownhostsreport += ('Hosts that are not responding more than ' + str(alert_for_hosts_which_not_responed_more_than_hours) + ' hours:') + "\n"
    for host in shutdown_hosts:
        newshutdowndehost = (host.split(' ')[0] + " " + " ".join(hwdb.queryHostNameAndIpAddressByMacAddrress(host.split(' ')[0])) + ' - ' + host.split(' ')[1] + ' ' + host.split(' ')[2]) + "\n"
        shutdownhostsreport += newshutdowndehost
        if (hwdb.getOptionByName('telegram_notify_about_new_shutdown_hosts') == '1'):
            notify.notifyAboutShutdwonHostsIntoTelegram(newshutdowndehost, '<b>NEW SHUTDOWN HOST:</b>')
        else:
            pass
    if (hwdb.getOptionByName('scanner_debug_mode_enabled') == '1'):
        print (shutdownhostsreport)
    else:
        pass
    if (hwdb.getOptionByName('email_about_shutdown_hosts') == '1'):
        notify.mailAboutShutdownHosts(shutdownhostsreport)
    else:
        pass

if __name__ == '__main__':
    runCheck()