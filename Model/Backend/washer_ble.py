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
    def __init__(self, online=False, remaining=None, last_seen=None):
        self.online = online
        self.remaining_minutes = remaining
        self.last_seen = last_seen

class WasherMachine:
    def __init__(self, name_prefix="HwZ_fb0f405fe6002b0d2c", address="00:A0:50:CC:F3:6C"):
        self.name_prefix = name_prefix
        self.mac = address

    @staticmethod
    def _parse_remaining_minutes(data: bytes):
        print(len(data), data)
        # Nagłówek: 0x02 0x04 <len_lo> <len_hi> [payload...]
        if len(data) < 4 or data[0] != 0x02 or data[1] != 0x04:
            return None
        payload = data[4:]
        # W ~64-bajtowych ramkach minutes siedzi w payload[54] (z Twoich logów)
        if len(payload) >= 58:
            return payload[50]
        return None

    async def _find_device(self, timeout=4.0):
        dev = await BleakScanner.find_device_by_address(self.mac, timeout=timeout)
        if dev:
            return dev
        return None

    async def snapshot(self, listen_seconds=8.0) -> WasherStatus:
        """Łączy się na chwilę, łapie status i rozłącza."""
        dev = await self._find_device(timeout=4.0)
        if not dev:
            return WasherStatus(online=False, remaining=None, last_seen=None)

        remaining = None
        last_seen = None
        got_event = asyncio.Event()

        async with BleakClient(dev.address, timeout=30.0) as client:
            # Bleak 1.1: usługi zwykle są już wczytane, ale dajmy chwilę
            services = client.services
            if services is None or len(list(services.services.values())) == 0:
                await asyncio.sleep(0.3)
                services = client.services

            ac01 = services.get_characteristic(UUID_AC01)
            ac02 = services.get_characteristic(UUID_AC02)
            if not ac01 or not ac02:
                return WasherStatus(online=False, remaining=None, last_seen=None)

            def on_notify(_, data: bytes):
                nonlocal remaining, last_seen
                mins = self._parse_remaining_minutes(data)
                if mins is not None:
                    remaining = mins
                    last_seen = time.strftime("%Y-%m-%d %H:%M:%S")
                    got_event.set()

            # >>> WSZYSTKO robimy W ŚRODKU kontekstu połączenia <<<
            await client.start_notify(ac02, on_notify)

            # Sekwencja inicjalizacyjna na AC01
            for f in INIT_FRAMES:
                await client.write_gatt_char(ac01, f, response=False)
                await asyncio.sleep(0.1)

            # Czekamy na status (albo timeout)
            try:
                await asyncio.wait_for(got_event.wait(), timeout=listen_seconds)
            except asyncio.TimeoutError:
                pass
            finally:
                try:
                    await client.stop_notify(ac02)
                except Exception:
                    pass

        online = remaining is not None
        return WasherStatus(online=online, remaining=remaining, last_seen=last_seen)

# Test lokalny:
async def main():
    wm = WasherMachine()  # jeśli znasz MAC, podaj
    status = await wm.snapshot(listen_seconds=8.0)
    print("online:", status.online, "remaining:", status.remaining_minutes, "last_seen:", status.last_seen)
asyncio.run(main())
