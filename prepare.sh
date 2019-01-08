#!/bin/bash

apt-get update
apt-get install --no-install-recommends --no-install-suggests -y ufw ruby lsb-release wget curl python python-dev python-imaging python-pip python-apt zip unzip openssl libssl-dev gcc libxml2 libxml2-dev libxslt zlib1g zlib1g-dev libjpeg-dev libpng-dev libffi-dev lsof libpcre3 libpcre3-dev cron
rm -rf /var/lib/apt/lists/* 

