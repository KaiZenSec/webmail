#!/bin/bash
if [ "$1" != "" ] && [ "$2" != "" ]; then

apt update && apt upgrade
apt install -y mariadb-server mariadb-client postfix postfix-mysql courier-base courier-authdaemon courier-authlib-mysql courier-imap courier-imap-ssl courier-ssl certbot libnl-3-200 libnl-genl-3-200
mysql -u root -e "SET PASSWORD FOR root@'localhost' = PASSWORD('$1');"
mysql -e "create database maildb;"
mysql -e "GRANT SELECT,INSERT,UPDATE,DELETE,CREATE,DROP ON maildb.* TO 'mail'@'localhost' IDENTIFIED by '$2';"
mysql -e "GRANT SELECT,INSERT,UPDATE,DELETE,CREATE,DROP ON maildb.* TO 'mail'@'%' IDENTIFIED by '$2';" 
mysql -D maildb -e "CREATE TABLE aliases (pkid smallint(3) NOT NULL auto_increment,mail varchar(120) NOT NULL default '',destination varchar(120) NOT NULL default '',enabled tinyint(1) NOT NULL default '1',PRIMARY KEY  (pkid),UNIQUE KEY mail (mail)) ;"
mysql -D maildb -e "CREATE TABLE domains (pkid smallint(6) NOT NULL auto_increment,domain varchar(120) NOT NULL default '',transport varchar(120) NOT NULL default 'virtual:',enabled tinyint(1) NOT NULL default '1',PRIMARY KEY  (pkid)) ;"
mysql -D maildb -e "CREATE TABLE users (id varchar(128) NOT NULL default '',name varchar(128) NOT NULL default '',uid smallint(5) unsigned NOT NULL default '5000',gid smallint(5) unsigned NOT NULL default '5000',home varchar(255) NOT NULL default '/var/spool/mail/virtual',maildir varchar(255) NOT NULL default 'blah/',enabled tinyint(1) NOT NULL default '1',change_password tinyint(1) NOT NULL default '1',clear varchar(128) NOT NULL default 'ChangeMe',crypt varchar(128) NOT NULL default 'sdtrusfX0Jj66',quota varchar(255) NOT NULL default '',PRIMARY KEY  (id),UNIQUE KEY id (id)) ;"
echo 'webmail.csettp.com' >> /etc/mailname
wget https://raw.githubusercontent.com/KaiZenSec/webmail/master/main.cf -O /etc/postfix/main.cf
cp /etc/aliases /etc/postfix/aliases
postalias /etc/postfix/aliases
mkdir /var/spool/mail/virtual
groupadd --system virtual -g 5000
useradd --system virtual -u 5000 -g 5000
chown -R virtual:virtual /var/spool/mail/virtual
cat << EOF > /etc/postfix/mysql_mailbox.cf
user=mail
password=$2
dbname=maildb
table=users
select_field=maildir
where_field=id
hosts=127.0.0.1
additional_conditions = and enabled = 1
#query = select users from mailbox where username = '%s' and active = 1
#result_format = %sMaildir/
EOF

cat << EOF > /etc/postfix/mysql_alias.cf
user=mail
password=$2
dbname=maildb
table=aliases
select_field=destination
where_field=mail
hosts=127.0.0.1
additional_conditions = and enabled = 1
EOF

cat << EOF > /etc/postfix/mysql_domains.cf
user=mail
password=$2
dbname=maildb
table=domains
select_field=domain
where_field=domain
hosts=127.0.0.1
additional_conditions = and enabled = 1
EOF

sed -i 's/authmodulelist=[^ ]*/authmodulelist=\"authmysql\"/' /etc/courier/authdaemonrc
sed -i 's/DEBUG_LOGIN=[^ ]*/DEBUG_LOGIN=1/' /etc/courier/authdaemonrc
sed -i 's/MYSQL_USERNAME          [^ ]*/MYSQL_USERNAME          mail/' /etc/courier/authmysqlrc
sed -i 's/MYSQL_PASSWORD[^ ]*/MYSQL_PASSWORD $2/' /etc/courier/authmysqlrc
sed -i 's/MYSQL_DATABASE[^ ]*/MYSQL_DATABASE maildb/' /etc/courier/authmysqlrc
sed -i 's/MYSQL_USER_TABLE[^ ]*/MYSQL_USER_TABLE users/' /etc/courier/authmysqlrc
echo "MYSQL_MAILDIR_FIELD concat(home,'/',maildir)" >> /etc/courier/authmysqlrc
echo "MYSQL_WHERE_CLAUSE enabled=1" >> /etc/courier/authmysqlrc
echo "Don't forget the Falcon Sensor!!!!"
else
    echo "Enter MySQL Root and Mail Passwords ex. bootstrap.sh rootpw mailpw"
fi
