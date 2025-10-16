#!/bin/bash
# Automated script to create a reverse proxy for a cPanel hosted domain
# Usage: ./cpd.sh <cpanel_username> <cpanel_domainname> [proxy_port]

cpanel_username=$1
cpanel_domainname=$2
proxy_port=${3:-3000}  # Default start port if not provided

# --- Check Arguments ---
if [[ $# -lt 2 ]]; then
    echo "❌ Missing arguments."
    echo "Usage: ./cpd.sh <cpanel_username> <cpanel_domainname> [proxy_port]"
    exit 1
fi

# --- Function to Check if Port is Free ---
check_port() {
    local port=$1
    if ss -tuln | grep -q ":${port}\b"; then
        return 1  # In use
    else
        return 0  # Free
    fi
}

# --- Find Next Available Port ---
start_port=$proxy_port
while ! check_port "$proxy_port"; do
    ((proxy_port++))
    if [[ $proxy_port -gt 65535 ]]; then
        echo "❌ No available ports found after $start_port"
        exit 1
    fi
done

if [[ $proxy_port -ne $start_port ]]; then
    echo "⚠️ Port $start_port is in use. Using next available port: $proxy_port"
else
    echo "✅ Using port $proxy_port"
fi

# --- Define Paths ---
ssl_path="/etc/apache2/conf.d/userdata/ssl/2_4/${cpanel_username}/${cpanel_domainname}"
std_path="/etc/apache2/conf.d/userdata/std/2_4/${cpanel_username}/${cpanel_domainname}"
conf_file_name="proxyconfig.conf"

# --- Create Directories ---
mkdir -p "$ssl_path" "$std_path"

# --- Create Proxy Config Content ---
proxy_config=$(cat <<EOF
############# Auto-generated Proxy Config ###############
<IfModule mod_rewrite.c>
RewriteEngine On
RewriteCond %{HTTPS} off
RewriteCond %{REQUEST_URI} !^/[0-9]+\\..+\\.cpaneldcv\$
RewriteCond %{REQUEST_URI} !^/\\.well-known/pki-validation/[A-F0-9]{32}\\.txt(?:\\ Comodo\\ DCV)?\$
RewriteCond %{REQUEST_URI} !^/\\.well-known/acme-challenge/.+\$
RewriteCond %{REQUEST_URI} !^/\\.well-known/acme-challenge/[0-9a-zA-Z_-]+\$
RewriteRule ^(.*)\$ https://%{HTTP_HOST}%{REQUEST_URI} [QSA,R=301,L]
</IfModule>

ProxyRequests Off
ProxyTimeout 120
ProxyPreserveHost On
ProxyPass /.well-known/pki-validation/ !
ProxyPass /.well-known/acme-challenge/ !
ProxyPass / http://127.0.0.1:${proxy_port}/
ProxyPassReverse / http://127.0.0.1:${proxy_port}/
############# End Proxy Config ###############
EOF
)

# --- Write Config Files ---
echo "$proxy_config" > "${ssl_path}/${conf_file_name}"
echo "$proxy_config" > "${std_path}/${conf_file_name}"

# --- Permissions ---
chmod 644 "${ssl_path}/${conf_file_name}" "${std_path}/${conf_file_name}"

# --- Validate Apache Config ---
echo "🔍 Checking Apache configuration..."
apachectl configtest
if [[ $? -ne 0 ]]; then
    echo "❌ Apache configuration test failed. Please fix errors before rebuild."
    exit 1
fi

# --- Rebuild and Restart Apache ---
echo "🔧 Rebuilding and restarting Apache..."
/usr/local/cpanel/scripts/rebuildhttpdconf
/usr/local/cpanel/scripts/restartsrv_httpd

if [[ $? -eq 0 ]]; then
    echo "✅ Proxy setup complete for domain: ${cpanel_domainname}"
    echo "🔗 Proxied to: http://127.0.0.1:${proxy_port}/"
else
    echo "⚠️ Something went wrong while restarting Apache."
fi
