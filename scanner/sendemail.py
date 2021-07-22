#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import smtplib as smtp
import ssl
from getpass import getpass
import re
import config
import hwdb
import time
from email.mime.text import MIMEText


regex = '^[a-z0-9]+[\._]?[a-z0-9]+[@]\w+[.]\w{2,10}$'

def check(email):
    if(re.search(regex,email)):  
        return True
    else:  
        return False
      

# Функция отправки уведомлений на почту об изменениях
def sendemail(message):

    mailreceivers = hwdb.getOptionByName('notificationemail')
    mr = mailreceivers.split(',')
    email = hwdb.getOptionByName('emailuser')
    password = hwdb.getOptionByName('emailpwd')
    smtphost = hwdb.getOptionByName('smtphost')
    smtpport = int(hwdb.getOptionByName('smtpport'))
    mailencryption = hwdb.getOptionByName('smtpencryption')
    # print (email+' | '+password+' | '+smtphost+' | '+str(smtpport))
    for mailaddress in mr:
        if check(mailaddress) == True:
            mailaddresses = []
            mailaddresses.append(mailaddress)
            try:
                msg = MIMEText('\n {}'.format(message).encode('utf-8'), _charset='utf-8')
                msg.add_header('From',email)
                if (mailencryption == '1'):
                    # print ('ssl')
                    server = smtp.SMTP_SSL(smtphost, smtpport)
                    if (hwdb.getOptionByName('smtp_debug_enabled') == '1'):
                        server.set_debuglevel(1)
                    else:
                        pass
                    server.ehlo(email)
                    server.login(email, password)
                    server.auth_plain()
                    server.sendmail(email, mailaddresses, 'Subject: PC Park Observer notification. \n{}'.format(msg))
                    server.quit()
                elif (mailencryption == '2'):
                    # print ('tls')
                    context = ssl.create_default_context()
                    context.check_hostname = False
                    context.verify_mode = ssl.CERT_NONE
                    server = smtp.SMTP(smtphost, smtpport)
                    if (hwdb.getOptionByName('smtp_debug_enabled') == '1'):
                        server.set_debuglevel(1)
                    else:
                        pass
                    server.connect(smtphost, smtpport)
                    server.ehlo()
                    server.starttls(context = context)
                    server.ehlo()
                    server.login(email, password)
                    server.sendmail(email, mailaddresses, 'Subject: PC Park Observer notification. \n{}'.format(msg))
                    server.quit()
                else:
                    pass
            except smtp.SMTPConnectError as e:
                print ('Something went wrong...'+str(e))
            time.sleep(5)
        else:
            print ('Email address format error!')
            pass

