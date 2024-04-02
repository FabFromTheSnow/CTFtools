#!/bin/bash
# CTF recon
# test
echo Enter CTF Name
read CTF
echo Enter CTF target IP
read TARGET
echo $TARGET $CTF'.htb' >> /etc/hosts
export ip=$TARGET

mkdir "$CTF"
cd "$CTF"

PORTS=$(nmap -sS -Pn -p- $TARGET | grep -oP '\d+(?=/tcp)' | tr '\n' ',' | sed 's/,$//')
echo 'OPEN ports :'$PORTS
echo "starting FULL scan in background"
nmap -sC -sV -Pn $TARGET -p $PORTS >> Recon.txt &
echo "Nmap done"
