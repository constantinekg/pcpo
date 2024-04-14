import telega
import sendemail
import hwdb

# Функция оповещения о новой появившейся конфигурации
def notifyAboutNewConfiguration(newconf):
    if (hwdb.getOptionByName('telegram_notifications_enabled') == '1'):
        telega.alertforuser(newconf)
    else:
        pass
    # print (newconf)


# Функция оповещения об изменившейся конфигурации
def notifyAboutChangesInConfiguration(host, diff):
    if (hwdb.getOptionByName('telegram_notifications_enabled') == '1'):
        changedconf = host+' '+diff
        telega.alertforuser(changedconf)
    else:
        pass
    # print (changedconf)

# Функция для отправки сообщений об изменениях в конфигурациях через email
def mailAboutConfChanges(changestosendbyemail):
    if (hwdb.getOptionByName('smtp_notifications_enabled') == '1'):
        if len(changestosendbyemail) > 0:
            message = ''
            for i in changestosendbyemail:
                message += i.replace("|", "\n")
                message += '-----------------------------------------------------------'+"\n"
            sendemail.sendemail('Изменения в конфигурациях:', message)
    else:
        pass


# Функция для отправки сводного отчёта о проведённом сканировании через email
def mailReportAboutScan(changes,failed,new):
    if (hwdb.getOptionByName('smtp_notifications_enabled') == '1'):
        message = ''
        if (len(changes) > 0 and hwdb.getOptionByName('emailaboutchanges') == '1'):
            message = "Изменения: \n"
            for i in changes:
                message += i.replace("|", "\n")
                message += '-----------------------------------------------------------'+"\n"
        else:
            pass
        if (len(failed) > 0 and hwdb.getOptionByName('emailaboutfailedhosts') == '1'):
            message += "\n Непроверенные хосты: \n"
            for i in failed:
                message+=i+"\n"
        else:
            pass
        if (len(new) > 0 and hwdb.getOptionByName('emailaboutnewhosts') == '1'):
            message += "\n Новые хосты: \n"
            for i in new:
                message+=i+"\n"
        else:
            pass
        if (message != ''):
            sendemail.sendemail(message)
        else:
            pass
    else:
        pass

# Функция отправки сводного отчёта по выключенным хостам
def mailAboutShutdownHosts(reportmessage):
    if (hwdb.getOptionByName('smtp_notifications_enabled') == '1'):
        if (reportmessage != ''):
            sendemail.sendemail(reportmessage, 'Subject: PC Park Observer shutdown hosts notification.')
        else:
            pass
    else:
        pass

def notifyAboutScanFailByZeroLiveHosts(message):
    if (hwdb.getOptionByName('smtp_notifications_enabled') == '1'):
        sendemail.sendemail('Проверка прошла неудачно',message)
    else:
        pass
    if (hwdb.getOptionByName('telegram_notifications_enabled') == '1'):
        telega.alertforuser(message)
    else:
        pass

# Функция отправки сообщений в telegram о недавно выключенных хостах
def notifyAboutShutdwonHostsIntoTelegram(off_host, messagesubject='<b>OLD SHUTDOWNED HOSTS:</b>'):
    if (hwdb.getOptionByName('shutdown_check_enabled') == '1' and hwdb.getOptionByName('telegram_notifications_enabled') == '1'):
        telega.alertforuser(messagesubject + "\n" + off_host)
    else:
        pass