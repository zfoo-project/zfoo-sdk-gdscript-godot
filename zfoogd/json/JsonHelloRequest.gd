const ByteBuffer = preload("res://zfoogd/ByteBuffer.gd")


var message: String

func protocolId() -> int:
	return 1600

func get_class_name() -> String:
	return "JsonHelloRequest"

func _to_string() -> String:
	const jsonTemplate = "{message:'{}'}"
	var params = [self.message]
	return jsonTemplate.format(params, "{}")

class JsonHelloRequestRegistration:
	func write(buffer: ByteBuffer, packet: Object):
		if (packet == null):
			buffer.writeInt(0)
			return
		buffer.writeInt(-1)
		buffer.writeString(packet.message)
		pass

	func read(buffer: ByteBuffer):
		var length = buffer.readInt()
		if (length == 0):
			return null
		var beforeReadIndex = buffer.getReadOffset()
		var packet = buffer.newInstance(1600)
		var result0 = buffer.readString()
		packet.message = result0
		if (length > 0):
			buffer.setReadOffset(beforeReadIndex + length)
		return packet