#!/bin/bash
pkill -f multithread.py
rm /opt/pcpo/scanner/__pycache__/ -rf
/opt/pcpo/scanner/multithread.py
