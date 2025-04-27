import sys
import os
import asyncio

from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine
from PySide6.QtCore import qInstallMessageHandler
from qasync import QEventLoop, asyncSlot

from Model.Backend.ac_backend import Backend

if sys.platform.startswith("win"):
    from asyncio import WindowsSelectorEventLoopPolicy
    asyncio.set_event_loop_policy(WindowsSelectorEventLoopPolicy())

def messageHandler(mode, context, message):
    print(f"[QML] {message}")

qInstallMessageHandler(messageHandler)


async def main():
    os.environ["QT_LOGGING_RULES"] = "*.debug=true"
    os.environ["QT_LOGGING_RULES"] = "qt.qml=true; qt.quick=true"

    app = QGuiApplication(sys.argv)
    loop = QEventLoop(app)
    asyncio.set_event_loop(loop)


    engine = QQmlApplicationEngine()
    backend = Backend()
    engine.rootContext().setContextProperty("backend", backend)
    engine.addImportPath(sys.path[0])
    engine.loadFromModule("Example", "main")

    if not engine.rootObjects():
        sys.exit(-1)

    with loop:
        loop.create_task(backend.init_ac_units())
        loop.run_forever()

if __name__ == "__main__":
    asyncio.run(main())
