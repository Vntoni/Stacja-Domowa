from PyQt6.QtWidgets import QApplication, QMainWindow, QWidget, QVBoxLayout, QPushButton, QLabel, QGraphicsBlurEffect, QStackedWidget
from PyQt6.QtCore import Qt
import sys

class MainWindow(QMainWindow):
    def __init__(self):
        super().__init__()
        self.setWindowTitle("Główne okno z efektem rozmycia")
        self.setGeometry(0, 0, 1280, 1024)

        # Tworzymy główny kontener
        central_widget = QWidget()
        self.setCentralWidget(central_widget)
        layout = QVBoxLayout()
        central_widget.setLayout(layout)

        # Tworzymy główne tło (będzie rozmywane)
        self.background_label = QLabel("🌟 To jest główny widok w tle 🌟", self)
        self.background_label.setAlignment(Qt.AlignmentFlag.AlignCenter)
        self.background_label.setStyleSheet("font-size: 24px; color: white; background-color: #34495e; padding: 40px; border-radius: 10px;")
        layout.addWidget(self.background_label)

        # Dodajemy efekt rozmycia do tła
        # self.blur_effect = QGraphicsBlurEffect()
        # self.blur_effect.setBlurRadius(10)  # Intensywność rozmycia
        # self.background_label.setGraphicsEffect(self.blur_effect)

        # Tworzymy obszar aktywnych sekcji
        self.stacked_widget = QStackedWidget()
        layout.addWidget(self.stacked_widget)

        # # Dodajemy różne sekcje
        # self.section1 = SectionWidget("Sekcja 1", self)
        # self.section2 = SectionWidget("Sekcja 2", self)
        # self.stacked_widget.addWidget(self.section1)
        # self.stacked_widget.addWidget(self.section2)
        #
        # # Tworzymy menu do zmiany sekcji
        # self.button1 = QPushButton("Przejdź do Sekcji 1")
        # self.button1.clicked.connect(lambda: self.open_section(self.section1))
        # layout.addWidget(self.button1)
        #
        # self.button2 = QPushButton("Przejdź do Sekcji 2")
        # self.button2.clicked.connect(lambda: self.open_section(self.section2))
        # layout.addWidget(self.button2)

    def open_section(self, section):
        """ Powiększa aktywną sekcję i pozostawia rozmyte tło """
        self.stacked_widget.setCurrentWidget(section)


if __name__ == "__main__":
    app = QApplication(sys.argv)
    window = MainWindow()
    window.show()
    sys.exit(app.exec())