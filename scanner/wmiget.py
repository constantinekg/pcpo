#!/usr/bin/env python3

# https://docs.microsoft.com/en-us/windows/win32/cimwin32prov/win32-videocontroller


# Computer make and model, Computer type, Domain role 	Win32_ComputerSystem
# Chassis type 	Win32_SystemEnclosure
# Motherboard 	Win32_BaseBoard
# Devices on motherboard 	Win32_OnBoardDevice
# CPU 	Win32_Processor
# BIOS 	Win32_BIOS
# Memory 	Win32_PhysicalMemoryArray
#   	Win32_PhysicalMemory

# Display settings 	Win32_DesktopMonitor
#   	Win32_VideoController
# Input device 	Win32_Keyboard
#   	Win32_PointingDevice
# Hardware ports 	Win32_ParallelPort
#   	Win32_SerialPort
#   	Win32_USBHub
#   	Win32_USBController

# Win32_NetworkAdapter 	Works with physical adapters
# Win32_NetworkAdapterConfiguration 	Works with adapter settings
# Win32_NetworkAdapterSetting 	Associates Win32_NetworkAdapter and Win32_NetworkAdapterConfiguration
# Win32_NetworkConnection 	Displays information about the active network connections on a Windows system
# Win32_NetworkProtocol 	Displays the network protocols and their characteristics associated with an adapter
# Win32_NetworkClient 	Displays information regarding the network client software installed on the system
# Win32_IP4RouteTable 	Displays information about IP routing from the system

# win32_DiskDrive   Get info about hard drives
# Win32_Process     Get windows processes
# Win32_Service     Get windows services

import wmi_client_wrapper as wmi
import sh
import mock
import config
import network_scanner
import hwdb
import notify
import re
import time
import datetime
# import logging

# # Enable logging
# logging.basicConfig(
#     format='%(asctime)s - %(name)s - %(levelname)s - %(message)s', level=logging.INFO
# )

# logger = logging.getLogger(__name__)

# Find word in string
def findWholeWord(w):
    return re.compile(r'\b({0})\b'.format(w), flags=re.IGNORECASE).search

#Get keyboards and mouses DeviceID
def get_keyboards_and_mouses(ipaddr, user, password):
    wmic = wmi.WmiClientWrapper(
    username=user,
    password=password,
    host=ipaddr,
    )
    try:
        keyboard = wmic.query("SELECT * FROM Win32_Keyboard")
        mouse = wmic.query("SELECT * FROM Win32_PointingDevice")
        for kb in keyboard:
            print (kb['SystemName']+' | '+kb['Description']+' keyboard | '+kb['DeviceID'])
        for ms in mouse:
            print (ms['SystemName']+' | '+ms['Description']+' mouse | '+ms['DeviceID'])
    except:
        pass
    else:
        pass


#Get full info about host
def gethostinfo(ipaddr, user, password):
    wmic = wmi.WmiClientWrapper(
    username=user,
    password=password,
    host=ipaddr,
    )
    try:
        systeminfo = []
        systeminfo.append(ipaddr)
        networkadapters = wmic.query("SELECT * FROM Win32_NetworkAdapterConfiguration")
        system = wmic.query("SELECT * FROM Win32_Processor")
        video = wmic.query("SELECT * FROM Win32_VideoController")
        baseboard = wmic.query("SELECT * FROM Win32_BaseBoard")
        memtype = wmic.query("SELECT * from Win32_PhysicalMemoryArray")
        hdds = wmic.query("SELECT Caption,Size,SerialNumber from win32_DiskDrive")
        memoryerrorcorrectiontype = 'None-other'
        if (int(memtype[0]['MemoryErrorCorrection']) == 5 or int(memtype[0]['MemoryErrorCorrection']) == 6):
            memoryerrorcorrectiontype = 'ECC'
        elif (int(memtype[0]['MemoryErrorCorrection']) > 6):
            memoryerrorcorrectiontype = 'CRC'
        else:
            pass
        memory = wmic.query("SELECT * FROM Win32_PhysicalMemory")
        mem = ''
        for i in memory:
            mem += str(i['Manufacturer']).strip()+' '+str(round(int(i['Capacity'])/1024/1024)).strip()+' Mb s/n: '+str(i['SerialNumber']).strip()+' '+memoryerrorcorrectiontype+', '
        # print (system[0]['SystemName'])
        systeminfo.append(str(system[0]['SystemName']))
        # print (networkadapters)
        for nd in networkadapters:
            # print (nd['MACAddress'])
            # if len(re.findall(":", str(nd['MACAddress']))) == 5 and findWholeWord('WAN Miniport')(str(nd['Description'])) == None:
            if len(re.findall(":", str(nd['MACAddress']))) == 5 and findWholeWord('WAN Miniport')(str(nd['Description'])) == None \
                and findWholeWord('RAS Async')(str(nd['Description'])) == None:
                systeminfo.append(str(nd['MACAddress']))
            else:
                pass
        if len(baseboard) > 0:
            mbinfo = str(baseboard[0]['Manufacturer']+' '+str(baseboard[0]['Product']))
            if (findWholeWord('Default')(baseboard[0]['SerialNumber']) == None and findWholeWord('Filled')(baseboard[0]['SerialNumber']) == None and len(baseboard[0]['SerialNumber']) > 2):
                mbinfo += ' S/N:'+str(baseboard[0]['SerialNumber'])
            else:
                pass
        else:
            mbinfo = 'NoName baseboard S/N: NoSerialNumber'
        systeminfo.append(mbinfo)
        # print ('CPU: '+str(system[0]['Name']))
        cpuinfo = str(system[0]['Name'])
        # # print (system[0]['SerialNumber'])
        if 'SerialNumber' in system[0]:
            if (findWholeWord('Default')(system[0]['SerialNumber']) == None and findWholeWord('Filled')(system[0]['SerialNumber']) == None and len(system[0]['SerialNumber']) > 2):
                cpuinfo += ' S/N:'+str(system[0]['SerialNumber'])
            else:
                pass
        else:
            cpuinfo += ' S/N: NoSerialNumber'
        systeminfo.append(cpuinfo)
        # # print('RAM: '+str(mem))
        systeminfo.append(mem)
        # # print ('Video: '+str(video[0]['Name']))
        systeminfo.append(str(video[0]['Name'])+' '+str(video[0]['PNPDeviceID']))
        ddrives = ''
        for i in hdds:
            ddrive = str(i['Caption'])+' s/n: '+str(i['SerialNumber']).strip()+' size: '+str(int(int(i['Size'])/1000000000))+'GB, '
            if (findWholeWord('iSCSI')(str(i['Caption'])) == None and hwdb.getOptionByName('hdd_add_iscsi_drives') == '1'):
                ddrives += ddrive
        #         # print ('iscsi found')
            elif (findWholeWord('USB')(str(i['Caption'])) != None and hwdb.getOptionByName('hdd_add_usb_drives') == '1'):
                ddrives += ddrive
        #         # print ('usb found')
            elif (findWholeWord('USB')(str(i['Caption'])) == None and findWholeWord('iSCSI')(str(i['Caption'])) == None):
                ddrives += ddrive
            else:
                pass
        systeminfo.append(ddrives)
        # print ('--------')
        # print (systeminfo)
        return systeminfo
    except:
        pass
    else:
        pass



# Get procs ONLY if they are running from e:\ or d:\ hard drive
# def get_games_procs(ipaddr):
#     wmic = wmi.WmiClientWrapper(
#     username=config.wmi_username,
#     password=config.wmi_password,
#     host=ipaddr,
#     )
#     try:
#         proc = wmic.query("SELECT * FROM Win32_Process")
#         for key in proc:
#             if (key['ExecutablePath'] is not None and key['CSName'] is not None and key['Name'] is not None):
#                 if ("E:\\" in key['ExecutablePath'] or "D:\\" in key['ExecutablePath']):
#                     print (key['CSName']+' '+key['Name']+' '+key['ExecutablePath'])
#                 else:
#                     pass
#             else:
#                 pass
#     except:
#         pass
#     else:
#         pass


def mainfunction():
    ts = time.time()
    begin_at = datetime.datetime.fromtimestamp(ts).strftime('%Y-%m-%d %H:%M:%S')
    # live_hosts = network_scanner.get_life_hosts()
    live_hosts = network_scanner.get_fast_live_hosts()
    count_live_hosts = 0
    totalchanges = {'ipaddresschanges':0, 'hostnamechanges':0, 'motherboardchanges':0, 'cpuchanges':0, 'ramchanges':0, 'videochanges':0}
    changestosendbyemail = []
    for lh in live_hosts:
        hostfromscan = gethostinfo(lh[0], lh[1], lh[2])
        if hostfromscan != None:
            count_live_hosts += 1
            hostfromdb = hwdb.queryLastConfigurationByMacAddrress(hostfromscan[2])
            if hostfromdb == False:
                hwdb.addNewConfigurationToDB(hostfromscan)
                message_about_new_configuration = 'New configuration has been found, making a new record for '+hostfromscan[0]
                print (message_about_new_configuration)
                notify.notifyAboutNewConfiguration(message_about_new_configuration)
            else:
                diff = hwdb.compareConfigurations(hostfromscan, hostfromdb)
                totalchanges['ipaddresschanges'] += int(diff[1]['ipaddresschanges'])
                totalchanges['hostnamechanges'] += int(diff[1]['hostnamechanges'])
                totalchanges['motherboardchanges'] += int(diff[1]['motherboardchanges'])
                totalchanges['cpuchanges'] += int(diff[1]['cpuchanges'])
                totalchanges['ramchanges'] += int(diff[1]['ramchanges'])
                totalchanges['videochanges'] += int(diff[1]['videochanges'])
                if len(diff[0]) != 0:
                    message_about_difference = 'Difference on host '+hostfromscan[0]+' has been found!'
                    print (message_about_difference)
                    print (diff[0])
                    changes = ''
                    for i in diff[0]:
                        changes+=i+' | '
                        changestosendbyemail.append("Host: "+lh[0]+"\n"+i+' | ')
                    notify.notifyAboutChangesInConfiguration(hostfromscan[0], changes)
                    hwdb.addNewConfigurationToDB(hostfromscan)
                else:
                    pass
            print ('Host '+hostfromscan[1]+' ('+hostfromscan[2]+') comparing has been completed')
            print ('----------------------------------------------------')
        else:
            pass
    te = time.time()
    end_at = datetime.datetime.fromtimestamp(te).strftime('%Y-%m-%d %H:%M:%S')
    hwdb.addToScanStat(count_live_hosts, totalchanges['ipaddresschanges'], totalchanges['hostnamechanges'], totalchanges['motherboardchanges'], totalchanges['cpuchanges'], totalchanges['ramchanges'], totalchanges['videochanges'], begin_at, end_at)
    if (count_live_hosts == 0):
        notify.notifyAboutScanFailByZeroLiveHosts('Проверка, начавшаяся в '+str(begin_at)+' завершилась неудачно. Не проверено ни одного хоста!')
    else:
        pass
    print ('Live hosts total: '+str(count_live_hosts))
    print (begin_at)
    print (end_at)
    print (', '.join("{!s}={!r}".format(key,val) for (key,val) in totalchanges.items()))
    notify.mailAboutConfChanges(changestosendbyemail)


