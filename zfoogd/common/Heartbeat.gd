const ByteBuffer = preload("res://zfoogd/ByteBuffer.gd")




func protocolId() -> int:
	return 102

func get_class_name() -> String:
	return "Heartbeat"

func _to_string() -> String:
	const jsonTemplate = "{}"
	var params = []
	return jsonTemplate.format(params, "{}")

class HeartbeatRegistration:
	func write(buffer: ByteBuffer, packet: Object):
		if (packet == null):
			buffer.writeInt(0)
			return
		buffer.writeInt(-1)
		pass

	func read(buffer: ByteBuffer):
		var length = buffer.readInt()
		if (length == 0):
			return null
		var beforeReadIndex = buffer.getReadOffset()
		var packet = buffer.newInstance(102)
		
		if (length > 0):
			buffer.setReadOffset(beforeReadIndex + length)
		return packet