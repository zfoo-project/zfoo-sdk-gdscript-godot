const PROTOCOL_ID = 100
const PROTOCOL_CLASS_NAME = "Message"


var module: int
var code: int
var message: String

func _to_string() -> String:
	const jsonTemplate = "{module:{}, code:{}, message:'{}'}"
	var params = [self.module, self.code, self.message]
	return jsonTemplate.format(params, "{}")

static func write(buffer, packet):
	if (packet == null):
		buffer.writeInt(0)
		return
	buffer.writeInt(-1)
	buffer.writeInt(packet.code)
	buffer.writeString(packet.message)
	buffer.writeByte(packet.module)
	pass

static func read(buffer):
	var length = buffer.readInt()
	if (length == 0):
		return null
	var beforeReadIndex = buffer.getReadOffset()
	var packet = buffer.newInstance(PROTOCOL_ID)
	var result0 = buffer.readInt()
	packet.code = result0
	var result1 = buffer.readString()
	packet.message = result1
	var result2 = buffer.readByte()
	packet.module = result2
	if (length > 0):
		buffer.setReadOffset(beforeReadIndex + length)
	return packet
