
TopoFuzzer_IP = "160.85.253.118"
TopoFuzzer_PORT = 8000

Server_controller_ips = [
    "160.85.253.79"
]

clusters = {
    "cluster_1": "160.85.255.147",
    "cluster_2": "160.85.255.147"
}
Server_controller_port = 6666

service_manifests = {
    "drone": "https://raw.githubusercontent.com/Minninnewah/aucas_microservice_edge_testbed/main/services/drone/drone.yaml",
    "cloud_db": "https://raw.githubusercontent.com/Minninnewah/aucas_microservice_edge_testbed/main/services/cloud_db/cloud_db.yaml",
    "simple-stateless": "https://raw.githubusercontent.com/Minninnewah/aucas_microservice_edge_testbed/main/services/test_service_stateless/simple_stateless.yaml",
}
