extends RefCounted

# 此类暂时无法和java的websocket通信

const ProtocolManager = preload("res://zfoogd/ProtocolManager.gd")
const ByteBuffer = preload("res://zfoogd/ByteBuffer.gd")
const SignalAttachment = preload("res://zfoogd/attachment/SignalAttachment.gd")
const Heartbeat = preload("res://zfoogd/common/Heartbeat.gd")

var client = WebSocketPeer.new()

var receiveThread = Thread.new()
var sendThread = Thread.new()

var url: String

func _init(_url: String):
	self.url = _url
	pass

func start() -> void:
	var result = client.connect_to_url(url)
	if result == OK:
		print(format("start tcp client [{}]", [url]))
	else:
		printerr(format("start tcp client error [{}]", [url]))
	receiveThread.start(Callable(self, "tickReceive"))
	sendThread.start(Callable(self, "tickSend"))
	print(format("websocket client receive threadId:[{}] connect:[{}]", [receiveThread.get_id(), result]))
	print(format("websocket client send threadId:[{}]", [sendThread.get_id()]))
	pass


func update() -> void:
	tickHeartbeat()
	var decodedPacketInfo = popReceivePacket()
	if decodedPacketInfo == null:
		return
	var packet = decodedPacketInfo.packet
	var attachment = decodedPacketInfo.attachment
	if attachment == null:
		if !packetBus.has(packet.PROTOCOL_ID):
			printerr(format("[protocol:{}][protocolId:{}] has no registration, please register for this protocol", [packet.PROTOCOL_CLASS_NAME, packet.PROTOCOL_ID]))
			return
		packetBus[packet.PROTOCOL_ID].call(packet)
	else:
		var clientAttachment: EncodedPacketInfo = signalAttachmentMap[attachment.signalId]
		clientAttachment.emit_signal("PacketSignal", packet)
	pass

class EncodedPacketInfo:
	extends RefCounted
	
	signal PacketSignal(packet: RefCounted)
	
	var packet: Object
	var attachment: SignalAttachment
	
	func _init(_packet: Object, _attachment: SignalAttachment):
		self.packet = _packet
		self.attachment = _attachment
	pass

class DecodedPacketInfo:
	extends RefCounted
	
	var packet: Object
	var attachment: SignalAttachment
	
	func _init(_packet: Object, _attachment: SignalAttachment):
		self.packet = _packet
		self.attachment = _attachment
	pass

###################################################################################
var noneTime: float = Time.get_unix_time_from_system()
var errorTime: float = Time.get_unix_time_from_system()
var connectingTime: float = Time.get_unix_time_from_system()
var connectedTime: float = Time.get_unix_time_from_system()
var heartbeatTime: float = Time.get_unix_time_from_system()

var receiveQueue: Array[DecodedPacketInfo] = []
var sendQueue: Array[EncodedPacketInfo] = []

var receiveMutex: Mutex = Mutex.new()
var sendMutex: Mutex = Mutex.new()
var sendSemaphore: Semaphore = Semaphore.new()
# SignalBridge
var signalAttachmentMap: Dictionary = {}
var signalAttachmentMutex: Mutex = Mutex.new()

# PacketBus
var packetBus: Dictionary = {}

###################################################################################

func isConnected() -> bool:
	var status = client.get_ready_state()
	return true if status == WebSocketPeer.STATE_OPEN else false

func registerReceiver(protocol, callable: Callable) -> void:
	if packetBus.has(protocol.PROTOCOL_ID):
		var old = packetBus[protocol.PROTOCOL_ID]
		printerr(format("duplicate [protocol:{}] receiver [old:{}] [new:{}]", [protocol, old, callable]))
		return
	packetBus[protocol.PROTOCOL_ID] = callable
	pass

func removeReceiver(receiver) -> void:
	for key in packetBus.keys():
		var callable: Callable = packetBus[key]
		if callable.get_object_id() == receiver.get_instance_id():
			packetBus.erase(key)
	pass


func popReceivePacket() -> DecodedPacketInfo:
	if receiveQueue.is_empty():
		return null
	receiveMutex.lock()
	var decodedPacketInfo: DecodedPacketInfo = receiveQueue.pop_front()
	receiveMutex.unlock()
	return decodedPacketInfo

func send(packet) -> void:
	if packet == null:
		printerr("null point exception")
	addToSendQueue(EncodedPacketInfo.new(packet, null))
	pass

func addToSendQueue(encodedPacketInfo: EncodedPacketInfo) -> void:
	sendMutex.lock()
	sendQueue.push_back(encodedPacketInfo)
	sendMutex.unlock()
	sendSemaphore.post()
	pass

func addToReceiveQueue(decodedPacketInfo: DecodedPacketInfo) -> void:
	receiveMutex.lock()
	receiveQueue.push_back(decodedPacketInfo)
	receiveMutex.unlock()
	pass

func asyncAsk(packet) -> Object:
	if packet == null:
		printerr("null point exception")
	var currentTime = Time.get_unix_time_from_system() * 1000
	var attachment: SignalAttachment = SignalAttachment.new()
	var signalId = uuidInt()
	attachment.signalId = signalId
	attachment.timestamp = int(currentTime) * 1000
	attachment.client = 12
	attachment.taskExecutorHash = -1
	var encodedPacketInfo: EncodedPacketInfo = EncodedPacketInfo.new(packet, attachment)
	addToSendQueue(encodedPacketInfo)
	# add attachment
	signalAttachmentMutex.lock()
	signalAttachmentMap[signalId] = encodedPacketInfo
	for key in signalAttachmentMap.keys():
		var oldAttachment = signalAttachmentMap[key].attachment
		if oldAttachment != null && currentTime - oldAttachment.timestamp > 60000:
			signalAttachmentMap.erase(key) # remove timeout packet
	signalAttachmentMutex.unlock()
	var returnPacket = await encodedPacketInfo.PacketSignal
	# remove attachment
	signalAttachmentMutex.lock()
	signalAttachmentMap.erase(signalId)
	signalAttachmentMutex.unlock()
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
	var data = buffer.toPackedByteArray()
	client.send(data, client.WRITE_MODE_BINARY)
	print(data)
	print(format("send packet [{}] [size:{}] [{}]", [packet.PROTOCOL_CLASS_NAME, buffer.getWriteOffset(), packet._to_string()]))
	pass
	

func decodeAndReceive() -> void:
	var data = client.get_packet()
	var buffer = ByteBuffer.new()
	buffer.writePackedByteArray(data)
	var packet = ProtocolManager.read(buffer)
	var attachment: SignalAttachment = null
	if buffer.isReadable() && buffer.readBool():
		attachment = ProtocolManager.read(buffer)
	addToReceiveQueue(DecodedPacketInfo.new(packet, attachment))
	print(format("receive packet [{}] [{}]", [packet.PROTOCOL_CLASS_NAME, packet]))
	pass


func tickReceive() -> void:
	while true:
		client.poll()
		
		var currentTime = Time.get_unix_time_from_system()
		var status = client.get_ready_state()
		
		match status:
			WebSocketPeer.STATE_CLOSED:
				# 断线重连
				client.close()
				client.connect_to_url(url)
				if (currentTime - noneTime) > 1:
					printerr(format("status none [{}] host [{}]", ["reconnect", url]))
					noneTime = currentTime
			WebSocketPeer.STATE_CLOSING:
				if (currentTime - errorTime) > 2:
					printerr(format("status error host [{}]", [url]))
					errorTime = currentTime
			WebSocketPeer.STATE_CONNECTING:
				if (currentTime - connectingTime) > 3:
					print(format("status connecting host [{}]", [url]))
					connectingTime = currentTime
			WebSocketPeer.STATE_OPEN:
				if (currentTime - connectedTime) > 60:
					print(format("status connected host [{}]", [url]))
					connectedTime = currentTime	
				var packetCount = client.get_available_packet_count()
				if packetCount > 0:
					print(format("receive packetCount [{}]", [packetCount]))
					for i in range(packetCount):
						decodeAndReceive()
			_:
				print("websocket client unknown")
	pass


func tickSend() -> void:
	while true:
		if sendQueue.is_empty():
			sendSemaphore.wait()
			continue
			
		sendMutex.lock()
		var encodedPacketInfo = sendQueue.pop_front()
		sendMutex.unlock()

		client.poll()
		
		var status = client.get_ready_state()
		match status:
			WebSocketPeer.STATE_CLOSED:
				addToSendQueue(encodedPacketInfo)
			WebSocketPeer.STATE_CLOSING:
				addToSendQueue(encodedPacketInfo)
			WebSocketPeer.STATE_CONNECTING:
				addToSendQueue(encodedPacketInfo)
			WebSocketPeer.STATE_OPEN:
				encodeAndSend(encodedPacketInfo)
			_:
				print("websocket client unknown")
	pass
	
# other method
# 格式化字符串
func format(template: String, args: Array) -> String:
	return template.format(args, "{}")

var uuid: int = 0
var uuidMutex: Mutex = Mutex.new()
func uuidInt() -> int:
	uuidMutex.lock()
	uuid = uuid + 1
	var id = uuid
	uuidMutex.unlock()
	return id

# send heartbeat packet to server per 60 seconds
func tickHeartbeat() -> void:
	var currentTime = Time.get_unix_time_from_system()
	if currentTime - heartbeatTime > 60:
		send(Heartbeat.new())
		heartbeatTime = currentTime
	pass
