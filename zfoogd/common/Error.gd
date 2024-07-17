const ByteBuffer = preload("res://zfoogd/ByteBuffer.gd")


var code: int
var message: String

func protocolId() -> int:
	return 101

func get_class_name() -> String:
	return "Error"

func _to_string() -> String:
	const jsonTemplate = "{code:{}, message:'{}'}"
	var params = [self.code, self.message]
	return jsonTemplate.format(params, "{}")

class ErrorRegistration:
	func write(buffer: ByteBuffer, packet: Object):
		if (packet == null):
			buffer.writeInt(0)
			return
		buffer.writeInt(-1)
		buffer.writeInt(packet.code)
		buffer.writeString(packet.message)
		pass

	func read(buffer: ByteBuffer):
		var length = buffer.readInt()
		if (length == 0):
			return null
		var beforeReadIndex = buffer.getReadOffset()
		var packet = buffer.newInstance(101)
		var result0 = buffer.readInt()
		packet.code = result0
		var result1 = buffer.readString()
		packet.message = result1
		if (length > 0):
			buffer.setReadOffset(beforeReadIndex + length)
		return packet