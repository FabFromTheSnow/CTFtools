
import os 
import sys
import requests

Domains = open('domain.txt', 'r')

for domain in Domains:
    domain = domain.strip()
    url = 'https://' + domain
    try:
        response = requests.get(url) 
    except:
        response = " is not up"

    results = open('result.txt', 'a')
    results.write(url + " " + str(response) + "\n")

    try:
        url = 'http://' + domain
        response = requests.get(url)
    except:
        response = " is not up" 

    results = open('result.txt', 'a')
    results.write(url + " " + str(response) + "\n")
