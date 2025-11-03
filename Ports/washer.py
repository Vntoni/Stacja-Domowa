
from typing import Protocol, Optional
from dataclasses import dataclass

@dataclass
class WasherSnapshot:
    online: bool
    remaining_minutes: Optional[int]
    last_seen: Optional[str]

class WasherPort(Protocol):
    async def snapshot(self, listen_seconds: float = 8.0) -> WasherSnapshot: ...
