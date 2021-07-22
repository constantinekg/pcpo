#!/usr/bin/env python3

import telegram
from telegram.error import RetryAfter, TimedOut
import hwdb
import time


def alertforuser(textofmessage):
    bot = telegram.Bot(token=hwdb.getOptionByName('telegrambotapikey'))
    tries = 0
    max_tries = int(hwdb.getOptionByName('telegram_message_send_max_tries'))
    retry_delay = int(hwdb.getOptionByName('telegram_message_send_retry_delay'))
    while tries < max_tries:
        try:
            res = bot.send_message(chat_id=hwdb.getOptionByName('telegramchatid'), text=textofmessage)
            # print (res)
        except (RetryAfter, TimedOut) as e:
            print("Message {} got exception {}".format(textofmessage, e))
            time.sleep(retry_delay)
            tries += 1
        else:
            break


