# Webamail
# Install CBI mail server
curl https://raw.githubusercontent.com/KaiZenSec/webmail/master/bootsrap.sh |bash -s rootpw mailpw
# Create campaign user and domain
curl https://raw.githubusercontent.com/KaiZenSec/webmail/master/campaign.sh |bash -s domain username password
# Create new ssh user
curl https://raw.githubusercontent.com/KaiZenSec/webmail/master/new-ssh-user.sh |bash -s username 'publickey'
<br>Note: It's important to put single quotes ('') around public key. 
# Create email user and domain
curl https://raw.githubusercontent.com/KaiZenSec/webmail/master/newuser.sh |bash -s domain username password
