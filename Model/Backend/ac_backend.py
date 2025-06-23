import asyncio
import ariston
from PySide6.QtCore import QObject, Signal, Property
from qasync import asyncSlot
from Model.AC.AC_Control import ACUnit
from pyairstage.airstageAC import AirstageAC, ApiCloud

username = "antekmigala@gmail.com"
password = "F5eotvky"
country = "PL"

class Backend(QObject):

    # AC Signals
    tempIndoorChanged = Signal(str, float)
    modeReceived = Signal(str, str)
    targetTemperatureReceived = Signal(str, float)
    economyReceived = Signal(str, bool)
    powerfulReceived = Signal(str, bool)
    lowNoiseReceived = Signal(str, bool)

    # Boiler Signals
    waterTemp = Signal(float)

    def __init__(self):
        super().__init__()
        self.salon = None
        self.jadalnia = None
        self.boiler = None
        self.user = "antekmigala@gmail.com"
        self.pwd = "F5eotvky!"

    async def init_ac_units(self):
        api = ApiCloud(username=username, password=password, country=country)
        await api.authenticate()
        self.salon = AirstageAC("E8FB1CFF888D", api)
        self.jadalnia = AirstageAC("505A6531B561", api)
        await self.jadalnia.refresh_parameters()
        await self.salon.refresh_parameters()
        print("Jednostki klimatyzacji gotowe!")
        await ariston._async_connect(self.user, self.pwd)
        self.boiler = await ariston.async_hello(self.user, self.pwd, "A842E373D878", True, "en-US")
        await self.boiler.async_get_features()
        await self.boiler.async_update_state()
        await self.boiler.async_update_energy()

    """
    AC Units functions sections starts
    """
    @asyncSlot(str)
    async def turn_on_ac(self, room):
        match room:
            case "Salon":
                await self.salon.turn_on()
            case "Jadalnia":
                await self.jadalnia.turn_on()

    @asyncSlot(str)
    async def turn_off_ac(self, room):
        match room:
            case "Salon":
                await self.salon.turn_off()
            case "Jadalnia":
                await self.jadalnia.turn_off()

    @asyncSlot(str)
    async def get_temp_indoor(self, room):
        match room:
            case "Salon":
                temp = self.salon.get_display_temperature()
            case "Jadalnia":
                temp = self.jadalnia.get_display_temperature()
        self.tempIndoorChanged.emit(room, temp)

    @asyncSlot(str)
    async def get_target_temp(self, room):
        match room:
            case "Salon":
                target_temp = self.salon.get_target_temperature()
            case "Jadalnia":
                target_temp = self.jadalnia.get_target_temperature()
        self.targetTemperatureReceived.emit(room, target_temp)

    @asyncSlot(str)
    async def set_target_temp(self, room, temp):
        match room:
            case "Salon":
                await self.salon.set_target_temperature(self, temp)
            case "Jadalnia":
                await self.jadalnia.set_target_temperature(self, temp)

    @asyncSlot(str)
    async def get_economy(self, room):
        match room:
            case "Salon":
                economy_state = self.salon.get_economy_mode()
            case "Jadalnia":
                economy_state = self.jadalnia.get_economy_mode()
        self.economyReceived.emit(room, economy_state)

    @asyncSlot(str)
    async def set_economy(self, room, mode: bool):
        match room:
            case "Salon":
                await self.salon.set_economy_mode(self, mode)
            case "Jadalnia":
                await self.jadalnia.set_economy_mode(self, mode)

    @asyncSlot(str)
    async def get_powerful(self, room):
        match room:
            case "Salon":
                powermode_state = self.salon.get_powerful_mode()
            case "Jadalnia":
                powermode_state = self.jadalnia.get_powerful_mode()
        self.powerfulReceived.emit(room, powermode_state)
    @asyncSlot(str)
    async def set_powerful(self, room, mode: bool):
        match room:
            case "Salon":
                await self.salon.set_powerful_mode(self, mode)
            case "Jadalnia":
                await self.jadalnia.set_powerful_mode(self, mode)

    @asyncSlot(str)
    async def get_low_noise(self, room):
        match room:
            case "Salon":
                lownoise_state = self.salon.get_outdoor_low_noise()
            case "Jadalnia":
                lownoise_state = self.jadalnia.get_outdoor_low_noise()
        self.lowNoiseReceived.emit(room, lownoise_state)

    @asyncSlot(str)
    async def set_low_noise(self, room, mode: bool):
        match room:
            case "Salon":
                await self.salon.set_powerful_mode(self, mode)
            case "Jadalnia":
                await self.jadalnia.set_powerful_mode(self, mode)

    @asyncSlot(str)
    def get_power_save_fan(self, room):
        match room:
            case "Salon":
                self.salon.get_energy_save_fan()
            case "Jadalnia":
                self.jadalnia.get_energy_save_fan()

    @asyncSlot(str)
    async def set_power_save_fan(self, room, mode: bool):
        match room:
            case "Salon":
                await self.salon.set_energy_save_fan(self, mode)
            case "Jadalnia":
                await self.jadalnia.set_energy_save_fan(self, mode)

    @asyncSlot(str)
    async def get_mode_operation(self, room):
        match room:
            case "Salon":
                mode = self.salon.get_operating_mode()
            case "Jadalnia":
                mode = self.jadalnia.get_operating_mode()
                print(mode)
                print(type(mode))
        self.modeReceived.emit(room, mode.value.lower())

    @asyncSlot(str)
    async def set_mode_operation(self, room, mode: int):
        match room:
            case "Salon":
                await self.salon.set_operation_mode(self, mode)
            case "Jadalnia":
                await self.jadalnia.set_operation_mode(self, mode)

    """
       Boiler functions sections starts
    """

    @asyncSlot(str)
    async def set_water_target_temp(self, temp: float):
        await self.boiler.async_set_lydos_temperature(temp)

    @asyncSlot()
    async def get_water_temp(self):
        temp = self.boiler.water_heater_current_temperature
        self.waterTemp.emit(temp)

    @asyncSlot(str)
    async def set_water_mode(self, mode: int):
        await self.boiler.set_lydos_mode(mode)

async def main():
    x = Backend()
    await x.init_ac_units()
    await x.jadalnia.refresh_parameters()
    await x.salon.refresh_parameters()
    pass

asyncio.run(main())