const ByteBuffer = preload("res://zfoogd/ByteBuffer.gd")


var time: int

func protocolId() -> int:
	return 104

func get_class_name() -> String:
	return "Pong"

func _to_string() -> String:
	const jsonTemplate = "{time:{}}"
	var params = [self.time]
	return jsonTemplate.format(params, "{}")

class PongRegistration:
	func write(buffer: ByteBuffer, packet: Object):
		if (packet == null):
			buffer.writeInt(0)
			return
		buffer.writeInt(-1)
		buffer.writeLong(packet.time)
		pass

	func read(buffer: ByteBuffer):
		var length = buffer.readInt()
		if (length == 0):
			return null
		var beforeReadIndex = buffer.getReadOffset()
		var packet = buffer.newInstance(104)
		var result0 = buffer.readLong()
		packet.time = result0
		if (length > 0):
			buffer.setReadOffset(beforeReadIndex + length)
		return packet