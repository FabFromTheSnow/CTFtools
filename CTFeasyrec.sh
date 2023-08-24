#!/bin/bash
# CTF recon
echo Enter CTF Name
read CTF
echo Enter CTF target IP
read target
echo $TARGET $CTF'.htb' >> /etc/hosts
export ip=$TARGET

mkdir "$CTF"
cd "$CTF"

PORTS=$(nmap -sS -Pn -p- $TARGET | grep -oP '\d+(?=/tcp)' | tr '\n' ',' | sed 's/,$//')
nmap -sC -sV -Pn $TARGET -p $PORTS >> Recon.txt
echo "Nmap done"


echo "open info with VScode"
code Recon.txt

echo "Nikto wil take time, saving in Nikto.txt"
nikto -h $TARGET >> Nikto.txt

echo open nikto with VScode
code Nikto.txt


HTTP=$(curl $TARGET --max-time 5)
if [[ $HTTP == *"http"* ]]; then
    # Faites quelque chose si la variable contient "http"
    echo "La variable \$HTTP contient 'http'."
else
    # Passez à la suite du script si la variable ne contient pas "http"
    echo "La variable \$HTTP ne contient pas 'http'."
fi
