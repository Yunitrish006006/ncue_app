import machine
import uasyncio as asyncio
import sys
# from segment7 import Segment7, DEFAULT_PIN
import oled
import sh1106
import network
import dht11
from file_system import FileSet
from umqtt.simple import MQTTClient
from umqtt import aiot

#取得總迴圈 
loop = asyncio.get_event_loop()

#初始化
# pins = [machine.Pin(i, machine.Pin.OUT) for i in DEFAULT_PIN]
i2c = machine.SoftI2C(sda=machine.Pin(21), scl=machine.Pin(22), freq=400000)
sh1106 = sh1106.SH1106_I2C(128, 64, i2c)
 # MQTT
linkor = aiot.AIOT()
#七段顯示器
# s7 = Segment7(pins)
# DHT11
dht = dht11.Sensor()
#OLED顯示器
screen = oled.OLED(sh1106)
# 檔案系統
DB =  FileSet("wifi.json")

#主程式
async def main_task():
    # 檔案系統
    await DB.setUp()
    # 載入畫面
    await screen.blank()
    await screen.centerText(4,"NCUE AIOT")
    await screen.show()
    await asyncio.sleep_ms(100)
    # 初始化資料系統
    await DB.create("302", "0937565253")
    #網路連線
    sta_if = network.WLAN(network.STA_IF)
    sta_if.active(False)
    sta_if.active(True)
    
    ssids = ["302","V2041","studying"]
    passwords = ["0937565253","123456789","gobacktostudy"]
    
    num = 0
    ssid = ssids[num]
    password = passwords[num]
    sta_if.connect(ssid, password)
    await screen.blank()
    await screen.centerText(3,"connecting")
    await screen.centerText(4, "SSID: " + ssid)
    await screen.centerText(5, "pass: " + password)
    await screen.show()
    
    while not sta_if.isconnected():
        pass
    print("connected")
    # mqtt初始化
    await linkor.connect()
    while True:
        await linkor.wait()
        # DHT
        await dht.wait()
        await dht.detect()
        await linkor.routine(await dht.getMQTTMessage())
        # OLED
        await screen.blank()
        await screen.drawSleepPage()
        await screen.displayTime()
        await screen.text(64, 3, "test")
        await screen.text(64, 4, linkor.received)
        await screen.show()
        # segment 7
#         await s7.wait()
#         await s7.cycleDisplay()
#         await asyncio.sleep_ms(1)

#主程式加入總迴圈
task = loop.create_task(main_task())
#關閉相關
try:
    loop.run_forever()
except KeyboardInterrupt:
    print("Ctrl+C pressed stopping.....")
finally:
    task.cancel()
    loop.run_until_complete(task)
    loop.close()