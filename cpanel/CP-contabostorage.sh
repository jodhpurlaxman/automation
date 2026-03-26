sed -i 's/s3.amazonaws.com/usc1.contabostorage.com/g' /usr/local/CyberCP/IncBackups/IncBackupsControl.py
sed -i 's/s3.amazonaws.com/usc1.contabostorage.com/g' /usr/local/CyberCP/IncBackups/views.py
service lscpd restart
