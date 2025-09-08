cd /root/holodeck
cp etc/apt/sources.list.d/*  /etc/apt/sources.list.d
cp usr/share/keyrings/* /usr/share/keyrings
apt update
apt install proftpd-core  proftpd-mod-crypto wget -y
apt install dnsmasq iptables iptables-persistent lsb-release apt-transport-https ca-certificates wget nginx mariadb-server  unzip  cockpit lynx -y
apt install php7.4-fpm php7.4-mysql php7.4-cli php7.4-curl php7.4-gd php7.4-mbstring php7.4-xml php7.4-zip php7.4-mysql -y  
apt install php8.4-fpm php8.4-mysql php8.4-cli php8.4-curl php8.4-gd php8.4-mbstring php8.4-xml php8.4-zip php8.4-mysql -y

cp -r /root/holodeck/* /
chmod +x /etc/iptables-nat.sh
sed -i "s/user  nginx;/user  www-data;/g"  /etc/nginx/nginx.conf

cd /etc/ssl/starfleet
# Créer la clé privée de la CA
#openssl genrsa -out starfleet-ca.key 4096
#openssl req -new -x509 -days 3650 -key starfleet-ca.key -out starfleet-ca.crt -subj "/C=FR/ST=PACA/L=Marseille/O=Starfleet Command/OU=IT Department/CN=Starfleet Root CA"
#openssl req -x509 -nodes -days 365 -newkey rsa:2048     -keyout starfleet-wildcard.key     -out starfleet-wildcard.crt     -config starfleet-wildcard.conf

openssl genrsa -out ca-starfleet-key.pem 4096
openssl req -new -x509 -days 365 -key ca-starfleet-key.pem -sha256 -out ca.pem -subj "/C=FR/ST=PACA/L=Marseille/O=VotreEntreprise/CN=Internal CA"
openssl genrsa -out starfleet.lan-key.pem 4096
openssl req -subj "/CN=starfleet.lan" -sha256 -new -key starfleet.lan-key.pem -out starfleet.lan.csr
echo "subjectAltName=DNS:starfleet.lan,DNS:*.starfleet.lan,IP:192.168.15.254" > extfile.cnf
openssl x509 -req -days 365 -sha256 -in starfleet.lan.csr -CA ca.pem -CAkey ca-starfleet-key.pem -out starfleet.lan-cert.pem -extfile extfile.cnf -CAcreateserial

cd /var/www
wget https://files.phpmyadmin.net/phpMyAdmin/5.2.2/phpMyAdmin-5.2.2-all-languages.zip
unzip -q phpMyAdmin-5.2.2-all-languages.zip
mv phpMyAdmin-5.2.2-all-languages phpMyAdmin
rm *.zip

mkdir /var/www/certificates
cp /etc/ssl/starfleet/starfleet-ca.crt /var/www/certificates/.


chown -R www-data: /var/www/phpMyAdmin
cp /var/www/phpMyAdmin/config.sample.inc.php /var/www/phpMyAdmin/config.inc.php

blow=$(openssl rand -base64 32 | cut -c1-32)
sed -i "s/\$cfg\['blowfish_secret'\] = '.*';/\$cfg['blowfish_secret'] = '$blow';/" /var/www/phpMyAdmin/config.inc.php

mariadb -u root < /root/maria.sql

systemctl enable iptables-nat.service
