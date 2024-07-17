extends RefCounted

const ProtocolManager = preload("res://zfoogd/ProtocolManager.gd")
const ByteBuffer = preload("res://zfoogd/ByteBuffer.gd")
const SignalAttachment = preload("res://zfoogd/attachment/SignalAttachment.gd")
const Heartbeat = preload("res://zfoogd/common/Heartbeat.gd")

var client = StreamPeerTCP.new()

var host: String
var port: int

func _init(hostAndPort: String):
	var splits = hostAndPort.split(":")
	host = splits[0]
	port = splits[1].to_int()
	pass

func start() -> void:
	client.big_endian = true
	var startResult = client.connect_to_host(host, port)
	if startResult == OK:
		print(format("start tcp client [{}:{}]", [host, port]))
	else:
		printerr(format("start tcp client error [{}:{}]", [host, port]))
	pass

# It is necessary to call update every once in a while to start the network to send and receive
func update() -> void:
	tickReceive()
	tickSend()
	tickHeartbeat()
	pass


class EncodedPacketInfo:
	extends RefCounted

	signal PacketSignal(packet: Object)

	var packet: RefCounted
	var attachment: SignalAttachment

	func _init(_packet: Object, _attachment: SignalAttachment):
		self.packet = _packet
		self.attachment = _attachment
		pass
	pass

class DecodedPacketInfo:
	extends RefCounted

	var packet: Object
	var attachment: SignalAttachment

	func _init(_packet: Object, _attachment: SignalAttachment):
		self.packet = _packet
		self.attachment = _attachment
		pass
	pass

var noneTime: float = Time.get_unix_time_from_system()
var errorTime: float = Time.get_unix_time_from_system()
var connectingTime: float = Time.get_unix_time_from_system()
var connectedTime: float = Time.get_unix_time_from_system()
var heartbeatTime: float = Time.get_unix_time_from_system()
var uuid: int = 0

var receiveQueue: Array[DecodedPacketInfo] = []
var sendQueue: Array[EncodedPacketInfo] = []

# SignalBridge
var signalAttachmentMap: Dictionary = {}
# PacketBus
var packetBus: Dictionary = {}


func isConnected() -> bool:
	var status = client.get_status()
	return true if status == StreamPeerTCP.STATUS_CONNECTED else false

func registerReceiver(protocol, callable: Callable) -> void:
	var protocolId = protocol.new().protocolId()
	if packetBus.has(protocolId):
		var old = packetBus[protocolId]
		printerr(format("duplicate [protocol:{}] receiver [old:{}] [new:{}]", [protocol, old, callable]))
		return
	packetBus[protocolId] = callable
	pass

func removeReceiver(receiver) -> void:
	for key in packetBus.keys():
		var callable: Callable = packetBus[key]
		if callable.get_object_id() == receiver.get_instance_id():
			packetBus.erase(key)
	pass


func send(packet) -> void:
	if packet == null:
		printerr("null point exception")
	sendQueue.push_back(EncodedPacketInfo.new(packet, null))
	pass


func asyncAsk(packet) -> Object:
	if packet == null:
		printerr("null point exception")
	var currentTime = Time.get_unix_time_from_system() * 1000
	var attachment: SignalAttachment = SignalAttachment.new()
	uuid = uuid + 1
	var signalId = uuid
	attachment.signalId = signalId
	attachment.timestamp = int(currentTime) * 1000
	attachment.client = 12
	attachment.taskExecutorHash = -1
	var encodedPacketInfo: EncodedPacketInfo = EncodedPacketInfo.new(packet, attachment)
	sendQueue.push_back(encodedPacketInfo)
	# add attachment
	signalAttachmentMap[signalId] = encodedPacketInfo
	for key in signalAttachmentMap.keys():
		var oldAttachment = signalAttachmentMap[key].attachment
		if oldAttachment != null && currentTime - oldAttachment.timestamp > 60000:
			signalAttachmentMap.erase(key) # remove timeout packet
	var returnPacket = await encodedPacketInfo.PacketSignal
	# remove attachment
	signalAttachmentMap.erase(signalId)
	return returnPacket


func encodeAndSend(encodedPacketInfo: EncodedPacketInfo) -> void:
	var packet = encodedPacketInfo.packet
	var attachment = encodedPacketInfo.attachment
	var buffer = ByteBuffer.new()
	buffer.writeRawInt(0)
	ProtocolManager.write(buffer, packet)
	if attachment == null:
		buffer.writeBool(false)
	else:
		buffer.writeBool(true)
		ProtocolManager.write(buffer, attachment)
	var writeOffset = buffer.getWriteOffset();
	buffer.setWriteOffset(0)
	buffer.writeRawInt(writeOffset - 4)
	buffer.setWriteOffset(writeOffset)
	var data = buffer.toBytes()
	client.put_data(data)
	print(format("send packet [{}] [{}]", [packet.get_class_name(), packet._to_string()]))
	pass


func decodeAndReceive() -> void:
	var length = client.get_32()
	# tcp粘包拆包
	var data = client.get_data(length)
	if (data[0] == OK):
		var buffer = ByteBuffer.new()
		buffer.writeBytes(PackedByteArray(data[1]))
		var packet = ProtocolManager.read(buffer)
		print(format("receive packet [{}] [{}]", [packet.get_class_name(), packet]))
		var attachment: SignalAttachment = null
		if buffer.isReadable() && buffer.readBool():
			attachment = ProtocolManager.read(buffer)
			var clientAttachment: EncodedPacketInfo = signalAttachmentMap[attachment.signalId]
			clientAttachment.emit_signal("PacketSignal", packet)
		else:
			if !packetBus.has(packet.protocolId()):
				printerr(format("[protocol:{}][protocolId:{}] has no registration, please register for this protocol", [packet.get_class_name(), packet.protocolId()]))
				return
			packetBus[packet.protocolId()].call(packet)
	pass


func tickReceive() -> void:
	var currentTime = Time.get_unix_time_from_system()
	client.poll()
	var status = client.get_status()
	match status:
		StreamPeerTCP.STATUS_NONE:
			if (currentTime - noneTime) > 3:
				# 断线重连
				client.disconnect_from_host()
				client.connect_to_host(host, port)
				printerr(format("status none [{}] host [{}:{}]", ["reconnect", host, port]))
				noneTime = currentTime
		StreamPeerTCP.STATUS_ERROR:
			if (currentTime - errorTime) > 3:
				# 断线重连
				client.disconnect_from_host()
				client.connect_to_host(host, port)
				printerr(format("status error host [{}:{}]", [host, port]))
				errorTime = currentTime
		StreamPeerTCP.STATUS_CONNECTING:
			if (currentTime - connectingTime) > 3:
				print(format("status connecting host [{}:{}]", [host, port]))
				connectingTime = currentTime
		StreamPeerTCP.STATUS_CONNECTED:
			if (currentTime - connectedTime) > 60:
				print(format("status connected host [{}:{}]", [host, port]))
				connectedTime = currentTime
			if client.get_available_bytes() > 4:
				decodeAndReceive()
		_:
			print("tcp client unknown")
	pass


func tickSend() -> void:
	if sendQueue.is_empty():
		return
	var encodedPacketInfo = sendQueue.pop_front()
	client.poll()
	var status = client.get_status()
	match status:
		StreamPeerTCP.STATUS_NONE:
			sendQueue.push_back(encodedPacketInfo)
		StreamPeerTCP.STATUS_ERROR:
			sendQueue.push_back(encodedPacketInfo)
		StreamPeerTCP.STATUS_CONNECTING:
			sendQueue.push_back(encodedPacketInfo)
		StreamPeerTCP.STATUS_CONNECTED:
			encodeAndSend(encodedPacketInfo)
		_:
			print("tcp client unknown")
	pass


# other method
# 格式化字符串
func format(template: String, args: Array) -> String:
	return template.format(args, "{}")

# send heartbeat packet to server per 60 seconds
func tickHeartbeat() -> void:
	var currentTime = Time.get_unix_time_from_system()
	if currentTime - heartbeatTime > 60:
		send(Heartbeat.new())
		heartbeatTime = currentTime
	pass
