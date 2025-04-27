import asyncio
from pyairstage import airstageApi
from pyairstage.airstageAC import AirstageAC
from pyairstage.airstageApi import AirstageApi, ApiCloud
from pyairstage.constants import *


class ACUnit:
    def __init__(self, dsn, api):
        self._dsn = dsn
        self._api = api
        self.ac = AirstageAC(dsn, api=api)
        self._cache = {}
        self._lastGoodValue = {}

    @classmethod
    async def create(cls, dsn, username, password, country):
        api = ApiCloud(username=username, password=password, country=country)
        await api.authenticate()
        return cls(dsn, api)

    async def update_parameters(self):
        return await self.ac.refresh_parameters()

    async def turn_on(self):
        await AirstageAC._set_device_parameter(self, ACParameter.ONOFF_MODE, BooleanProperty.ON)

    async def turn_off(self):
        await AirstageAC._set_device_parameter(self, ACParameter.ONOFF_MODE, BooleanProperty.OFF)

    async def get_temperature(self):
        return AirstageAC.get_display_temperature(self)

    async def set_target_temp(self, temp):
        return AirstageAC.set_target_temperature(self, temp)

    async def get_target_temp(self):
        return AirstageAC.set_target_temperature(self)






async def main():
    username = "antekmigala@gmail.com"
    password = "F5eotvky"
    country = "PL"

    jadalnia = await ACUnit.create("505A6531B561", username, password, country)
    salon = await ACUnit.create("E8FB1CFF888D", username, password, country)
    await jadalnia.refresh_parameters()
    await salon.update_parameters()
    print(salon._cache)
    # await salon.turn_on()
    # await salon.turn_off()
    # device = await jadalnia.api.get_devices()
    pass

    # await jadalnia.turn_on()
    # await salon.update_parameters()

# asyncio.run(main())