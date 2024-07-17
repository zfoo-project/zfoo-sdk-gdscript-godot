const ByteBuffer = preload("res://zfoogd/ByteBuffer.gd")


var key: String
var value: String

func protocolId() -> int:
	return 112

func get_class_name() -> String:
	return "PairString"

func _to_string() -> String:
	const jsonTemplate = "{key:'{}', value:'{}'}"
	var params = [self.key, self.value]
	return jsonTemplate.format(params, "{}")

class PairStringRegistration:
	func write(buffer: ByteBuffer, packet: Object):
		if (packet == null):
			buffer.writeInt(0)
			return
		buffer.writeInt(-1)
		buffer.writeString(packet.key)
		buffer.writeString(packet.value)
		pass

	func read(buffer: ByteBuffer):
		var length = buffer.readInt()
		if (length == 0):
			return null
		var beforeReadIndex = buffer.getReadOffset()
		var packet = buffer.newInstance(112)
		var result0 = buffer.readString()
		packet.key = result0
		var result1 = buffer.readString()
		packet.value = result1
		if (length > 0):
			buffer.setReadOffset(beforeReadIndex + length)
		return packet