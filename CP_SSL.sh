#!/bin/bash
SENDGRID_API_KEY=""
EMAIL_TO=""
EMAIL_CC=""
EMAIL_BCC=""
FROM_EMAIL=""
FROM_NAME="ServerAdmin"
SUBJECT="info: SSL Alert"

webrootis="/usr/local/lsws/Example/html"

if [ "$#" -lt 1 ] || [ "$#" -gt 2 ]; then
    echo "invalid argument supplied"
    exit 1
elif [ "$#" -eq 1 ]; then
    name="$1"
elif [ "$#" -eq 2 ]; then
    name="$1"
    name2="-d $2"
fi
echo "=========================================="
echo $name
echo $name2
echo $webrootis
echo "=========================================="
#exit 1
shift
#//commented shift as not required in it
SUBJECT="info: SSL Alert"
function SSL_check()
{
now_epoch=$( date +%s )
dig +noall +answer $name | while read _ _ _ _ ip;
do
    echo $ip
    expiry_date=$( echo | openssl s_client -showcerts -servername $name -connect $ip:443 2>/dev/null | openssl x509 -inform pem -noout -enddate | cut -d "=" -f 2 )
    expiry_epoch=$( date -d "$expiry_date" +%s )
    expiry_days="$(( ($expiry_epoch - $now_epoch) / (3600 * 24) ))"
    #echo $expiry_date
    #echo $expiry_epoch
    #echo $expiry_days
    if [ $expiry_days -lt 15 ] || [ $expiry_days -gt 90 ]
        then 
             /root/.acme.sh/acme.sh --issue -d $name $name2 --cert-file /etc/letsencrypt/live/$name/cert.pem --key-file /etc/letsencrypt/live/$name/privkey.pem  --fullchain-file /etc/letsencrypt/live/$name/fullchain.pem -w  $webrootis --force --server letsencrypt  >> /home/cyberpanel/error-logs.txt && /usr/local/lsws/bin/lswsctrl reload
             expiryAR_date=$( echo | openssl s_client -showcerts -servername $name -connect $ip:443 2>/dev/null | openssl x509 -inform pem -noout -enddate | cut -d "=" -f 2 )
             expiryAR_epoch=$( date -d "$expiry_date" +%s )
             expiryAR_days="$(( ($expiry_epoch - $now_epoch) / (3600 * 24) ))"
                 if [ $expiryAR_days -lt 15 ] || [ $expiryAR_days -gt 90 ]
                 then 
                        MESSAGE=$( echo "<p style='font-size: 12px;'> Hi,</p><p style='color:red; font-size: 12px;'> The SSL certificate for domain "$name ""$name2" auto-renew failed. </p><p style='font-size: 12px;'>Thanks<br>$(hostname)<br>Note: don't reply this email, this is sender only mail account</p>" )
                        curl --request POST \
                                  --url https://api.sendgrid.com/v3/mail/send \
                                  --header 'Authorization: Bearer '$SENDGRID_API_KEY \
                                  --header 'Content-Type: application/json' \
                                  --data '{"personalizations": [{"to": [{"email": "'"$EMAIL_TO"'"}],"cc": [{"email":"'"$EMAIL_CC"'"}],"bcc": [{"email":"'"$EMAIL_BCC"'"}]}],  "from": {"email":"'"$FROM_EMAIL"'"},"subject":"'"$SUBJECT"'", "content": [{"type": "text/html", "value": "'"$MESSAGE"'"}]}'
                else
                     MESSAGE=$( echo "<p style='font-size: 12px;'> Hi,</p><p style='color:green; font-size: 12px;'> The SSL certificate for domain "$name ""$name2" auto-renewed. </p><p style='font-size: 12px;'>Thanks<br>$(hostname)<br>Note: don't reply this email, this is sender only mail account</p>" )
                     curl --request POST \
                                  --url https://api.sendgrid.com/v3/mail/send \
                                  --header 'Authorization: Bearer '$SENDGRID_API_KEY \
                                  --header 'Content-Type: application/json' \
                                  --data '{"personalizations": [{"to": [{"email": "'"$EMAIL_TO"'"}],"cc": [{"email":"'"$EMAIL_CC"'"}],"bcc": [{"email":"'"$EMAIL_BCC"'"}]}],  "from": {"email":"'"$FROM_EMAIL"'"},"subject":"'"$SUBJECT"'", "content": [{"type": "text/html", "value": "'"$MESSAGE"'"}]}'
               fi

    else
        echo "$(date '+%d/%m/%Y %H:%M:%S') SSL exists for $name and is not ready to renew[$expiry_days days remaining], skipping.." >> /home/cyberpanel/error-logs.txt
  fi
done
}

SSL_check
#30 4 * * * /root/SSLRENEW.sh example.com  > /dev/null 2>&1
#30 4 * * * /root/SSLRENEW.sh example.com www.example.com > /dev/null 2>&1


