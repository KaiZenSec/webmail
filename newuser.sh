#!/bin/bash
# 1 = domain
# 2 = username
# 3 = password
if [ "$1" != "" ] && [ "$2" != "" ]&& [ "$3" != "" ]; then

mysql -D maildb -e "INSERT INTO users (id,maildir,crypt) VALUES ('$2@$1','$2/',encrypt('$3', CONCAT('\$5\$', MD5(RAND()))) );"
mysql -D maildb -e "INSERT INTO aliases (mail,destination) VALUES('$2@$1','$2@$1');"

else
    echo "Enter campaign domain and username ex. campaign.sh domain username password"
fi
