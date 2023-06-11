#!/bin/bash
# CTF recon
echo Enter CTF Name
read CTF
echo Enter CTF target IP
read target
export ip=$target
mkdir "$CTF"
cd "$CTF"
curl $target/robots.txt --max-time 5 >> Recon.txt
nmap -sC -sV -Pn -T5 $target >> Recon.txt
echo "Nmap done"
echo "open info with sublime text"
subl Recon.txt
echo "Nikto wil take time, saving in Nikto.txt"
nikto -h $target >> Nikto.txt
echo open nikto with sublime text
subl Nikto.txt

