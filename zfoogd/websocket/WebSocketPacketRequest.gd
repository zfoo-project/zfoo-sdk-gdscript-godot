const PROTOCOL_ID = 2070
const PROTOCOL_CLASS_NAME = "WebSocketPacketRequest"
const WebSocketObjectA = preload("res://zfoogd/websocket/WebSocketObjectA.gd")
const WebSocketObjectB = preload("res://zfoogd/websocket/WebSocketObjectB.gd")


var a: int
var aa: int
var aaa: Array[int]
var aaaa: Array[int]
var b: int
var bb: int
var bbb: Array[int]
var bbbb: Array[int]
var c: int
var cc: int
var ccc: Array[int]
var cccc: Array[int]
var d: int
var dd: Array[int]
var e: float
var ee: float
var eee: Array[float]
var eeee: Array[float]
var f: float
var ff: float
var fff: Array[float]
var ffff: Array[float]
var jj: String
var jjj: Array[String]
var kk: WebSocketObjectA
var kkk: Array[WebSocketObjectA]
var l: Array[int]
var ll: Array	# Array<Array<Array<number>>>
var lll: Array	# Array<Array<WebSocketObjectA>>
var llll: Array[String]
var lllll: Array	# Array<Map<number, string>>
var m: Dictionary	# Map<number, string>
var mm: Dictionary	# Map<number, WebSocketObjectA>
var mmm: Dictionary	# Map<WebSocketObjectA, Array<number>>
var mmmm: Dictionary	# Map<Array<Array<WebSocketObjectA>>, Array<Array<Array<number>>>>
var s: Array[int]
var ss: Array	# Set<Set<Array<number>>>
var sss: Array	# Set<Set<WebSocketObjectA>>
var ssss: Array[String]
var sssss: Array	# Set<Map<number, string>>

func _to_string() -> String:
	const jsonTemplate = "{a:{}, aa:{}, aaa:{}, aaaa:{}, b:{}, bb:{}, bbb:{}, bbbb:{}, c:{}, cc:{}, ccc:{}, cccc:{}, d:{}, dd:{}, e:{}, ee:{}, eee:{}, eeee:{}, f:{}, ff:{}, fff:{}, ffff:{}, jj:'{}', jjj:{}, kk:{}, kkk:{}, l:{}, ll:{}, lll:{}, llll:{}, lllll:{}, m:{}, mm:{}, mmm:{}, mmmm:{}, s:{}, ss:{}, sss:{}, ssss:{}, sssss:{}}"
	var params = [self.a, self.aa, JSON.stringify(self.aaa), JSON.stringify(self.aaaa), self.b, self.bb, JSON.stringify(self.bbb), JSON.stringify(self.bbbb), self.c, self.cc, JSON.stringify(self.ccc), JSON.stringify(self.cccc), self.d, JSON.stringify(self.dd), self.e, self.ee, JSON.stringify(self.eee), JSON.stringify(self.eeee), self.f, self.ff, JSON.stringify(self.fff), JSON.stringify(self.ffff), self.jj, JSON.stringify(self.jjj), self.kk, JSON.stringify(self.kkk), JSON.stringify(self.l), JSON.stringify(self.ll), JSON.stringify(self.lll), JSON.stringify(self.llll), JSON.stringify(self.lllll), JSON.stringify(self.m), JSON.stringify(self.mm), JSON.stringify(self.mmm), JSON.stringify(self.mmmm), JSON.stringify(self.s), JSON.stringify(self.ss), JSON.stringify(self.sss), JSON.stringify(self.ssss), JSON.stringify(self.sssss)]
	return jsonTemplate.format(params, "{}")

static func write(buffer, packet):
	if (packet == null):
		buffer.writeInt(0)
		return
	buffer.writeInt(-1)
	buffer.writeByte(packet.a)
	buffer.writeByte(packet.aa)
	buffer.writeByteArray(packet.aaa)
	buffer.writeByteArray(packet.aaaa)
	buffer.writeShort(packet.b)
	buffer.writeShort(packet.bb)
	buffer.writeShortArray(packet.bbb)
	buffer.writeShortArray(packet.bbbb)
	buffer.writeInt(packet.c)
	buffer.writeInt(packet.cc)
	buffer.writeIntArray(packet.ccc)
	buffer.writeIntArray(packet.cccc)
	buffer.writeLong(packet.d)
	buffer.writeLongArray(packet.dd)
	buffer.writeFloat(packet.e)
	buffer.writeFloat(packet.ee)
	buffer.writeFloatArray(packet.eee)
	buffer.writeFloatArray(packet.eeee)
	buffer.writeDouble(packet.f)
	buffer.writeDouble(packet.ff)
	buffer.writeDoubleArray(packet.fff)
	buffer.writeDoubleArray(packet.ffff)
	buffer.writeString(packet.jj)
	buffer.writeStringArray(packet.jjj)
	buffer.writePacket(packet.kk, 2071)
	buffer.writePacketArray(packet.kkk, 2071)
	buffer.writeIntArray(packet.l)
	if (packet.ll == null):
		buffer.writeInt(0)
	else:
		buffer.writeInt(packet.ll.size())
		for element0 in packet.ll:
			if (element0 == null):
				buffer.writeInt(0)
			else:
				buffer.writeInt(element0.size())
				for element1 in element0:
					buffer.writeIntArray(element1)
	if (packet.lll == null):
		buffer.writeInt(0)
	else:
		buffer.writeInt(packet.lll.size())
		for element2 in packet.lll:
			buffer.writePacketArray(element2, 2071)
	buffer.writeStringArray(packet.llll)
	if (packet.lllll == null):
		buffer.writeInt(0)
	else:
		buffer.writeInt(packet.lllll.size())
		for element3 in packet.lllll:
			buffer.writeIntStringMap(element3)
	buffer.writeIntStringMap(packet.m)
	buffer.writeIntPacketMap(packet.mm, 2071)
	if (packet.mmm == null):
		buffer.writeInt(0)
	else:
		buffer.writeInt(packet.mmm.size())
		for key4 in packet.mmm:
			var value5 = packet.mmm[key4]
			buffer.writePacket(key4, 2071)
			buffer.writeIntArray(value5)
	if (packet.mmmm == null):
		buffer.writeInt(0)
	else:
		buffer.writeInt(packet.mmmm.size())
		for key6 in packet.mmmm:
			var value7 = packet.mmmm[key6]
			if (key6 == null):
				buffer.writeInt(0)
			else:
				buffer.writeInt(key6.size())
				for element8 in key6:
					buffer.writePacketArray(element8, 2071)
			if (value7 == null):
				buffer.writeInt(0)
			else:
				buffer.writeInt(value7.size())
				for element9 in value7:
					if (element9 == null):
						buffer.writeInt(0)
					else:
						buffer.writeInt(element9.size())
						for element10 in element9:
							buffer.writeIntArray(element10)
	buffer.writeIntArray(packet.s)
	if (packet.ss == null):
		buffer.writeInt(0)
	else:
		buffer.writeInt(packet.ss.size())
		for element11 in packet.ss:
			if (element11 == null):
				buffer.writeInt(0)
			else:
				buffer.writeInt(element11.size())
				for element12 in element11:
					buffer.writeIntArray(element12)
	if (packet.sss == null):
		buffer.writeInt(0)
	else:
		buffer.writeInt(packet.sss.size())
		for element13 in packet.sss:
			buffer.writePacketArray(element13, 2071)
	buffer.writeStringArray(packet.ssss)
	if (packet.sssss == null):
		buffer.writeInt(0)
	else:
		buffer.writeInt(packet.sssss.size())
		for element14 in packet.sssss:
			buffer.writeIntStringMap(element14)
	pass

static func read(buffer):
	var length = buffer.readInt()
	if (length == 0):
		return null
	var beforeReadIndex = buffer.getReadOffset()
	var packet = buffer.newInstance(PROTOCOL_ID)
	var result15 = buffer.readByte()
	packet.a = result15
	var result16 = buffer.readByte()
	packet.aa = result16
	var array17 = buffer.readByteArray()
	packet.aaa = array17
	var array18 = buffer.readByteArray()
	packet.aaaa = array18
	var result19 = buffer.readShort()
	packet.b = result19
	var result20 = buffer.readShort()
	packet.bb = result20
	var array21 = buffer.readShortArray()
	packet.bbb = array21
	var array22 = buffer.readShortArray()
	packet.bbbb = array22
	var result23 = buffer.readInt()
	packet.c = result23
	var result24 = buffer.readInt()
	packet.cc = result24
	var array25 = buffer.readIntArray()
	packet.ccc = array25
	var array26 = buffer.readIntArray()
	packet.cccc = array26
	var result27 = buffer.readLong()
	packet.d = result27
	var array28 = buffer.readLongArray()
	packet.dd = array28
	var result29 = buffer.readFloat()
	packet.e = result29
	var result30 = buffer.readFloat()
	packet.ee = result30
	var array31 = buffer.readFloatArray()
	packet.eee = array31
	var array32 = buffer.readFloatArray()
	packet.eeee = array32
	var result33 = buffer.readDouble()
	packet.f = result33
	var result34 = buffer.readDouble()
	packet.ff = result34
	var array35 = buffer.readDoubleArray()
	packet.fff = array35
	var array36 = buffer.readDoubleArray()
	packet.ffff = array36
	var result37 = buffer.readString()
	packet.jj = result37
	var array38 = buffer.readStringArray()
	packet.jjj = array38
	var result39 = buffer.readPacket(2071)
	packet.kk = result39
	var array40 = buffer.readPacketArray(2071)
	packet.kkk = array40
	var list41 = buffer.readIntArray()
	packet.l = list41
	var result42 = []
	var size44 = buffer.readInt()
	if (size44 > 0):
		for index43 in range(size44):
			var result45 = []
			var size47 = buffer.readInt()
			if (size47 > 0):
				for index46 in range(size47):
					var list48 = buffer.readIntArray()
					result45.append(list48)
			result42.append(result45)
	packet.ll = result42
	var result49 = []
	var size51 = buffer.readInt()
	if (size51 > 0):
		for index50 in range(size51):
			var list52 = buffer.readPacketArray(2071)
			result49.append(list52)
	packet.lll = result49
	var list53 = buffer.readStringArray()
	packet.llll = list53
	var result54 = []
	var size56 = buffer.readInt()
	if (size56 > 0):
		for index55 in range(size56):
			var map57 = buffer.readIntStringMap()
			result54.append(map57)
	packet.lllll = result54
	var map58 = buffer.readIntStringMap()
	packet.m = map58
	var map59 = buffer.readIntPacketMap(2071)
	packet.mm = map59
	var result60 = {}
	var size61 = buffer.readInt()
	if (size61 > 0):
		for index62 in range(size61):
			var result63 = buffer.readPacket(2071)
			var list64 = buffer.readIntArray()
			result60[result63] = list64
	packet.mmm = result60
	var result65 = {}
	var size66 = buffer.readInt()
	if (size66 > 0):
		for index67 in range(size66):
			var result68 = []
			var size70 = buffer.readInt()
			if (size70 > 0):
				for index69 in range(size70):
					var list71 = buffer.readPacketArray(2071)
					result68.append(list71)
			var result72 = []
			var size74 = buffer.readInt()
			if (size74 > 0):
				for index73 in range(size74):
					var result75 = []
					var size77 = buffer.readInt()
					if (size77 > 0):
						for index76 in range(size77):
							var list78 = buffer.readIntArray()
							result75.append(list78)
					result72.append(result75)
			result65[result68] = result72
	packet.mmmm = result65
	var set79 = buffer.readIntArray()
	packet.s = set79
	var result80 = []
	var size82 = buffer.readInt()
	if (size82 > 0):
		for index81 in range(size82):
			var result83 = []
			var size85 = buffer.readInt()
			if (size85 > 0):
				for index84 in range(size85):
					var list86 = buffer.readIntArray()
					result83.append(list86)
			result80.append(result83)
	packet.ss = result80
	var result87 = []
	var size89 = buffer.readInt()
	if (size89 > 0):
		for index88 in range(size89):
			var set90 = buffer.readPacketArray(2071)
			result87.append(set90)
	packet.sss = result87
	var set91 = buffer.readStringArray()
	packet.ssss = set91
	var result92 = []
	var size94 = buffer.readInt()
	if (size94 > 0):
		for index93 in range(size94):
			var map95 = buffer.readIntStringMap()
			result92.append(map95)
	packet.sssss = result92
	if (length > 0):
		buffer.setReadOffset(beforeReadIndex + length)
	return packet
