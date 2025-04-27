import asyncio
import ariston

class Boiler:
    def __init__(self, user, pwd, gw):
        # 1) zaloguj się
        asyncio.run(ariston._async_connect(user, pwd))

        # 2) pobierz obiekt Device (przekaż is_metric i lang!)
        self.device = asyncio.run(
            ariston.async_hello(user, pwd, gw, True, "en-US")
        )

        # 3) faktycznie pobierz dane
        asyncio.run(self._refresh_all())

        # 4) odczytaj je z obiektu
        self.features = self.device.attributes  # albo self.device._features
        # self.info  = self.device.are_device_features_available()
        # self.state    = self.device.state           # albo self.device._state
        # self.energy   = self.device.energy          # albo self.device._energy

    async def _refresh_all(self):
        await self.device.async_get_features()
        await self.device.async_update_state()
        await self.device.async_update_energy()

if __name__ == "__main__":
    b = Boiler("antekmigala@gmail.com", "F5eotvky!", "A842E373D878")
    # print(b.info)
    print("Features:", b.features)
    print(b.device.water_heater_current_temperature)
    # print("State:   ", b.state)
    # print("Energy:  ", b.energy)
    pass