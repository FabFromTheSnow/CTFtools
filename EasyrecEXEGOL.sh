#!/bin/bash
# CTF recon

BOLD='\033[1m'
NO_COLOR='\033[0m'

echo -e "${BOLD}Enter CTF Name${NO_COLOR}"
read CTF
echo -e "${BOLD}Enter CTF target IP${NO_COLOR}"
read TARGET
CTFurl=$CTF'.htb'
echo $TARGET $CTFurl >> /etc/hosts
export ip=$TARGET

mkdir -p "$CTF"
cd "$CTF" || exit

echo -e "${BOLD}Start quick nmap${NO_COLOR}"
nmap -sS -Pn --open "$TARGET" > "QuickScan.txt"
PORTS=$(cat "QuickScan.txt" | grep -oP '\d+(?=/tcp)' | tr '\n' ',' | sed 's/,$//')
echo -e "${BOLD}OPEN ports: $PORTS${NO_COLOR}"
echo -e "${BOLD}Starting FULL scan, please check Recon.txt once done${NO_COLOR}"
nmap -sC -sV -Pn "$TARGET" -p "$PORTS" >> "Recon.txt" 


# File discovery on webserver
if grep -qi '443/tcp open' "Recon.txt"; then
    echo -e "${BOLD}Web server detected (https)${NO_COLOR}"
    tmux new-window -n "WebServHTTPS"
    tmux send-keys -t "WebServHTTPS" "dirb https://$CTFurl/ /usr/share/seclists/Discovery/Web-Content/big.txt -o ./WebServHTTPS.txt" C-m
elif grep -qi '80/tcp open' "Recon.txt"; then
    echo -e "${BOLD}Web server detected (http)${NO_COLOR}"
    tmux new-window -n "WebServHTTP"
    tmux send-keys -t "WebServHTTP" "dirb http://$CTFurl/ /usr/share/seclists/Discovery/Web-Content/big.txt -o ./WebServHTTP.txt" C-m
fi

# Start masscan in a new tmux window
echo -e "${BOLD}Masscan running in background for udp${NO_COLOR}"
tmux new-window -n "MasscanUDP"
tmux send-keys -t "MasscanUDP" "masscan -pU:0-65535 $TARGET --rate=10000 --interface tun0 > ./ReconUDP.txt" C-m
