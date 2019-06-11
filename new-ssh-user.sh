#!/bin/bash
# 1 = username (flast)
# 2 = public key
#add user
if [ "$1" != "" ] && [ "$2" != "" ]; then
useradd -m -s /bin/bash -U $1
mkdir /home/$1/.ssh
echo $2 > /home/$1/.ssh/authorized_keys
chown -R $1:$1 /home/$1/.ssh
chmod 700 /home/$1/.ssh
chmod 640 /home/$1/.ssh/authorized_keys
echo $1 'ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers.d/90-cloud-init-users
echo "If adding a new user to KP server set the user password"
else
    echo "Enter username and 'public key' ex new-user.sh flast 'publickeyhere'"

fi
