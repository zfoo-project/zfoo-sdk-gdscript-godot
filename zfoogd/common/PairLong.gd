const ByteBuffer = preload("res://zfoogd/ByteBuffer.gd")


var key: int
var value: int

func protocolId() -> int:
	return 111

func get_class_name() -> String:
	return "PairLong"

func _to_string() -> String:
	const jsonTemplate = "{key:{}, value:{}}"
	var params = [self.key, self.value]
	return jsonTemplate.format(params, "{}")

class PairLongRegistration:
	func write(buffer: ByteBuffer, packet: Object):
		if (packet == null):
			buffer.writeInt(0)
			return
		buffer.writeInt(-1)
		buffer.writeLong(packet.key)
		buffer.writeLong(packet.value)
		pass

	func read(buffer: ByteBuffer):
		var length = buffer.readInt()
		if (length == 0):
			return null
		var beforeReadIndex = buffer.getReadOffset()
		var packet = buffer.newInstance(111)
		var result0 = buffer.readLong()
		packet.key = result0
		var result1 = buffer.readLong()
		packet.value = result1
		if (length > 0):
			buffer.setReadOffset(beforeReadIndex + length)
		return packet