#!/bin/bash

sudo cp /opt/pcpo/daemon/pcpo.service /etc/systemd/system
sudo systemctl daemon-reload
sudo systemctl enable pcpo.service
sudo systemctl start pcpo.service
sudo systemctl status pcpo.service
