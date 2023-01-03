from flask import Flask, json, request as req
from enums.scheduler_mode import SchedulerMode
from enums.mtd_action import MTDAction
from enums.http_status_code import StatusCode
from threading import Thread, Event


api = Flask(__name__)
scheduler = None
server_thread = None

def start_API_server (scheduler_ref):
    global scheduler
    scheduler = scheduler_ref

    server_thread = Thread(target=lambda: api.run(use_reloader=False, debug=True))
    server_thread.setDaemon(True)  #So the thread stop when the main Thread stops
    server_thread.start()
    

def __generate_error_response (msg, statusCode = StatusCode.BAD_REQUEST):
    return json.dumps({"error": msg}), statusCode.value

def __generate_json_response (object, statusCode = StatusCode.OK):
    return json.dumps(object), statusCode.value

def __check_req_json_param (req, param):
    return req.json and req.json.get(param)

def __check_param_value (req, param, allowed_val):
    return req.json[param] in allowed_val

@api.route('/mode', methods=['GET'])
def get_mode():
    return __generate_json_response({"mode": scheduler.get_mode().name})

@api.route('/mode', methods=['PUT'])
def set_mode():
    param = "mode"
    if(not __check_req_json_param(req, param)):
        return __generate_error_response("Body is not json format or parameter 'mode' does not exist")

    if(not __check_param_value(req, param, SchedulerMode.get_list())):
        return __generate_error_response(f"Only {SchedulerMode.get_list()} allowed")

    mode = SchedulerMode[req.json[param]]
    scheduler.set_mode(mode)
        
    return __generate_json_response({param: scheduler.get_mode().name}, StatusCode.ACCEPTED)

@api.route('/action', methods=['POST'])
def set_manual_action ():
    param = "action"
    if(not __check_req_json_param(req, param)):
        return __generate_error_response("Body is not json format or parameter 'mode' does not exist")

    if(not __check_param_value(req, param, MTDAction.get_list())):
        return __generate_error_response(f"Only {MTDAction.get_list()} allowed")
    
    action = MTDAction[req.json[param]]
    scheduler.set_manuel_MTD_action(action)

    return __generate_json_response({}, StatusCode.CREATED)

@api.route('/actions', methods=['get'])
def get_actions ():
    return __generate_json_response({"actions": MTDAction.get_list()})


if __name__ == '__main__':
    start_API_server()