import requests

class TopoFuzzerHandler:

    def __init__(self, ip, port = 8000):
        self.url = "http://" + ip + ":" + str(port) + "/api/mappings/"

    def get_all_entries (self):
        response = requests.get(self.url)
        return response.json()

    def __convert_ip_to_private(self, ip):
        return ip.replace(".", "-")

    def __convert_ip_to_public(self, ip):
        return ip.replace(".", "_")

    def add_public_mapping (self, public_ip, private_ip):
        payload = {
            self.__convert_ip_to_public(public_ip): private_ip
        }
        response = requests.post( self.url, json=payload)
        print("TopoFuzzer response code: " + str(response.status_code))


    def update_public_mapping (self, public_ip, private_ip):
        payload = {
            "new_ip": private_ip
        }
        response = requests.put( self.url +self.__convert_ip_to_public(public_ip), json=payload)
        print("TopoFuzzer response code: " + str(response.status_code))
        pass