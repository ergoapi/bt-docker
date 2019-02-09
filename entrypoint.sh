#!/bin/bash

PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
address=$(curl -s ip.sb)
port=${port:-8888}
auth_path=$(cat /www/server/panel/data/admin_path.pl)
login_info=$(cat /www/server/panel/default_auth.pl)
echo "$address" > /www/server/panel/data/iplist.txt

echo -e "Bt-Panel: http://$address:$port$auth_path"
echo -e "Bt-Panel: http://127.0.0.1:$port$auth_path"
echo -e "Login: $login_info"


if [ -f "/etc/init.d/bt" ];then
    /etc/init.d/bt start
fi

exec "$@"
