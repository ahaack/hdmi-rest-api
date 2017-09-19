from json import JSONEncoder

from pycec.network import HDMIDevice, PhysicalAddress


class HDMIDeviceEncoder(JSONEncoder):
    def default(self, obj):
        if isinstance(obj, HDMIDevice):
            return {
                'address': obj.logical_address,
                'powerStatus': obj.power_status,
                'vendor:': obj.vendor
            }
        else:
            return JSONEncoder.default(self, obj)
