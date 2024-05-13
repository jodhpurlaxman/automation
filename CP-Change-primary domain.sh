#!/bin/bash
#Change Primary Domiain in Cpanel


cpanel_username=$1 
cpanel_domainname=$2

if [[ $# -eq 0 ]]
then
	echo "Arguments not given. Usage: ./cpd.sh cpanel_username cpanel_domainname"
else
    filename=/var/cpanel/userdata/${cpanel_username}/${cpanel_domainname}
    
    #backup the existing file
    cp ${filename} ${filename}.LX
    
    #Add Public in existing path 
    sed -i 's#public_html#'public_html/public'#g' ${filename}
    #sed -i 's#cgi-bin#'public/cgi-bin'#g' ${filename}
    
    #delete Cache file
    rm -vf ${filename}.cache

    #Backup SSL file
    cp ${filename}_SSL ${filename}_SSL.LX
    sed -i 's#public_html#'public_html/public'#g' ${filename}_SSL
    
    #delete Cache file
    rm -vf ${filename}_SSL.cache
    /scripts/updateuserdatacache && /scripts/rebuildhttpdconf && /scripts/restartsrv_httpd
    #backup the existing file
    cp ${filename}.php-fpm.yaml ${filename}.php-fpm.yaml.LX
    echo "php_admin_value_doc_root: { name: 'php_admin_value[doc_root]', value: /home/${cpanel_username}/public_html/public }" >> $filename.php-fpm.yaml
    rm -vf ${filename}php-fpm.cache
    /scripts/php_fpm_config --rebuild && /scripts/restartsrv_apache_php_fpm
fi
