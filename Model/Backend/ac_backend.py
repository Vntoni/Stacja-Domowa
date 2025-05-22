import asyncio

from PySide6.QtCore import QObject, Signal, Property
from qasync import asyncSlot
from Model.AC.AC_Control import ACUnit
from pyairstage.airstageAC import AirstageAC, ApiCloud

username = "antekmigala@gmail.com"
password = "F5eotvky"
country = "PL"

class Backend(QObject):
    tempIndoorChanged = Signal(str, float)
    def __init__(self):
        super().__init__()
        self.salon = None
        self.jadalnia = None

    async def init_ac_units(self):
        api = ApiCloud(username=username, password=password, country=country)
        await api.authenticate()
        self.salon = AirstageAC("E8FB1CFF888D", api)
        self.jadalnia = AirstageAC("505A6531B561", api)
        await self.jadalnia.refresh_parameters()
        await self.salon.refresh_parameters()
        print("Jednostki klimatyzacji gotowe!")

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
    def get_target_temp(self, room):
        match room:
            case "Salon":
                self.salon.get_target_temperature()
            case "Jadalnia":
                self.jadalnia.get_target_temperature()

    @asyncSlot(str)
    async def set_target_temp(self, room, temp):
        match room:
            case "Salon":
                await self.salon.set_target_temperature(self, temp)
            case "Jadalnia":
                await self.jadalnia.set_target_temperature(self, temp)

    @asyncSlot(str)
    def get_economy(self, room):
        match room:
            case "Salon":
                self.salon.get_economy_mode(self)
            case "Jadalnia":
                self.jadalnia.get_economy_mode(self)

    @asyncSlot(str)
    async def set_economy(self, room, mode: bool):
        match room:
            case "Salon":
                await self.salon.set_economy_mode(self, mode)
            case "Jadalnia":
                await self.jadalnia.set_economy_mode(self, mode)

    @asyncSlot(str)
    def get_powerful(self, room):
        match room:
            case "Salon":
                self.salon.get_powerful_mode(self)
            case "Jadalnia":
                self.jadalnia.get_powerful_mode(self)

    @asyncSlot(str)
    async def set_powerful(self, room, mode: bool):
        match room:
            case "Salon":
                await self.salon.set_powerful_mode(self, mode)
            case "Jadalnia":
                await self.jadalnia.set_powerful_mode(self, mode)

    @asyncSlot(str)
    def get_low_noise(self, room):
        match room:
            case "Salon":
                self.salon.get_outdoor_low_noise(self)
            case "Jadalnia":
                self.jadalnia.get_outdoor_low_noise(self)

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
                self.salon.get_energy_save_fan(self)
            case "Jadalnia":
                self.jadalnia.get_energy_save_fan(self)

    @asyncSlot(str)
    async def set_power_save_fan(self, room, mode: bool):
        match room:
            case "Salon":
                await self.salon.set_energy_save_fan(self, mode)
            case "Jadalnia":
                await self.jadalnia.set_energy_save_fan(self, mode)

    @asyncSlot(str)
    def get_mode_operation(self, room):
        match room:
            case "Salon":
                self.salon.get_operating_mode(self)
            case "Jadalnia":
                self.jadalnia.get_operating_mode(self)

    @asyncSlot(str)
    async def set_mode_operation(self, room, mode: int):
        match room:
            case "Salon":
                await self.salon.set_operation_mode(self, mode)
            case "Jadalnia":
                await self.jadalnia.set_operation_mode(self, mode)

async def main():
    x = Backend()
    await x.init_ac_units()
    await x.jadalnia.refresh_parameters()
    await x.salon.refresh_parameters()
    pass

# asyncio.run(main())