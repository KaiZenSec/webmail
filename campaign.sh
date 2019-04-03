#!/bin/bash
# 1 = domain
# 2 = username
# 3 = password
if [ "$1" != "" ] && [ "$2" != "" ]&& [ "$3" != "" ]; then

echo INSERT INTO domains (domain) VALUES (''$1'');
echo INSERT INTO users (id,name,maildir,crypt) VALUES ('$2@$1','short description','$2/',encrypt('$3', CONCAT('$5$', MD5(RAND()))) );
echo INSERT INTO aliases (mail,destination) VALUES('$2@$1','$2@$1');

else
    echo "Enter campaign domain and username ex. campaign.sh domain username password"
fi
