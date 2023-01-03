from api.topofuzzer_handler import TopoFuzzerHandler
import environment

if __name__ == "__main__":
    topoFuzzer_handler = TopoFuzzerHandler(environment.TopoFuzzer_IP, environment.TopoFuzzer_PORT)
    results = topoFuzzer_handler.get_all_entries()
    print(results)
    topoFuzzer_handler.expose_service("160.85.253.118", "160.85.253.79")
    results = topoFuzzer_handler.get_all_entries()
    print(results)