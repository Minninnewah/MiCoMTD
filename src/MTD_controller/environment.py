
TopoFuzzer_IP = "10.161.2.164"
TopoFuzzer_PORT = 8000

Server_controller_ips = [
    "160.85.255.147"
]

clusters = {
    "cluster_1": "160.85.255.147",
    "cluster_2": "160.85.255.163"
}

# So the traffic between service can go directly if in the same net. If this is not the case, use the public IPs exactly as in the clusters object above. In our environment the local IP is the IP of the tun0
#interface because TopoFuzzer is in a different net that we are connected to using vpn.
local_ip = {
    "cluster_1": "10.171.1.3",
    "cluster_2": "10.171.1.2"
}

Server_controller_port = 6666

service_manifests = {
    "drone": "https://raw.githubusercontent.com/Minninnewah/aucas_microservice_edge_testbed/main/services/drone/drone.yaml",
    "cloud_db": "https://raw.githubusercontent.com/Minninnewah/aucas_microservice_edge_testbed/main/services/cloud_db/cloud_db.yaml",
    "simple-stateless": "https://raw.githubusercontent.com/Minninnewah/aucas_microservice_edge_testbed/main/services/test_service_stateless/simple_stateless.yaml",
    "simple-stateful": ""
}

# If using a TopoFuzzer in the same network and a physical router then the ip is directly from the subnet like 10.70.0.1.
# In our case we have TopoFuzzer in a different net and therefore an additional VM for each subnet address to make it work.
service_subnet_mapping = {
    "simple-stateless": "10.70.0.1"
}