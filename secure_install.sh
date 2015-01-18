#!/bin/bash



echo "$(tput setaf 1)Update os$(tput sgr0)"
apt-get update
apt-get -y upgrade


ufw allow $SSH_PORT
ufw enable
ufw default deny

echo "$(tput setaf 1)Install Rkhunter$(tput sgr0)"

apt-get install -y rkhunter
echo "0 0 * * * root /usr/bin/rkhunter --update | mail -s 'Rkhunter daily Update' $ADMIN_EMAIL" >>/etc/crontab
echo "5 0 * * * root /usr/bin/rkhunter --checkall --skip-keypress | mail -s 'Rkhunter daily Scan' $ADMIN_EMAIL" >>/etc/crontab

echo "$(tput setaf 1)Install Chkrootkit$(tput sgr0)"

apt-get install -y chkrootkit

echo "10 0 * * * root /usr/bin/chkrootkit | mail -s 'Chkrootkit daily Update' $ADMIN_EMAIL" >>/etc/crontab

echo "$(tput setaf 1)Install Fail2Ban$(tput sgr0)"

apt-get install -y fail2ban

sed -i 's/mta = sendmail/mta = mail/g' /etc/fail2ban/jail.conf
sed -i "s/destemail = root@localhost/destemail = $ADMIN_EMAIL/g" /etc/fail2ban/jail.conf

fail2ban-client reload
/etc/init.d/fail2ban restart

#Portsentry (scan de ports)
apt-get install portsentry
#Install logwatch 
apt-get install logwatch 

echo "$(tput setaf 1)Install ClamAV$(tput sgr0)"
apt-get install -y clamav

echo "0 0 * * * root /usr/bin/freshclam | mail -s 'ClamAV update' $ADMIN_EMAIL" >>/etc/crontab
echo "0 1 * * * root /usr/bin/clamscan -ir / | mail -s 'ClamAV daily scan' $ADMIN_EMAIL" >>/etc/crontab

echo "$(tput setaf 1)Install LMD$(tput sgr0)"

wget www.rfxn.com/downloads/maldetect-current.tar.gz
tar xvfvz maldetect-current.tar.gz
rm -v 
cd maldetect-*
./install.sh
cd ..
rm -rfv maldetect-*

maldet -u


echo "$(tput bold ; tput setaf 6)############################################################"
echo "###	$(tput bold ; tput setaf 2) Thanks for using Cyklodev stuff ;)  $(tput bold ; tput setaf 6)		####"
echo "$(tput bold ; tput setaf 6)############################################################$(tput sgr0)"
