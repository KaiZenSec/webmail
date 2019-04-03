#!/bin/bash
# 1 = domain
# 2 = username
# 3 = password
if [ "$1" != "" ] && [ "$2" != "" ]; then

mysql -D maildb -e "INSERT INTO domains (domain) VALUES ('$1');"
mysql -D maildb -e "INSERT INTO aliases (mail,destination) VALUES ('@$1','$2@$1');"
mysql -D maildb -e "INSERT INTO users (id,name,maildir,crypt) VALUES ('$2@$1','$2','$2/',encrypt('$3', CONCAT('$5$', MD5(RAND()))) );"
mysql -D maildb -e "INSERT INTO relays (recipient,status) values ('@$1','OK');"

else
    echo "Enter campaign domain and username ex. campaign.sh domain username"
fi
