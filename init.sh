#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

setup_path=/www
port='8888'
if [ -f $setup_path/server/panel/data/port.pl ];then
	port=`cat $setup_path/server/panel/data/port.pl`
fi

mkdir -p $setup_path/server/panel/logs
mkdir -p $setup_path/server/panel/vhost/apache
mkdir -p $setup_path/server/panel/vhost/nginx
mkdir -p $setup_path/server/panel/vhost/rewrite
wget -O $setup_path/server/panel/certbot-auto https://dl.spanda.io/download/certbot-auto.init -T 5
chmod +x $setup_path/server/panel/certbot-auto


if [ -f '/etc/init.d/bt' ];then
	/etc/init.d/bt stop
fi

mkdir -p /www/server
mkdir -p /www/wwwroot
mkdir -p /www/wwwlogs
mkdir -p /www/backup/database
mkdir -p /www/backup/site

wget -O panel.zip https://dl.spanda.io/download/panel6.zip -T 10
wget -O /etc/init.d/bt https://dl.spanda.io/download/bt6.init -T 10
if [ -f "$setup_path/server/panel/data/default.db" ];then
	if [ -d "/$setup_path/server/panel/old_data" ];then
		rm -rf $setup_path/server/panel/old_data
	fi
	mkdir -p $setup_path/server/panel/old_data
	mv -f $setup_path/server/panel/data/default.db $setup_path/server/panel/old_data/default.db
	mv -f $setup_path/server/panel/data/system.db $setup_path/server/panel/old_data/system.db
	mv -f $setup_path/server/panel/data/aliossAs.conf $setup_path/server/panel/old_data/aliossAs.conf
	mv -f $setup_path/server/panel/data/qiniuAs.conf $setup_path/server/panel/old_data/qiniuAs.conf
	mv -f $setup_path/server/panel/data/iplist.txt $setup_path/server/panel/old_data/iplist.txt
	mv -f $setup_path/server/panel/data/port.pl $setup_path/server/panel/old_data/port.pl
	mv -f $setup_path/server/panel/data/admin_path.pl $setup_path/server/panel/old_data/admin_path.pl
fi

unzip -o panel.zip -d $setup_path/server/ > /dev/null

if [ -d "$setup_path/server/panel/old_data" ];then
	mv -f $setup_path/server/panel/old_data/default.db $setup_path/server/panel/data/default.db
	mv -f $setup_path/server/panel/old_data/system.db $setup_path/server/panel/data/system.db
	mv -f $setup_path/server/panel/old_data/aliossAs.conf $setup_path/server/panel/data/aliossAs.conf
	mv -f $setup_path/server/panel/old_data/qiniuAs.conf $setup_path/server/panel/data/qiniuAs.conf
	mv -f $setup_path/server/panel/old_data/iplist.txt $setup_path/server/panel/data/iplist.txt
	mv -f $setup_path/server/panel/old_data/port.pl $setup_path/server/panel/data/port.pl
	mv -f $setup_path/server/panel/old_data/admin_path.pl $setup_path/server/panel/data/admin_path.pl
	
	if [ -d "/$setup_path/server/panel/old_data" ];then
		rm -rf $setup_path/server/panel/old_data
	fi
fi

rm -f panel.zip

if [ ! -f $setup_path/server/panel/tools.py ];then
	echo -e "\033[31mERROR: Failed to download, please try again!\033[0m";
	echo '============================================'
	exit;
fi

rm -f $setup_path/server/panel/class/*.pyc
rm -f $setup_path/server/panel/*.pyc
python -m compileall $setup_path/server/panel
#rm -f $setup_path/server/panel/class/*.py
#rm -f $setup_path/server/panel/*.py

chmod 777 /tmp
chmod +x /etc/init.d/bt
ln -sf /etc/init.d/bt /usr/bin/bt
update-rc.d bt defaults
chmod -R 600 $setup_path/server/panel
chmod +x $setup_path/server/panel/certbot-auto
chmod -R +x $setup_path/server/panel/script
echo "$port" > $setup_path/server/panel/data/port.pl
/etc/init.d/bt start
password=`cat /dev/urandom | head -n 16 | md5sum | head -c 8`
sleep 1
admin_auth='/www/server/panel/data/admin_path.pl'
if [ ! -f $admin_auth ];then
	auth_path=`cat /dev/urandom | head -n 16 | md5sum | head -c 8`
	echo "/$auth_path" > $admin_auth
fi
auth_path=`cat $admin_auth`
cd $setup_path/server/panel/
python -m py_compile tools.py
python tools.py username
username=`python tools.pyc panel $password`
cd ~
echo "$password" > $setup_path/server/panel/default.pl
chmod 600 $setup_path/server/panel/default.pl
/etc/init.d/bt restart
sleep 1
isStart=`ps aux |grep 'gunicorn'|grep -v grep|awk '{print $2}'`
if [ "$isStart" == '' ];then
	echo -e "\033[31mERROR: The BT-Panel service startup failed.\033[0m";
	echo '============================================'
	exit;
fi

#if [ ! -f /root/.ssh/authorized_keys ] || [ ! -f /root/.ssh/id_rsa ];then
#	if [ -f /root/.ssh/id_rsa ];then
#		rm -f /root/.ssh/id_rsa /root/.ssh/id_rsa.pub
#	fi
#	ssh-keygen -q -t rsa -P "" -f /root/.ssh/id_rsa
#fi
#cat /root/.ssh/id_rsa.pub >> /root/.ssh/authorized_keys
#chmod 600 /root/.ssh/authorized_keys

pip install psutil chardet psutil virtualenv $pipArg
if [ ! -d '/etc/letsencrypt' ];then
	mkdir -p /etc/letsencrypt
	mkdir -p /var/spool/cron
	if [ ! -f '/var/spool/cron/crontabs/root' ];then
		echo '' > /var/spool/cron/crontabs/root
		chmod 600 /var/spool/cron/crontabs/root
	fi
fi

wget -O acme_install.sh https://dl.spanda.io/download/acme_install.sh
nohup bash acme_install.sh &> /dev/null &
sleep 1
rm -f acme_install.sh

	address=`curl -sS --connect-timeout 10 -m 60 https://www.bt.cn/Api/getIpAddress`
	
	if [ "$address" == '0.0.0.0' ] || [ "$address" == '' ];then
		isHosts=`cat /etc/hosts|grep 'www.bt.cn'`
		if [ "$isHosts" == '' ];then
			echo "" >> /etc/hosts
			echo "125.88.182.170 www.bt.cn" >> /etc/hosts
			address=`curl -sS --connect-timeout 10 -m 60 https://www.bt.cn/Api/getIpAddress`
			if [ "$address" == '' ];then
				sed -i "/bt.cn/d" /etc/hosts
			fi
		fi
	fi
	
	ipCheck=`python -c "import re; print(re.match('^(?:[0-9]{1,3}\.){3}[0-9]{1,3}$','$address'))"`
	if [ "$address" == "None" ];then
		address="SERVER_IP"
	fi
	if [ "$address" != "SERVER_IP" ];then
		echo "$address" > $setup_path/server/panel/data/iplist.txt
	fi

curl -sS --connect-timeout 10 -m 60 https://www.bt.cn/Api/SetupCount?type=Linux\&o=$1 > /dev/null 2>&1
if [ "$1" != "" ];then
	echo $1 > /www/server/panel/data/o.pl
	cd /www/server/panel
	python tools.py o
fi

echo -e "Bt-Panel: http://$address:$port$auth_path"
echo -e "username: $username"
echo -e "password: $password"

rm -f install.sh
