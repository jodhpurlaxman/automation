clear;w;hostname;hostname -i;echo " ";echo " ";echo "###Disk usage###";echo " ";df -h;echo " ";echo " ";echo "###Memory usage###";echo " ";free -h;echo " ";echo " ";echo "###Connections today###";echo " ";grep `date +%d'/'%b'/'%Y` /usr/local/apache/domlogs/*/* | awk '{print $1}' | sort | uniq -c | sort -rn | head;echo " ";echo " "; echo "###XMLRPC###";echo " ";grep `date +%d'/'%b'/'%Y` /usr/local/apache/domlogs/*/* | grep xmlrpc | awk '{print $1}' | sort | uniq -c | sort -rn | head;echo " ";echo " ";echo "###WP-login###";echo " ";grep `date +%d'a/aa'%b'/'%Y` /usr/local/apache/domlogs/*/* | grep wp-login | awk '{print $1}' | sort | uniq -c | sort -rn | head;echo " ";echo " ";echo "###Number of SYN_RECV requests###";echo " ";netstat -nap | grep SYN_RECV | awk '{print$5}' | cut -d: -f1 | sort | uniq -c | sort -nr | head -20; netstat -nap | grep SYN_RECV -c;echo " ";echo " ";echo "###Current connections### ";echo " ";netstat -nt 2>/dev/null | egrep ':80|:443'| awk '{print $5}' | awk -F: 'BEGIN { OFS = ":"} {$(NF--)=""; print}' | awk '{print substr($0, 1, length($0)-1)}' | sort | uniq -c | sort -rn | head



echo OOM-KILLED; grep oom-killer /var/log/messages | tail -5; grep -i killed /var/log/messages | less | tail -5; echo APACHE LIMITS; egrep -ia 'worker|scoreboard' /usr/local/apache/logs/error_log | tail -5; echo PHP-FPM; grep -ri max_children /opt/cpanel/ea-php*/root/usr/var/log/php-fpm/ | grep `date +%d-%b` |awk '{print $5 $10}'| sort | uniq -c | sort -rn

grep 'reached max_children setting' /opt/cpanel/ea-php*/root/usr/var/log/php-fpm/error.log

grep -ri max_children /opt/cpanel/ea-php*/root/usr/var/log/php-fpm/ | grep `date +%d-%b` |awk '{print $5 $10}'| sort | uniq -c | sort -rn

grep -d skip $(date +%d/%b/%Y): /var/log/apache2/domlogs/*/*|cut -d: -f2-|awk '{print $1}'|sort|uniq -c|sort -rh|head -n20

apachectl fullstatus
