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
echo $PORTS
nmap -sC -sV -Pn $TARGET -p $PORTS >> Recon.txt
echo "Nmap done"
