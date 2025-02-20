import sys
import os

from PyQt6.QtQuick import QQuickView
from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine



if __name__ == "__main__":
    app = QGuiApplication(sys.argv)
    engine = QQmlApplicationEngine()
    engine.addImportPath(sys.path[0])
    engine.loadFromModule("Example", "main")
    if not engine.rootObjects():
        sys.exit(-1)
    exit_code = app.exec()
    del engine
    sys.exit(exit_code)