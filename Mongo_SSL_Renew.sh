if openssl x509 -checkend 604800 -noout -in /etc/ssl/mongodb.pem
then
  echo "Certificate is good for another day!"
else
  echo "Certificate has expired"
  cat /var/cpanel/ssl/cpanel/mycpanel.pem /var/cpanel/ssl/cpanel/mycpanel.pem > /etc/ssl/mongodb.pem && systemctl status mongod.service | grep "running"
  if [ $? == 0 ]; then
     echo "SSL renewed and restart mongod success"
  fi


fi
