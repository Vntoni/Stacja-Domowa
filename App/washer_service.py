import asyncio
from typing import Optional, Callable
from Ports.washer import WasherPort, WasherSnapshot

class WasherService:
    def __init__(self, washer: WasherPort, poll_seconds: float = 10.0):
        self._w = washer
        self._poll = poll_seconds
        self._task: Optional[asyncio.Task] = None

    def start(self, on_snapshot: Callable[[WasherSnapshot], None]) -> None:
        if self._task and not self._task.done():
            return
        async def _runner():
            while True:
                try:
                    st = await self._w.snapshot(listen_seconds=8.0)
                    on_snapshot(st)
                except Exception:
                    on_snapshot(WasherSnapshot(False, None, None))
                await asyncio.sleep(self._poll)
        self._task = asyncio.create_task(_runner())

    async def stop(self):
        if self._task and not self._task.done():
            self._task.cancel()
            try:
                await self._task
            except asyncio.CancelledError:
                pass