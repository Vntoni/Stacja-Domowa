# Model/Washer/washer_ble.py
import asyncio
import time
from bleak import BleakScanner, BleakClient

UUID_AC01 = "0000ac01-0000-1000-8000-00805f9b34fb"  # write/init
UUID_AC02 = "0000ac02-0000-1000-8000-00805f9b34fb"  # notify/status

INIT_FRAMES = [
    bytes.fromhex("02 05 00"),
    bytes.fromhex("02 03 00 03 00 00 39"),
    bytes.fromhex("02 03 00 03 01 00 2B"),
]

class WasherStatus:
    def __init__(self, online=False, remaining=None):
        self.online = online               # bool
        self.remaining_minutes = remaining # int|None

class WasherMachine:
    def __init__(self, name="HwZ_fb0f405fe6002b0d2c", address="00:A0:50:CC:F3:6C" ):
        self.name = name
        self.mac = address

    async def connect(self):
        dev = await BleakScanner.find_device_by_address(self.mac, timeout=3.0)
        if not dev:
            return WasherStatus()
        else:
            return dev

        remaining = None

        async with BleakClient(dev.address, timeout=30.0) as client:
            services = client.services
            ac01 = services.get_characteristic(UUID_AC01)
            ac02 = services.get_characteristic(UUID_AC02)
            if not ac01 or not ac02:
                return WasherStatus()