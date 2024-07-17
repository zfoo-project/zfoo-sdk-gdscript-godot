const ByteBuffer = preload("res://zfoogd/ByteBuffer.gd")


var flag: bool

func protocolId() -> int:
	return 2072

func get_class_name() -> String:
	return "WebSocketObjectB"

func _to_string() -> String:
	const jsonTemplate = "{flag:{}}"
	var params = [self.flag]
	return jsonTemplate.format(params, "{}")

class WebSocketObjectBRegistration:
	func write(buffer: ByteBuffer, packet: Object):
		if (packet == null):
			buffer.writeInt(0)
			return
		buffer.writeInt(-1)
		buffer.writeBool(packet.flag)
		pass

	func read(buffer: ByteBuffer):
		var length = buffer.readInt()
		if (length == 0):
			return null
		var beforeReadIndex = buffer.getReadOffset()
		var packet = buffer.newInstance(2072)
		var result0 = buffer.readBool() 
		packet.flag = result0
		if (length > 0):
			buffer.setReadOffset(beforeReadIndex + length)
		return packet