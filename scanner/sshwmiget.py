#!/usr/bin/env

# get mac and ip addresses exmaple:
# ssh administrator@192.168.162.4 'powershell -command "Get-WmiObject -ClassName Win32_NetworkAdapterConfiguration | Select-Object -Property IPAddress,MacAddress | Where IPAddress -NE $null | ConvertTo-Json"'

import sys
from paramiko.client import SSHClient, AutoAddPolicy, RejectPolicy
import json


def get_macadrr_by_ip(ip,network_info):
    if ip in network_info['IPAddress']:
        return network_info['MacAddress']
    else:
        return ''

def format_info_about_motherboard(host_motherboard):
    mbinfo = host_motherboard['Manufacturer'] + ' ' + host_motherboard['Product'] + (' S/N:' + host_motherboard['SerialNumber'] \
        if host_motherboard['SerialNumber'] != 'Default string' else '')
    return mbinfo

def format_info_about_cpu(cpu_info):
    cpuinfo_string = cpu_info['Name'] + (' S/N:' + cpu_info['SerialNumber'] if cpu_info['SerialNumber'] != 'To Be Filled By O.E.M.' else '')
    return cpuinfo_string

def format_info_about_ram(ram_info, ram_type):
    memoryerrorcorrectiontype = 'None-other'
    if (int(ram_type['MemoryErrorCorrection']) == 5 or int(ram_type['MemoryErrorCorrection']) == 6):
        memoryerrorcorrectiontype = 'ECC'
    elif (int(ram_type['MemoryErrorCorrection']) > 6):
        memoryerrorcorrectiontype = 'CRC'
    else:
        pass
    rams = []
    for ram in ram_info:
        ramstring = ''
        ramstring += ram['Manufacturer'] + ' '
        ramstring += str(round(int(ram['Capacity'])/1024/1024)) + 'Mb '
        ramstring += 'S/N: ' + ram['SerialNumber'] + ', '
        ramstring += 'ram type: ' + memoryerrorcorrectiontype
        rams.append(ramstring)
    return ' | '.join([str(elem) for elem in rams])


def ssh_wmi_getter(ipaddr,user,pwd,max_bytes=60000):
    host_macaddr = ''
    host_name = ''
    host_motherboard = ''
    host_cpu = ''
    host_ram = ''
    host_ram_type = ''
    network_info_command = 'powershell -command "Get-WmiObject -ClassName Win32_NetworkAdapterConfiguration | Select-Object -Property IPAddress,MacAddress | Where IPAddress -NE $null | ConvertTo-Json"'
    hostname_info_command = 'powershell -command "Get-WmiObject -ClassName Win32_Processor | Select-Object -Property SystemName | ConvertTo-Json"'
    motherboard_info_command = 'powershell -command "Get-WmiObject -ClassName Win32_Baseboard | Select-Object -Property Manufacturer,Product,SerialNumber | ConvertTo-Json"'
    cpu_info_command = 'powershell -command "Get-WmiObject -ClassName Win32_Processor | Select-Object -Property Name,SerialNumber | ConvertTo-Json"'
    ram_info_command = 'powershell -command "Get-WmiObject -ClassName Win32_PhysicalMemory | Select-Object -Property Manufacturer,Capacity,SerialNumber | ConvertTo-Json"'
    ram_type_info_command = 'powershell -command "Get-WmiObject -ClassName Win32_PhysicalMemoryArray | Select-Object -Property MemoryErrorCorrection | ConvertTo-Json"'
    client = SSHClient()
    client.set_missing_host_key_policy(AutoAddPolicy())
    client.connect(ipaddr,username=user,password=pwd,look_for_keys=False)
    # get mac by ip
    stdin, stdout, stderr = client.exec_command(network_info_command)
    data = stdout.read() + stderr.read()
    network_info = json.loads(data.decode('UTF-8'))
    host_macaddr = get_macadrr_by_ip(ipaddr,network_info)
    # get hostname
    stdin, stdout, stderr = client.exec_command(hostname_info_command)
    data = stdout.read() + stderr.read()
    host_name = json.loads(data.decode('UTF-8'))['SystemName']
    # get motherboard info
    stdin, stdout, stderr = client.exec_command(motherboard_info_command)
    data = stdout.read() + stderr.read()
    host_motherboard = format_info_about_motherboard(json.loads(data.decode('UTF-8')))
    # get cpu info
    stdin, stdout, stderr = client.exec_command(cpu_info_command)
    data = stdout.read() + stderr.read()
    host_cpu = format_info_about_cpu(json.loads(data.decode('UTF-8')))
    # get ram info
    stdin, stdout, stderr = client.exec_command(ram_info_command)
    data_ram_info = stdout.read() + stderr.read()
    # get ram type info
    stdin, stdout, stderr = client.exec_command(ram_type_info_command)
    data_ram_type = stdout.read() + stderr.read()
    host_ram = format_info_about_ram(json.loads(data_ram_info.decode('UTF-8')), json.loads(data_ram_type.decode('UTF-8')))
    # debug output
    print (host_macaddr)
    print (host_name)
    print (host_motherboard)
    print (host_cpu)
    print (host_ram)
    client.close()


ssh_wmi_getter('192.168.162.4','administrator','Netolog9090')