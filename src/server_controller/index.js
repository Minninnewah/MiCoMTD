'use strict';

const express = require('express');
const util = require('util');
const exec = util.promisify(require('child_process').exec);


const app = express()
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Constants
const PORT = 6666;
const HOST = '0.0.0.0';

const execute_kubectl = async (command) => {

    const { stdout, stderr } = await exec("kubectl " + command, { shell: true });
    return stdout;
}

const get_all_services = async () => {
    const service_command = "get services -o json";
    let data = await execute_kubectl(service_command);
    let services = []
    data = JSON.parse(data);
    data.items.forEach(element => {
        services.push(element.metadata.name)
    });
    //console.log(services)
    return services;
}

const get_all_pods = async () => {
    const pod_command = "get pods -o json";
    let data = await execute_kubectl(pod_command);
    let pods = []
    data = JSON.parse(data);

    data.items.forEach(element => {
        pods.push({
            node: element.spec.nodeName,
            name: element.metadata.name
        })
    })
    return pods;
}

const get_all_nodes = async () => {
    const nodes_command = "get nodes -o json";
    let data = await execute_kubectl(nodes_command);
    let nodes = []
    data = JSON.parse(data);

    data.items.forEach(element => {
        //Perhaps this changes with nodeport services
        let ip = "";
        element.status.addresses.forEach(address => {
            console.log(address)
            if(address.type == "InternalIP") {
                ip = address.address
            }
        })
        nodes.push({
            name: element.metadata.name,
            ip: ip
        })
    })
    return nodes;
}

async function get_nodes(req, res) {
    let data = await get_all_nodes();
    res.status(200).json(data);
}

async function get_services(req, res) {
    let data = await get_all_services();
    res.status(200).json(data);
}  

async function get_pods(req, res) {
    let data = await get_all_pods();
    res.status(200).json(data);
}

async function get_deployment_to_service (service) {
    const command = "get deployments -o json --selector=app=" + service
    let data = await execute_kubectl(command);
    let deployments = []
    data = JSON.parse(data);

    data.items.forEach(element => {
        deployments.push(element.spec.selector.matchLabels.app)
    })
    return deployments;
}

async function get_statefulSet_to_service (service) {
    const command = "get statefulSet -o json --selector=app=" + service
    let data = await execute_kubectl(command);
    let statefulSets = []
    data = JSON.parse(data);

    data.items.forEach(element => {
        statefulSets.push(element.spec.selector.matchLabels.app)
    })
    return statefulSets;
}

async function restart_deployment(deployment) {
    const restart_deployment_command = "rollout restart deployment " + deployment;
    execute_kubectl(restart_deployment_command);
}

async function restart_statefulSet(statefulSet) {
    const restart_statefulSet_command = "rollout restart statefulSet " + statefulSet;
    execute_kubectl(restart_statefulSet_command);
}

async function stop_service(url_manifest) {
    command = "delete -f " + url_manifest
    execute_kubectl(restart_deployment_command);
}

async function start_service(url_manifest) {
    command = "apply -f " + url_manifest
    execute_kubectl(restart_deployment_command);
}

async function restart_service(req, res) {
    const service = req.params.service;
    const deployments = await get_deployment_to_service(service);
    const statefulSets = await get_statefulSet_to_service(service);

    deployments.forEach(deployment => {
        restart_deployment(deployment);
    })

    statefulSets.forEach(statefulSet => {
        restart_statefulSet(statefulSets);
    })

    res.status(200).send();
}

async function stop_service(req, res) {
    manifest_url = req.body.manifest_url
    
    stop_service(manifest_url);

    res.status(200).send();
}

async function start_service(req, res) {
    manifest_url = req.body.manifest_url
    
    start_service(manifest_url)

    res.status(200).send();
}

app.get('/nodes', get_nodes);
app.get('/pods', get_pods);
app.get('/services', get_services);
app.get('/restart/:service', restart_service)
app.delete('/stop/', stop_service)
app.post('/start/', start_service)

app.listen(PORT, HOST, () => {
    console.log(`Running on http://${HOST}:${PORT}`);
});
