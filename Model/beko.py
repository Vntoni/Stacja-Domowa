import asyncio
import csv
import datetime as dt
from bleak import BleakScanner, BleakClient, BleakError

# --- KONFIG ---
TARGET_NAME_PREFIX = "HwZ_"  # u Ciebie nazwa zaczyna się od HwZ_
TARGET_MAC = "88:F2:BD:3C:58:43"  # jeśli znasz; inaczej zostaw i skrypt znajdzie po nazwie
UUIDS = {
    "AC01": "0000ac01-0000-1000-8000-00805f9b34fb",
    "AC02": "0000ac02-0000-1000-8000-00805f9b34fb",
    "AC03": "0000ac03-0000-1000-8000-00805f9b34fb",
    "AC04": "0000ac04-0000-1000-8000-00805f9b34fb",
}
INIT_FRAMES = [
    bytes.fromhex("02 05 00"),
    bytes.fromhex("02 03 00 03 00 00 39"),
    bytes.fromhex("02 03 00 03 01 00 2B"),
]
KEEPALIVE_EVERY_SEC = 5   # co ile wysłać prosty „ping” na AC01 (0 = wyłącz)
CSV_FILE = "homewhiz_stream2.csv"

def hx(b: bytes) -> str:
    return " ".join(f"{x:02X}" for x in b)

def parse_header(b: bytes) -> dict:
    out = {"len": None, "msg_type": None, "hdr0": None}
    if len(b) >= 1: out["hdr0"] = b[0]
    if len(b) >= 2: out["msg_type"] = b[1]
    if len(b) >= 4: out["len"] = b[2] | (b[3] << 8)
    return out

async def pick_device(timeout=4.0):
    devs = await BleakScanner.discover(timeout=timeout)
    # 1) dokładny MAC
    for d in devs:
        if d.address.upper() == TARGET_MAC.upper():
            return d
    # 2) prefiks nazwy
    for d in devs:
        name = (getattr(d, "name", "") or "")
        if name.startswith(TARGET_NAME_PREFIX):
            return d
    # 3) fallback: najsilniejszy
    if devs:
        devs.sort(key=lambda x: getattr(x, "rssi", -999) or -999, reverse=True)
        return devs[0]
    return None

async def stream_once(address: str):
    async with BleakClient(address, timeout=30.0) as client:
        services = client.services
        if services is None or len(list(services.services.values())) == 0:
            await asyncio.sleep(0.3)
            services = client.services

        # znajdź charakterystyki
        chars = {k: services.get_characteristic(u) for k, u in UUIDS.items()}
        if not chars["AC01"] or not chars["AC02"]:
            print("🗺️  Brakuje AC01/AC02 — mapa poniżej:")
            for s in services:
                for ch in s.characteristics:
                    print(f"  {ch.uuid} @ 0x{getattr(ch,'handle',0):04X} props={ch.properties}")
            raise BleakError("Brak AC01/AC02")

        # CSV
        f = open(CSV_FILE, "a", newline="", buffering=1)
        writer = csv.DictWriter(f, fieldnames=["ts", "uuid", "handle", "hex", "len", "msg_type", "hdr0"])
        if f.tell() == 0:
            writer.writeheader()

        # handler wspólny
        def on_notify(sender, data: bytes):
            ts = dt.datetime.now().isoformat(timespec="milliseconds")
            parsed = parse_header(data)
            # rozpoznaj uuid/handle
            uu = None; hh = None
            if hasattr(sender, "uuid"):
                uu = sender.uuid; hh = getattr(sender, "handle", None)
            elif isinstance(sender, int):
                for u, ch in chars.items():
                    if ch and getattr(ch, "handle", None) == sender:
                        uu = ch.uuid; hh = sender; break
            elif isinstance(sender, str):
                uu = sender
            row = {
                "ts": ts,
                "uuid": uu or "",
                "handle": f"0x{hh:04X}" if isinstance(hh, int) else (hh if hh is not None else ""),
                "hex": hx(data),
                "len": parsed.get("len"),
                "msg_type": parsed.get("msg_type"),
                "hdr0": parsed.get("hdr0"),
            }
            print(f"📨 {ts} {uu or ''} {row['handle'] or ''}: {row['hex']}")
            writer.writerow(row)

        # subskrypcje na AC01–AC04 (jeśli obsługują notify)
        print("🔔 Subskrypcje:")
        for k in ["AC01","AC02","AC03","AC04"]:
            ch = chars.get(k)
            if not ch:
                print(f"  ⚠️ {k} brak")
                continue
            try:
                await client.start_notify(ch, on_notify)
                print(f"  ✔ {k} @ 0x{ch.handle:04X} props={ch.properties}")
            except Exception as e:
                print(f"  ⚠️ {k}: notify nieaktywne ({e})")

        # init na AC01
        print("🧩 Init → AC01…")
        for frame in INIT_FRAMES:
            try:
                await client.write_gatt_char(chars["AC01"], frame, response=False)
                await asyncio.sleep(0.1)
            except Exception as e:
                print(f"  ⚠️ write AC01 {hx(frame)}: {e}")

        # opcjonalny keepalive
        async def keepalive():
            if KEEPALIVE_EVERY_SEC <= 0:
                return
            while True:
                try:
                    await client.write_gatt_char(chars["AC01"], INIT_FRAMES[0], response=False)
                except Exception:
                    return
                await asyncio.sleep(KEEPALIVE_EVERY_SEC)

        ka_task = asyncio.create_task(keepalive())

        print("▶️  Strumień uruchomiony. Zmieniaj stan pralki (drzwi, start/stop). Ctrl+C, by zakończyć.")
        try:
            while True:
                await asyncio.sleep(1)
        except KeyboardInterrupt:
            pass
        finally:
            ka_task.cancel()
            for k in ["AC01","AC02","AC03","AC04"]:
                ch = chars.get(k)
                if ch:
                    try: await client.stop_notify(ch)
                    except: pass
            f.close()

async def main():
    # pętla autoreconnect
    while True:
        dev = await BleakScanner.find_device_by_address(TARGET_MAC, timeout=3.0)
        if not dev:
            dev = await pick_device(timeout=4.0)
        if not dev:
            print("🔎 Nie znalazłem urządzenia — czy pralka jest w trybie parowania?")
            await asyncio.sleep(2.0)
            continue
        print(f"🔍 Kandydat: {dev.address} name={getattr(dev,'name',None)} rssi={getattr(dev,'rssi',None)}")
        try:
            await stream_once(dev.address)
        except Exception as e:
            print(f"❌ Rozłączono/błąd: {e} — ponawiam w 2 s…")
            await asyncio.sleep(2.0)
            # i pętla leci dalej (auto-reconnect)

if __name__ == "__main__":
    asyncio.run(main())
