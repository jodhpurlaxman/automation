#!/bin/bash
echo "which domain backup you want to restore"
read username
AWS_ACCESS_KEY_ID=$(ls /home/cyberpanel/aws/); AWS_SECRET_ACCESS_KEY=$(cat /home/cyberpanel/aws/$AWS_ACCESS_KEY_ID); restic -r s3:usc1.contabostorage.com/$username snapshots --password-file "/home/$username/$username"
echo "which snapshot you want to restore"
read snapshotid
AWS_ACCESS_KEY_ID=$(ls /home/cyberpanel/aws/); AWS_SECRET_ACCESS_KEY=$(cat /home/cyberpanel/aws/$AWS_ACCESS_KEY_ID); restic -r s3:usc1.contabostorage.com/$username restore $snapshotid --password-file "/home/$username/$username" --target /backup/ >> /home/cyberpanel/incbackup-cs.txt
