#!/bin/bash

PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

if [ -f "/etc/init.d/bt" ];then
    /etc/init.d/bt start
fi

exec "$@"
