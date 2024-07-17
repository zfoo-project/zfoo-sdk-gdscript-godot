const ByteBuffer = preload("res://zfoogd/ByteBuffer.gd")
const WebSocketObjectB = preload("res://zfoogd/websocket/WebSocketObjectB.gd")


var a: int
var objectB: WebSocketObjectB

func protocolId() -> int:
	return 2071

func get_class_name() -> String:
	return "WebSocketObjectA"

func _to_string() -> String:
	const jsonTemplate = "{a:{}, objectB:{}}"
	var params = [self.a, self.objectB]
	return jsonTemplate.format(params, "{}")

class WebSocketObjectARegistration:
	func write(buffer: ByteBuffer, packet: Object):
		if (packet == null):
			buffer.writeInt(0)
			return
		buffer.writeInt(-1)
		buffer.writeInt(packet.a)
		buffer.writePacket(packet.objectB, 2072)
		pass

	func read(buffer: ByteBuffer):
		var length = buffer.readInt()
		if (length == 0):
			return null
		var beforeReadIndex = buffer.getReadOffset()
		var packet = buffer.newInstance(2071)
		var result0 = buffer.readInt()
		packet.a = result0
		var result1 = buffer.readPacket(2072)
		packet.objectB = result1
		if (length > 0):
			buffer.setReadOffset(beforeReadIndex + length)
		return packet