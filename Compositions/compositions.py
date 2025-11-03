# src/home/composition.py
import os
import ariston
from pyairstage.airstageAC import AirstageAC, ApiCloud
from Model.Backend.washer_ble import WasherMachine
from Config.settings import get_settings
from Adapters.airstage_ac_adapter import AirstageACAdapter
from Adapters.ariston_boiler_adapter import AristonBoilerAdapter
from Adapters.washer_ble_adapter import WasherBleAdapter
from App.climate_service import ClimateService
from App.water_heater_service import WaterHeaterService
from App.washer_service import WasherService
from Interface.qt_backend import QtHomeBackend

async def build_backend() -> QtHomeBackend:
    s = get_settings()

    # --- Airstage (klima) ---
    # Uwaga: użyj właściwych danych logowania Airstage (tutaj pobieramy z ENV)
    api = ApiCloud(username=s.user, password=s.pwd, country=s.airstage_country)
    await api.authenticate()

    ac_salon = AirstageACAdapter(s.salon_id, api, AirstageAC)
    ac_jadalnia = AirstageACAdapter(s.jadalnia_id, api, AirstageAC)
    climate = ClimateService({"Salon": ac_salon, "Jadalnia": ac_jadalnia})

    # --- Ariston (bojler) ---
    await ariston._async_connect(s.user, s.ariston_pwd)
    boiler_client = await ariston.async_hello(s.user, s.ariston_pwd, s.ariston_device_id, True, "en-US")
    boiler = AristonBoilerAdapter(boiler_client)
    boiler_svc = WaterHeaterService(boiler)

    # --- Pralka (BLE) ---
    washer_adapter = WasherBleAdapter(WasherMachine())
    washer_svc = WasherService(washer_adapter, poll_seconds=s.washer_poll_seconds)

    # --- Qt adapter (QObject) ---
    return QtHomeBackend(climate, boiler_svc, washer_svc)