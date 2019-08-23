today=`date +%Y-%m-%d.%H:%M:%S`
wp db export new.whiteglovecare.com.sql
git add .
git commit -m  "'$today'"
