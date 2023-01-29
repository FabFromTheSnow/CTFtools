#!/bin/bash
# CTF recon
echo Enter CTF Name
read CTF
echo Enter CTF target IP
read target
mkdir "$CTF"
cd "$CTF"
curl $target/robots.txt >> Recon.txt
nmap -sV -Pn -T5 $target >> Recon.txt
echo "Nmap done"
echo "Nikto wil take time, start browsing"
nikto -h $target >> Recon.txt
echo check your new folder
