import crcmod
import serial
import paho.mqtt.client as mqtt

host = 'broker.mqttdashboard.com'
port = 8000
ser=serial.Serial('COM1',timeout=1)
crc16 = crcmod.mkCrcFun(0x18005, rev=True, initCrc=0xFFFF, xorOut=0x0000)



def calHexFloor(fl):
    if fl <= 8:
        data = 1<<(fl-1)
        h = hex(data).replace('0x','')
        if len(h)==1:
            h='0'+h
        return h+'000000'
    elif fl <= 16:
        data = 1<<((fl-8)-1)
        h = hex(data).replace('0x','')
        if len(h)==1:
            h='0'+h
        return '00'+h+'0000'
    elif fl <= 24:
        data = 1<<((fl-16)-1)
        h = hex(data).replace('0x','')
        if len(h)==1:
            h='0'+h
        return '0000'+h+'00'
    elif fl <= 32:
        data = 1<<((fl-24)-1)
        h = hex(data).replace('0x','')
        if len(h)==1:
            h='0'+h
        return '000000'+h

def on_connect(self, client, userdata, rc):
    print("MQTT Connected.")
    self.subscribe("kuse/lift/1")

def calMsg(data):
    cmd = data.split(':')
    if cmd[0] == 'DnCal':
        frame = calCrc('01060E0000000000'+calHexFloor(int(cmd[1])))
    elif cmd[0] == 'UpCal':
        frame = calCrc('01060E0100000000'+calHexFloor(int(cmd[1])))
    elif cmd[0] == 'CarCal':
        frame = calCrc('01060E0200000000'+calHexFloor(int(cmd[1])))
    print(frame)
    ser.write(bytearray.fromhex(frame))

def on_message(client, userdata,msg):
    data=msg.payload.decode("utf-8", "strict")
    calMsg(data)

def calCrc(data):
    crc = hex(crc16(bytearray.fromhex(data))).upper()
    if len(crc)==6:
        return '3F'+data+crc[4:6]+crc[2:4]+'FC'
    else:
        return '3F'+data+crc[3:5]+'0'+crc[2:3]+'FC'




#for i in range(32):
#    print((i+1), calHexFloor(i+1))
#calMsg('CarCal:2')
client = mqtt.Client()
client.on_connect = on_connect
client.on_message = on_message
client.connect(host)
client.loop_forever()
#print(calCrc('01060E020000000004000000'))
#print(calCrc('01060E020000000002000000'))
#ser.write(bytearray.fromhex('3F01060E020000000002000000FE64FC'))
#print(hex(crc16(bytearray.fromhex('0103100000'))))
