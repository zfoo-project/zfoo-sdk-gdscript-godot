const ByteBuffer = preload("res://zfoogd/ByteBuffer.gd")
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

func protocolId() -> int:
	return 2070

func get_class_name() -> String:
	return "WebSocketPacketRequest"

func _to_string() -> String:
	const jsonTemplate = "{a:{}, aa:{}, aaa:{}, aaaa:{}, b:{}, bb:{}, bbb:{}, bbbb:{}, c:{}, cc:{}, ccc:{}, cccc:{}, d:{}, dd:{}, e:{}, ee:{}, eee:{}, eeee:{}, f:{}, ff:{}, fff:{}, ffff:{}, jj:'{}', jjj:{}, kk:{}, kkk:{}, l:{}, ll:{}, lll:{}, llll:{}, lllll:{}, m:{}, mm:{}, mmm:{}, mmmm:{}, s:{}, ss:{}, sss:{}, ssss:{}, sssss:{}}"
	var params = [self.a, self.aa, JSON.stringify(self.aaa), JSON.stringify(self.aaaa), self.b, self.bb, JSON.stringify(self.bbb), JSON.stringify(self.bbbb), self.c, self.cc, JSON.stringify(self.ccc), JSON.stringify(self.cccc), self.d, JSON.stringify(self.dd), self.e, self.ee, JSON.stringify(self.eee), JSON.stringify(self.eeee), self.f, self.ff, JSON.stringify(self.fff), JSON.stringify(self.ffff), self.jj, JSON.stringify(self.jjj), self.kk, JSON.stringify(self.kkk), JSON.stringify(self.l), JSON.stringify(self.ll), JSON.stringify(self.lll), JSON.stringify(self.llll), JSON.stringify(self.lllll), JSON.stringify(self.m), JSON.stringify(self.mm), JSON.stringify(self.mmm), JSON.stringify(self.mmmm), JSON.stringify(self.s), JSON.stringify(self.ss), JSON.stringify(self.sss), JSON.stringify(self.ssss), JSON.stringify(self.sssss)]
	return jsonTemplate.format(params, "{}")

class WebSocketPacketRequestRegistration:
	func write(buffer: ByteBuffer, packet: Object):
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

	func read(buffer: ByteBuffer):
		var length = buffer.readInt()
		if (length == 0):
			return null
		var beforeReadIndex = buffer.getReadOffset()
		var packet = buffer.newInstance(2070)
		var result0 = buffer.readByte()
		packet.a = result0
		var result1 = buffer.readByte()
		packet.aa = result1
		var array2 = buffer.readByteArray()
		packet.aaa = array2
		var array3 = buffer.readByteArray()
		packet.aaaa = array3
		var result4 = buffer.readShort()
		packet.b = result4
		var result5 = buffer.readShort()
		packet.bb = result5
		var array6 = buffer.readShortArray()
		packet.bbb = array6
		var array7 = buffer.readShortArray()
		packet.bbbb = array7
		var result8 = buffer.readInt()
		packet.c = result8
		var result9 = buffer.readInt()
		packet.cc = result9
		var array10 = buffer.readIntArray()
		packet.ccc = array10
		var array11 = buffer.readIntArray()
		packet.cccc = array11
		var result12 = buffer.readLong()
		packet.d = result12
		var array13 = buffer.readLongArray()
		packet.dd = array13
		var result14 = buffer.readFloat()
		packet.e = result14
		var result15 = buffer.readFloat()
		packet.ee = result15
		var array16 = buffer.readFloatArray()
		packet.eee = array16
		var array17 = buffer.readFloatArray()
		packet.eeee = array17
		var result18 = buffer.readDouble()
		packet.f = result18
		var result19 = buffer.readDouble()
		packet.ff = result19
		var array20 = buffer.readDoubleArray()
		packet.fff = array20
		var array21 = buffer.readDoubleArray()
		packet.ffff = array21
		var result22 = buffer.readString()
		packet.jj = result22
		var array23 = buffer.readStringArray()
		packet.jjj = array23
		var result24 = buffer.readPacket(2071)
		packet.kk = result24
		var array25 = buffer.readPacketArray(2071)
		packet.kkk = array25
		var list26 = buffer.readIntArray()
		packet.l = list26
		var result27 = []
		var size29 = buffer.readInt()
		if (size29 > 0):
			for index28 in range(size29):
				var result30 = []
				var size32 = buffer.readInt()
				if (size32 > 0):
					for index31 in range(size32):
						var list33 = buffer.readIntArray()
						result30.append(list33)
				result27.append(result30)
		packet.ll = result27
		var result34 = []
		var size36 = buffer.readInt()
		if (size36 > 0):
			for index35 in range(size36):
				var list37 = buffer.readPacketArray(2071)
				result34.append(list37)
		packet.lll = result34
		var list38 = buffer.readStringArray()
		packet.llll = list38
		var result39 = []
		var size41 = buffer.readInt()
		if (size41 > 0):
			for index40 in range(size41):
				var map42 = buffer.readIntStringMap()
				result39.append(map42)
		packet.lllll = result39
		var map43 = buffer.readIntStringMap()
		packet.m = map43
		var map44 = buffer.readIntPacketMap(2071)
		packet.mm = map44
		var result45 = {}
		var size46 = buffer.readInt()
		if (size46 > 0):
			for index47 in range(size46):
				var result48 = buffer.readPacket(2071)
				var list49 = buffer.readIntArray()
				result45[result48] = list49
		packet.mmm = result45
		var result50 = {}
		var size51 = buffer.readInt()
		if (size51 > 0):
			for index52 in range(size51):
				var result53 = []
				var size55 = buffer.readInt()
				if (size55 > 0):
					for index54 in range(size55):
						var list56 = buffer.readPacketArray(2071)
						result53.append(list56)
				var result57 = []
				var size59 = buffer.readInt()
				if (size59 > 0):
					for index58 in range(size59):
						var result60 = []
						var size62 = buffer.readInt()
						if (size62 > 0):
							for index61 in range(size62):
								var list63 = buffer.readIntArray()
								result60.append(list63)
						result57.append(result60)
				result50[result53] = result57
		packet.mmmm = result50
		var set64 = buffer.readIntArray()
		packet.s = set64
		var result65 = []
		var size67 = buffer.readInt()
		if (size67 > 0):
			for index66 in range(size67):
				var result68 = []
				var size70 = buffer.readInt()
				if (size70 > 0):
					for index69 in range(size70):
						var list71 = buffer.readIntArray()
						result68.append(list71)
				result65.append(result68)
		packet.ss = result65
		var result72 = []
		var size74 = buffer.readInt()
		if (size74 > 0):
			for index73 in range(size74):
				var set75 = buffer.readPacketArray(2071)
				result72.append(set75)
		packet.sss = result72
		var set76 = buffer.readStringArray()
		packet.ssss = set76
		var result77 = []
		var size79 = buffer.readInt()
		if (size79 > 0):
			for index78 in range(size79):
				var map80 = buffer.readIntStringMap()
				result77.append(map80)
		packet.sssss = result77
		if (length > 0):
			buffer.setReadOffset(beforeReadIndex + length)
		return packet