import time
from machine import Pin
from ir_rx.nec import NEC_16
from ir_tx.nec import NEC
import uasyncio
import oled
from umqtt.simple import MQTTClient
from umqtt.aiot import AIOT
import network


class IR_IN():
    def __init__(self):
        self.client.subscribe("AIOT_113/IR_transmitter")
        self.nec = NEC(Pin(32, Pin.OUT, value = 0))
        self.port = NEC_16(Pin(23, Pin.IN), self.callback)
        self.result = "no data"
        self.toSend = ""

    def callback(self,data, addr, ctrl):
        if data > 0:
            self.result = 'Data {:02x} Addr {:04x}'.format(data, addr)
            print('Data {:02x} Addr {:04x}'.format(data, addr))
            
    def get_msg(self,topic, msg):
        nec.transmit(0x0000, int(str(msg, 'UTF-8')))
        print("IR transmit: "+str(msg, 'UTF-8'))
    
def test():
    temp = IR_IN()
    screen = oled.OLED("test")
    loop = uasyncio.get_event_loop()
    async def test():
        print("ir_system test")
        while True:
            await screen.blank()
            await screen.centerText(3,temp.result)
            await screen.show()
            await uasyncio.sleep_ms(100)
    try:
        task = loop.create_task(test())
        loop.run_forever()
    except KeyboardInterrupt:
        print("Ctrl+C pressed stopping.....")
    finally:
        task.cancel()
        loop.run_until_complete(task)
        loop.close()