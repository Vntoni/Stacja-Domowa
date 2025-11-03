from Ports.washer import WasherPort, WasherSnapshot

class WasherBleAdapter(WasherPort):
    def __init__(self, impl):
        self._impl = impl

    async def snapshot(self, listen_seconds: float = 8.0) -> WasherSnapshot:
        st = await self._impl.snapshot(listen_seconds=listen_seconds)
        return WasherSnapshot(
            online=bool(st.online),
            remaining_minutes=getattr(st, "remaining_minutes", None),
            last_seen=getattr(st, "last_seen", None),
        )
