import connection
import time
class core():
    def __init__(self,oled=False):
        self.net = connection.Network(oled)
        self.status = "wifi_not_connected"
        self.ir_data = -1
        self.ir_addr = -1
        self.attempt = 0
        self.oled = oled
        if oled:
            import oled
            self.screen = oled.OLED()
        
    def setUp(self):
        import file_system
        self.DB = file_system.FileSet("device_data.json")
        if self.oled:
            self.screen.blank()
            self.screen.centerText(3,"setting up....")
            self.screen.show()
        else:
            print("setup")
        self.status = "wifi_not_connected"
    
    def loop(self):
        try:
            if self.status == "wifi_not_connected":
                time.sleep(1)
                self.attempt = 0
                if self.oled:
                    self.screen.blank()
                    self.screen.centerText(2,"trying to")
                    self.screen.centerText(4,"connect wifi ...")
                    self.screen.show()
                else:
                    print("trying to connect wifi ...")
                self.net.setUp()
                self.status = "wifi_connecting"
            elif self.status == "wifi_connecting":
                if self.attempt > 2: self.status = "ble_mode"
                else:
                    print("["+str(self.attempt)+"]connecting")
                    if self.net.isConnected():
                        print("connected "+str(self.net.getData()))
                        self.status = "wifi_connected"
                    else:
                        time.sleep(5)
                        self.attempt+=1
            elif self.status == "wifi_connected":
                try:
                    import machine
                    
                    from ir_system.ir_tx.nec import NEC
                    self.ir_tx = NEC(machine.Pin(32, machine.Pin.OUT, value = 0))
                    
                    from ir_system.ir_rx.nec import NEC_16
                    def ir_callback(data, addr, ctrl):
                        if data >= 0:
                            self.ir_data = data
                            self.ir_addr = addr
                            print('Data {:02x} Addr {:04x}'.format(data, addr))
                    self.ir_rx = NEC_16(machine.Pin(23, machine.Pin.IN), ir_callback)
                    
                    import dht11
                    self.dht = dht11.Sensor()
                except:
                    raise Exception("error on status:wifi_connected - setting up ir & dht")
                try:      
                    from umqtt.simple import MQTTClient
                    import ubinascii
                    self.mqttc = MQTTClient(ubinascii.hexlify(machine.unique_id()), 'test.mosquitto.org')
                    self.mqttc.connect()
                    self.mqttc.set_callback(self.sub_cb)
                    self.mqttc.subscribe(b"AIOT_113/AppSend")
                    if self.oled:
                        self.screen.blank()
                        self.screen.centerText(4,"NCUE AIOT")
                        self.screen.show()
                    else:
                        print("NCUE AIOT")
                    self.status = "loop"
                except:
                    raise Exception("error on status:wifi_connected - setting mqtt")
            elif self.status == "loop":
                try:
                    self.dht.wait()
                    self.dht.detect()
                    from file_system import ujson
                    self.mqttc.publish(b'AIOT_113/Esp32Send', ujson.dumps({"type":"dht11","uuid":'',"humidity":self.dht.hum,"temperature":self.dht.temp}))
                    self.mqttc.check_msg()
                    if self.oled:
                        self.screen.blank()
                        self.screen.drawSleepPage()
                        self.screen.displayTime()
                        self.screen.text(64, 3, str(self.ir_data))
                        self.screen.text(64, 5, str(self.dht.hum)+" "+str(self.dht.temp))
                        self.screen.show()
                    else:
                        print("IR: "+str(self.ir_data))
                        print("wet & degree: "+str(self.dht.hum)+" "+str(self.dht.temp))
                except (e):
#                     print(e)
                    status = "wifi_not_connected"
#                     self.mqttc.disconnect()
                    raise Exception("error on loop")
            elif self.status == "ble_mode":
                try:
                    time.sleep(2)
                    if self.oled:
                        self.screen.blank()
                        self.screen.centerText(1, "BLE!")
                        self.screen.centerText(3, "Connect")
                        self.screen.centerText(5, "Mode")
                        self.screen.show()
                    else:
                        print("BLE connect mode")
                    import ble
                    bt = ble.BLE()
                    time.sleep(2)
                    if self.oled:
                        self.screen.blank()
                        self.screen.centerText(2, "BLE name")
                        self.screen.centerText(4, bt.name)
                        self.screen.show()
                    else:
                        print("ble name "+bt.name)
                    time.sleep(2)
                    ble_try = 10
                    while ble_try:
                        if self.oled:
                            self.screen.blank()
                            self.screen.centerText(2, bt.name)
                            self.screen.centerText(4, str(11-ble_try)+" / 10")
                            self.screen.show()
                        else:
                            print("ble: {}/10".format(ble_try))
                        time.sleep(2)
                        if (bt.wifi_added):
                            if self.oled:
                                self.screen.blank()
                                self.screen.centerText(4, "wifi added!")
                                self.screen.show()
                            else:
                                print("wifi added")
                            time.sleep(2)
                            global restart_main_task
                            restart_main_task = True
                            self.status = "wifi_not_connected"
                        if (bt.bt_linked):
                            if self.oled:
                                self.screen.blank()
                                self.screen.centerText(4, "bt linked!")
                                self.screen.show()
                            else:
                                print("bt linked!")
                            time.sleep(2)
                        ble_try-=1
                except:
                    raise Exception("error on status:ble")
        except Exception as e:
            self.status = "error"
            print(e)

    def run(self):
        try:
            while True:
                if self.status == "error":
                    raise Exception("Error on run()")
                self.loop()
        except Exception as e:
            print(e)
    
    def sub_cb(self,topic,msg):
        print(str(topic,"UTF-8")+","+str(msg,"UTF-8"))
        self.DB.handle_json(msg)
#         print(DB.type)
#         print(DB.clientID)
#         print(DB.protocol)
#         print(DB.data)
#         if(DB.clientID=="N0UACuslmEQpDjrJCpaakwsWaLB3"):

        if(self.DB.type=="ir_tx"):
                if(self.DB.protocol=="NEC8"):
                    self.ir_tx.transmit(0x0000, int(DB.data))
                if(self.DB.protocol=="NEC16"):
                    self.ir_tx.transmit(0x0000, int(DB.data))
                    #print("ir_tx:"+DB.data)
#         else if(DB.type=="ir_rx"):
#                 global ir_data
#                 if(DB.protocol=="NEC16"):
#                     if ir_data >= 0:
#                     print(ir_data)
        if(self.DB.type=="register_device"):
            if(self.DB.type_data=="switch"):
                self.DB.create(self.DB.uuid,self.DB.type_data)
            elif(self.DB.type_data=="bio_device"):
                self.DB.create(self.DB.uuid,self.DB.type_datadata)
            elif(self.DB.type_data=="slide_device"):
                self.DB.create(self.DB.uuid,self.DB.type_data)
            elif(self.DB.type_data=="wet_degree_sensor"):
                self.DB.create(self.DB.uuid,self.DB.type_data)
            elif(self.DB.type_data=="ir_controller"):
                self.DB.create(self.DB.uuid,self.DB.type_data)
    
m = core(oled = True)

m.run()


