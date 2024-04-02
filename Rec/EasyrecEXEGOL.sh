#!/bin/bash
# CTF recon

echo Enter CTF Name
read CTF
echo Enter CTF target IP
read TARGET
echo $TARGET $CTF'.htb' >> /etc/hosts
export ip=$TARGET

mkdir "$CTF"
cd "$CTF"

# Installs Visual Studio Code if not present
if ! which code > /dev/null; then
  wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
  sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
  sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
  rm -f packages.microsoft.gpg
  sudo apt update
  sudo apt install code -y

  
fi

echo 'start quick nmap'
PORTS=$(nmap -sS -Pn --open -p 80,443,22,5000 $TARGET | grep -oP '\d+(?=/tcp)' | tr '\n' ',' | sed 's/,$//')
echo 'OPEN ports :'$PORTS
echo "starting FULL scan in background, vscode will open once done"
nmap -sC -sV -Pn $TARGET -p $PORTS >> "Recon.txt" && code "./Recon.txt"
echo "Masscan running in background for udp"
(masscan -pU:0-65535 $TARGET --rate=10000 --interface tun0 >> ./Recon.txt) &

if grep -qi 'http' "Recon.txt"; then
echo 'webserver detected'

fi




