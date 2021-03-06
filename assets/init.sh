#!/bin/bash
#cp -f /etc/rspamd/rspamd.tmpl /etc/rspamd/rspamd.conf
# Substitute configuration
#for VARIABLE in `env | cut -f1 -d=`; do
#  sed -i "s={{ $VARIABLE }}=${!VARIABLE}=g" /etc/rspamd/*.conf
#done

echo "bind_socket = \"*:11334\";" > /etc/rspamd/local.d/worker-controller.inc
echo "password = \"$RSPAMD_PWD\";" >> /etc/rspamd/local.d/worker-controller.inc
echo "enable_password = \"$RSPAMD_PWDADMIN\";" >> /etc/rspamd/local.d/worker-controller.inc

if [ ! -e /maps/whitelist.map ];
then
    echo "127.0.0.1" >> /maps/whitelist.map
    echo "192.168.1.1" >> /maps/whitelist.map
    echo "192.168.2.0/24" >> /maps/whitelist.map
    echo "172.17.0.0/16" >> /maps/whitelist.map
fi

rspamUser=$(grep rspamd /etc/passwd | cut -d: -f3)
rspamGroup=$(grep rspamd /etc/passwd | cut -d: -f4)

chown $rspamUser:$rspamGroup /var/lib/rspamd -R
chown $rspamUser:$rspamGroup /maps -R
chown $rspamUser:$rspamGroup /dkim -R
chmod 0600 /dkim -R
chmod 0700 /dkim

rm -f /var/run/rsyslogd.pid

rspamd -u _rspamd -g _rspamd -f
rsyslogd -n
