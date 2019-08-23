echo "Checkout git repo"
git --work-tree=/home/tovprinting/new.whiteglovecare.com --git-dir=/home/tovprinting/.git/whiteglovcaree.com checkout -f
wp db import "new.whiteglovecare.com.sql"
echo "changing home  n siteurl"
domain="new.whiteglovecare.com"
old_domain="whiteglovecare.net"
wp option update home http://$domain
wp option update siteurl http://$domain
echo "changing URLS in Database"
wp search-replace $old_domain $domain --all-tables-with-prefix
wp search-replace @WHITEGLOVECARE.NET @WHITEGLOVECARE.COM --all-tables-with-prefix
