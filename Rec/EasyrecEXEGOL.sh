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

mkdir "$CTF"
cd "$CTF" || exit

# Installs Visual Studio Code if not present
if ! which code > /dev/null; then
  wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
  sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
  sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
  rm -f packages.microsoft.gpg
  sudo apt update
  sudo apt install code -y
fi

echo -e "${BOLD}start quick nmap${NO_COLOR}"
PORTS=$(nmap -sS -Pn --open -p 80,443,22,5000 "$TARGET" | grep -oP '\d+(?=/tcp)' | tr '\n' ',' | sed 's/,$//')
echo -e "${BOLD}OPEN ports: $PORTS${NO_COLOR}"
echo -e "${BOLD}starting FULL scan, vscode will open once done${NO_COLOR}"
nmap -sC -sV -Pn "$TARGET" -p "$PORTS" >> "Recon.txt" 
echo -e "${BOLD}Masscan running in background for udp${NO_COLOR}"

if grep -qi '443/tcp open' "Recon.txt"; then
    echo -e "${BOLD}Web server detected (https)${NO_COLOR}"
    nohup dirb "https://$CTFurl/" /usr/share/seclists/Discovery/Web-Content/big.txt -o ./WebServ &>/dev/null &
elif grep -qi '80/tcp open' "Recon.txt"; then
    echo -e "${BOLD}Web server detected (http)${NO_COLOR}"
    nohup dirb "http://$CTFurl/" /usr/share/seclists/Discovery/Web-Content/big.txt -o ./WebServ &>/dev/null &
fi

masscan -pU:0-65535 "$TARGET" --rate=10000 --interface tun0 >> ./Recon.txt
code ./Recon.txt --no-sandbox --user-data-dir=./
