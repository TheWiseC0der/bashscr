#!/bin/sh
#istall curl/iptables if not installed and show which on screen also with &>:
which curl &> /dev/null || sudo apt install curl -y
which iptables &> /dev/null || sudo apt install iptables -y
#getting iptables-persistent intsalled
sudo apt install iptables-persistent
sudo apt-get install netfilter-persistent

#getting public IP adress from the web
$ipadress = curl ifconfig.me

#get updates
sudo apt update -y
#install basic firewall rules and overwrite file
sudo service netfilter-persistent flush
sudo iptables -S
sudo iptables -N UDP
sudo iptables -N TCP
sudo iptables -N ICMP
sudo iptables -A TCP -p tcp --dport 22 -j ACCEPT
#HTTPS
iptables -A OUTPUT -p tcp --sport 443 -j ACCEPT
iptables -A INPUT -p tcp -m tcp --dport 443 -j ACCEPT
#HTTP
iptables -A OUTPUT -p tcp --sport 80 -j ACCEPT
iptables -A INPUT -p tcp -m tcp --dport 80 -j ACCEPT
sudo iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
sudo iptables -A INPUT -i lo -j ACCEPT
sudo iptables -A INPUT -m conntrack --ctstate INVALID -j DROP
sudo iptables -A INPUT -p udp -m conntrack --ctstate NEW -j UDP
sudo iptables -A INPUT -p tcp --syn -m conntrack --ctstate NEW -j TCP
sudo iptables -A INPUT -p icmp -m conntrack --ctstate NEW -j ICMP
sudo iptables -A INPUT -p udp -j REJECT --reject-with icmp-port-unreachable
sudo iptables -A INPUT -p tcp -j REJECT --reject-with tcp-reset
sudo iptables -A INPUT -j REJECT --reject-with icmp-proto-unreachable
sudo iptables -P INPUT DROP
sudo iptables -P FORWARD DROP
sudo ip6tables -P INPUT DROP
sudo ip6tables -P FORWARD DROP
sudo ip6tables -P OUTPUT DROP
sudo service netfilter-persistent save
