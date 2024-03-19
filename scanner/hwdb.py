# https://dev.mysql.com/doc/connector-python/en/connector-python-example-cursor-select.html

import config
import mysql.connector
from mysql.connector import errorcode
import time
import datetime
import sys
sys.dont_write_bytecode = True

def testMysqlConnectionToDatabase():
    try:
        cnx = mysql.connector.connect(user=config.mysqluser, password=config.mysqlpassword, 
        host=config.mysqlhost, database=config.mysqldbname)
        res = True
        print ('ok')
    except mysql.connector.Error as err:
        if err.errno == errorcode.ER_ACCESS_DENIED_ERROR:
            print("Something is wrong with your user name or password")
            res = False
        elif err.errno == errorcode.ER_BAD_DB_ERROR:
            print("Database does not exist")
            res = False
        else:
            print(err)
            res = False
    else:
        cnx.close()
    return res


# Запрос последней конфигурации согласно указанному mac-адресу и обновление даты последней проверки
def queryLastConfigurationByMacAddrress(macaddr):
    try:
        cnx = mysql.connector.connect(user=config.mysqluser, password=config.mysqlpassword, host=config.mysqlhost, database=config.mysqldbname)
        cursor = cnx.cursor()
        query = ("SELECT ipaddress, hostname, macaddress, motherboard, cpu, ram, video, hdd FROM hardware WHERE macaddress = %s ORDER BY id DESC LIMIT 1")
        addr = (macaddr, )
        cursor.execute(query, addr)
        hwresult = cursor.fetchall()
        queryupdate = ("UPDATE hardware set updated_at=%s WHERE macaddress = %s ORDER BY id DESC LIMIT 1")
        ts = time.time()
        timestamp = datetime.datetime.fromtimestamp(ts).strftime('%Y-%m-%d %H:%M:%S')
        updateparams = (timestamp, macaddr, )
        cursor.execute(queryupdate, updateparams)
        cnx.commit()
        cursor.close()
        cnx.close()
        if len(hwresult) != 0:
            res = hwresult[0]
        else:
            res = False
    except mysql.connector.Error as err:
        if err.errno == errorcode.ER_ACCESS_DENIED_ERROR:
            print("Something is wrong with your user name or password")
            res = False
        elif err.errno == errorcode.ER_BAD_DB_ERROR:
            print("Database does not exist")
            res = False
        else:
            print(err)
            res = False
    else:
        cnx.close()
    return res


# Добавление новой конфигурации в БД
def addNewConfigurationToDB(hw):
    try:
        cnx = mysql.connector.connect(user=config.mysqluser, password=config.mysqlpassword, host=config.mysqlhost, database=config.mysqldbname)
        cursor = cnx.cursor()
        ts = time.time()
        timestamp = datetime.datetime.fromtimestamp(ts).strftime('%Y-%m-%d %H:%M:%S')
        add_hardware = ("INSERT INTO hardware "
        "(ipaddress, hostname, macaddress, motherboard, cpu, ram, video, hdd, created_at, updated_at) "
        "VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s)")
        data_hardware = (hw[0], hw[1], hw[2], hw[3], hw[4], hw[5], hw[6], hw[7], timestamp, timestamp)
        cursor.execute(add_hardware, data_hardware)
        # numindb = cursor.lastrowid
        # rescommit = cnx.commit()
        cnx.commit()
        # print ('№ in db:')
        # print (numindb)
        # print ('rescommit:')
        # print (rescommit)
        cursor.close()
        cnx.close()
        res = True
    except mysql.connector.Error as err:
        if err.errno == errorcode.ER_ACCESS_DENIED_ERROR:
            print("Something is wrong with your user name or password")
            res = False
        elif err.errno == errorcode.ER_BAD_DB_ERROR:
            print("Database does not exist")
            res = False
        else:
            print(err)
            res = False
    else:
        cnx.close()
    return res


# Функция для занесения статистики о сканировании в БД
def addToScanStat(hostsscanned, failedhosts, newhosts, ipaddresschanges, hostnamechanges, motherboardchanges, cpuchanges, ramchanges, videochanges, hddchanges, begin_at, end_at):
    try:
        cnx = mysql.connector.connect(user=config.mysqluser, password=config.mysqlpassword, host=config.mysqlhost, database=config.mysqldbname)
        cursor = cnx.cursor()
        add_scanstat = ("INSERT INTO scanstat "
        "(hostsscanned, failedhosts, newhosts, ipaddresschanges, hostnamechanges, motherboardchanges, cpuchanges, ramchanges, videochanges, hddchanges, begin_at, end_at) "
        "VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)")
        data_scanstat = (hostsscanned, failedhosts, newhosts, ipaddresschanges, hostnamechanges, motherboardchanges, cpuchanges, ramchanges, videochanges, hddchanges, begin_at, end_at, )
        cursor.execute(add_scanstat, data_scanstat)
        numindb = cursor.lastrowid
        cnx.commit()
        cursor.close()
        cnx.close()
        res = True
    except mysql.connector.Error as err:
        if err.errno == errorcode.ER_ACCESS_DENIED_ERROR:
            print("Something is wrong with your user name or password")
            res = False
        elif err.errno == errorcode.ER_BAD_DB_ERROR:
            print("Database does not exist")
            res = False
        else:
            print(err)
            res = False
    else:
        cnx.close()
    return res



# Сравнение конфигураций
def compareConfigurations(conffromscan, conffromdb):
    x = 0
    diff = []
    changes = {'ipaddresschanges':0, 'hostnamechanges':0, 'motherboardchanges':0, 'cpuchanges':0, 'ramchanges':0, 'videochanges':0, 'hddchanges':0}
    for i in conffromdb:
        if conffromscan[x] != i:
            difference = 'was: '+i+' | '+'now: '+conffromscan[x]
            diff.append(difference)
            if x==0:
                changes['ipaddresschanges'] = 1
            elif x==1:
                changes['hostnamechanges'] = 1
            elif x==3:
                changes['motherboardchanges'] = 1
            elif x==4:
                changes['cpuchanges'] = 1
            elif x==5:
                changes['ramchanges'] = 1
            elif x==6:
                changes['videochanges'] = 1
            elif x==7:
                changes['hddchanges'] = 1
            else:
                pass
        else:
            pass
        x+=1
    return diff, changes


def checkIfExistByMac(macaddress):
    try:
        cnx = mysql.connector.connect(user=config.mysqluser, password=config.mysqlpassword, host=config.mysqlhost, database=config.mysqldbname)
        cursor = cnx.cursor()
        query = ("SELECT ipaddress, macaddress FROM hardware WHERE macaddress = %s ORDER BY id DESC LIMIT 1")
        addr = (macaddress, )
        cursor.execute(query, addr)
        hwresult = cursor.fetchall()
        cursor.close()
        cnx.close()
        if len(hwresult) != 0:
            res = hwresult[0]
        else:
            res = False
    except mysql.connector.Error as err:
        if err.errno == errorcode.ER_ACCESS_DENIED_ERROR:
            print("Something is wrong with your user name or password")
            res = False
        elif err.errno == errorcode.ER_BAD_DB_ERROR:
            print("Database does not exist")
            res = False
        else:
            print(err)
            res = False
    else:
        cnx.close()
    return res


# Забрать перечень хостов с кредиталами
def getHostsWithCredentials():
    try:
        cnx = mysql.connector.connect(user=config.mysqluser, password=config.mysqlpassword, host=config.mysqlhost, database=config.mysqldbname)
        cursor = cnx.cursor()
        query = ("SELECT iprange, user, password, infograbbertype FROM networks")
        cursor.execute(query)
        hostsandcredentials = cursor.fetchall()
        cursor.close()
        cnx.close()
        if len(hostsandcredentials) != 0:
            res = hostsandcredentials
        else:
            res = False
    except mysql.connector.Error as err:
        if err.errno == errorcode.ER_ACCESS_DENIED_ERROR:
            print("Something is wrong with your user name or password")
            res = False
        elif err.errno == errorcode.ER_BAD_DB_ERROR:
            print("Database does not exist")
            res = False
        else:
            print(err)
            res = False
    else:
        cnx.close()
    return res



# Функция забора значения опции по её имени
def getOptionByName(name):
    try:
        cnx = mysql.connector.connect(user=config.mysqluser, password=config.mysqlpassword, host=config.mysqlhost, database=config.mysqldbname)
        cursor = cnx.cursor()
        query = ("SELECT `option` FROM options WHERE name='"+name+"'")
        cursor.execute(query)
        option = cursor.fetchone()
        cursor.close()
        cnx.close()
        if len(option) != 0:
            res = option[0]
        else:
            res = False
    except mysql.connector.Error as err:
        if err.errno == errorcode.ER_ACCESS_DENIED_ERROR:
            print("Something is wrong with your user name or password")
            res = False
        elif err.errno == errorcode.ER_BAD_DB_ERROR:
            print("Database does not exist")
            res = False
        else:
            print(err)
            res = False
    else:
        cnx.close()
    return res

