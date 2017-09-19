#!/usr/bin/env python
import sys
from flask import Flask, jsonify, request, abort
from pycec.cec import CecAdapter
from pycec.const import POWER_OFF, POWER_ON
from pycec.network import HDMINetwork

from encoder import HDMIDeviceEncoder

app = Flask(__name__)
app.json_encoder = HDMIDeviceEncoder

network = HDMINetwork(CecAdapter("raspberry", activate_source=True))
network.start()


@app.route('/api/v1.0/cec', methods=['GET'])
def cec_list():
    return jsonify({'devices': network.devices})


@app.route('/api/v1.0/cec/<int:device_id>', methods=['GET'])
def cec_get(device_id):
    return jsonify(network.get_device(device_id))


@app.route('/api/v1.0/cec/<int:device_id>', methods=['PUT'])
def cec_post(device_id):
    if not request.json or 'powerStatus' not in request.json:
        abort(400)

    device = network.get_device(device_id)
    status = int(request.json['powerStatus'])
    if status == POWER_OFF:
        device.turn_off()
    elif status == POWER_ON:
        device.turn_on()

    return jsonify(device)


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=4711)
