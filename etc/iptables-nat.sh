#!/bin/bash
# on vide  les règles existantes
iptables -t nat -F
iptables -t nat -X
iptables -F
iptables -X

# Autoriser le trafic sur l'interface locale
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

# Autoriser le trafic établi et relié
iptables -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
iptables -A FORWARD -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT

# Autoriser le trafic du LAN vers WAN
iptables -A FORWARD -i ens33 -o ens32 -j ACCEPT

# Autoriser ICMP (ping) depuis le LAN
iptables -A INPUT -i ens33 -p icmp -j ACCEPT
iptables -A FORWARD -i ens33 -o ens32 -p icmp -j ACCEPT

# Services réseau sur LAN
iptables -A INPUT -i ens33 -p udp --dport 67 -j ACCEPT  # DHCP
iptables -A INPUT -i ens33 -p udp --dport 53 -j ACCEPT  # DNS
iptables -A INPUT -i ens33 -p tcp --dport 53 -j ACCEPT  # DNS

# Services web sur LAN
iptables -A INPUT -i ens33 -p tcp --dport 80 -j ACCEPT   # HTTP
iptables -A INPUT -i ens33 -p tcp --dport 443 -j ACCEPT  # HTTPS

# Cockpit (port 9090)
iptables -A INPUT -i ens33 -p tcp --dport 9090 -j ACCEPT

# SSH
iptables -A INPUT -i ens33 -p tcp --dport 22 -j ACCEPT

# NAT : masquerading pour le trafic sortant
iptables -t nat -A POSTROUTING -o ens32 -j MASQUERADE

# Politique par défaut
iptables -P FORWARD DROP

