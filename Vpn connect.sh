nmcli connection up id "vpn connection name"
read -t 3 -p "Connecting to vpn..."
echo "route configuration"
sudo route del -net default gw 10.10.14.1 netmask 0.0.0.0 dev tun0
sudo route del -net default gw 10.10.14.1 netmask 0.0.0.0 dev tun1
sudo route del -net default gw 10.18.0.1 netmask 0.0.0.0 dev tun0
echo "vpn ready"
