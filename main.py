import kivy
kivy.require('2.3.1') # replace with your current kivy version !

from kivymd.app import MDApp
from kivymd.uix.label import MDLabel


class MainApp(MDApp):
    def build(self):
        return MDLabel(text="Hello, World", halign="center")


MainApp().run()