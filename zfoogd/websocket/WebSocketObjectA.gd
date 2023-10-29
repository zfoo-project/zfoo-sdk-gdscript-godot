const PROTOCOL_ID = 2071
const PROTOCOL_CLASS_NAME = "WebSocketObjectA"
const WebSocketObjectB = preload("res://zfoogd/websocket/WebSocketObjectB.gd")


var a: int
var objectB: WebSocketObjectB

func _to_string() -> String:
	const jsonTemplate = "{a:{}, objectB:{}}"
	var params = [self.a, self.objectB]
	return jsonTemplate.format(params, "{}")

static func write(buffer, packet):
	if (packet == null):
		buffer.writeInt(0)
		return
	buffer.writeInt(-1)
	buffer.writeInt(packet.a)
	buffer.writePacket(packet.objectB, 2072)
	pass

static func read(buffer):
	var length = buffer.readInt()
	if (length == 0):
		return null
	var beforeReadIndex = buffer.getReadOffset()
	var packet = buffer.newInstance(PROTOCOL_ID)
	var result0 = buffer.readInt()
	packet.a = result0
	var result1 = buffer.readPacket(2072)
	packet.objectB = result1
	if (length > 0):
		buffer.setReadOffset(beforeReadIndex + length)
	return packet
