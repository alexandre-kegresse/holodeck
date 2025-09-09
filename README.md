# Autoinstallation ( DNS, DHCP , PHP7/8 , Mariadb , Nginx ,Proftpd)

## Préparation de la VM
- 2 Vcpu
- 2 Go RAM
- 20 Go Disque
- 1 carte réseau NAT ( WAN )
- 1 carte reseau Host only ( DHCP désactivé ) (LAN )  
- 

## Installation   
 - Debian 13 de base sans GUI
 - Installlation : git
 - Pas de sudo

## Récuperation Scripts
- git clone https://github.com/thierry-rami/holodeck.git
- cd /root/holodeck
- Modifications des scripts en fonction des cartes reseau ( actuellement ens32 : WAN , ens33 : LAN )
    - etc/network/interfaces
    - etc/dnsmasq.conf
    - etc/iptables-nat.sh


## Installation
 - bash /root/holodeck/root/install.sh
 - Reboot du systeme

## Services
 - nginx
    - https://www7.starfleet.lan
    - https://www8.starfleet.lan
    - https://php.starfleet.lan
    - https://192.168.15.254
 - mariadb
    - compte root / Laplateforme.io
    - compte phpmyadmin / laplateforme.io
 - php7 : 7.4
 - php8 : 8.4
 - proftpd


