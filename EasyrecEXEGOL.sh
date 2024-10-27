#!/bin/bash
# CTF recon

BOLD='\033[1m'
NO_COLOR='\033[0m'
RED='\e[31m'

cat <<'EOF'
 ______    _     
|  ___|  | |    
| |_ __ _| |__  
|  _/ _\` | '_ \ 
| || (_| | |_) |
\_| \__,_|_.__/             
                
EOF
        

echo -e "${RED}This script should be started from tmux${NO_COLOR}"
echo " "
echo -e "${BOLD}Enter CTF Name:${NO_COLOR}"
read CTF
echo -e "${BOLD}Enter CTF target IP:${NO_COLOR}"
read TARGET
CTFurl="${CTF}.htb"
echo "$TARGET $CTFurl" | sudo tee -a /etc/hosts

mkdir -p "$CTF"
cd "$CTF"
OUTPUT_DIR="$PWD"

echo -e "${BOLD}Starting quick nmap scan...${NO_COLOR}"
nmap -sS -Pn --open "$TARGET" -T5 > "/tmp/QuickScan.txt"
PORTS=$(grep -oP '\d+(?=/tcp)' "/tmp/QuickScan.txt" | tr '\n' ',' | sed 's/,$//')
echo -e "${BOLD}Open ports: $PORTS${NO_COLOR}"
echo -e "${BOLD}Starting nmap script and version scan on open ports,.${NO_COLOR}"
nmap -sC -sV -Pn "$TARGET" -p "$PORTS" > "QuickNmap.txt"
tmux new-window -d -n "AllNmap" -c "$OUTPUT_DIR" \
"echo starting complete nmap && nmap -A -Pn $TARGET -p- -vv > FullNmap.txt && echo Scan complete, read output in FullNmap.txt"

# Check for HTTPS web server
if grep -qi '443/tcp open' "QuickNmap.txt"; then
    echo -e "${BOLD}Web server detected (HTTPS).${NO_COLOR}"
    tmux new-window -n "WebServHTTPS" -c "$OUTPUT_DIR" \
    "CTFurl='$CTFurl'; dirb https://\$CTFurl/ /usr/share/seclists/Discovery/Web-Content/big.txt > ./WebServHTTPS.txt"
    webServerHTTPS=true
fi

# Check for HTTP web server
if grep -qi '80/tcp open' "QuickNmap.txt"; then
    echo -e "${BOLD}Web server detected (HTTP).${NO_COLOR}"
    tmux new-window -n "WebServHTTP" -c "$OUTPUT_DIR" \
    "CTFurl='$CTFurl'; dirb http://\$CTFurl/ /usr/share/seclists/Discovery/Web-Content/big.txt > ./WebServHTTP.txt"
    webServerHTTP=true
fi

# robots + Subdomain 
if [ "$webServerHTTP" = true ] || [ "$webServerHTTPS" = true ]; then
    echo "Downloading Robots.txt or 404 :) "
    curl "$CTFurl/robots.txt" > ./Robots.txt
    tmux new-window -n "SubDomain" -c "$OUTPUT_DIR" \
    "CTFurl='$CTFurl'; gobuster vhost -k --domain \$CTFurl --append-domain -u \$CTFurl -w /opt/seclists/Discovery/DNS/bitquark-subdomains-top100000.txt"
fi

# Start masscan in a new tmux window
echo -e "${BOLD}Masscan running in background for UDP.${NO_COLOR}"
tmux new-window -n "MasscanUDP" -c "$OUTPUT_DIR" \
"TARGET='$TARGET'; masscan -pU:0-65535 \$TARGET --rate=10000 --interface tun0 > ./ReconUDP.txt && echo Masscan over"


