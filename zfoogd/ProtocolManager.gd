const SignalAttachment = preload("res://zfoogd/attachment/SignalAttachment.gd")
const Message = preload("res://zfoogd/common/Message.gd")
const Error = preload("res://zfoogd/common/Error.gd")
const Heartbeat = preload("res://zfoogd/common/Heartbeat.gd")
const Ping = preload("res://zfoogd/common/Ping.gd")
const Pong = preload("res://zfoogd/common/Pong.gd")
const PairIntLong = preload("res://zfoogd/common/PairIntLong.gd")
const PairLong = preload("res://zfoogd/common/PairLong.gd")
const PairString = preload("res://zfoogd/common/PairString.gd")
const PairLS = preload("res://zfoogd/common/PairLS.gd")
const TripleLong = preload("res://zfoogd/common/TripleLong.gd")
const TripleString = preload("res://zfoogd/common/TripleString.gd")
const TripleLSS = preload("res://zfoogd/common/TripleLSS.gd")
const UdpHelloRequest = preload("res://zfoogd/udp/UdpHelloRequest.gd")
const UdpHelloResponse = preload("res://zfoogd/udp/UdpHelloResponse.gd")
const TcpHelloRequest = preload("res://zfoogd/tcp/TcpHelloRequest.gd")
const TcpHelloResponse = preload("res://zfoogd/tcp/TcpHelloResponse.gd")
const WebsocketHelloRequest = preload("res://zfoogd/websocket/WebsocketHelloRequest.gd")
const WebsocketHelloResponse = preload("res://zfoogd/websocket/WebsocketHelloResponse.gd")
const JsonHelloRequest = preload("res://zfoogd/json/JsonHelloRequest.gd")
const JsonHelloResponse = preload("res://zfoogd/json/JsonHelloResponse.gd")
const HttpHelloRequest = preload("res://zfoogd/http/HttpHelloRequest.gd")
const HttpHelloResponse = preload("res://zfoogd/http/HttpHelloResponse.gd")
const WebSocketPacketRequest = preload("res://zfoogd/websocket/WebSocketPacketRequest.gd")
const WebSocketObjectA = preload("res://zfoogd/websocket/WebSocketObjectA.gd")
const WebSocketObjectB = preload("res://zfoogd/websocket/WebSocketObjectB.gd")
const GatewayToProviderRequest = preload("res://zfoogd/gateway/GatewayToProviderRequest.gd")
const GatewayToProviderResponse = preload("res://zfoogd/gateway/GatewayToProviderResponse.gd")

static var protocols: Dictionary = {}
static var protocolClassMap: Dictionary = {}

static func initProtocol():
	protocols[0] = SignalAttachment.SignalAttachmentRegistration.new()
	protocolClassMap[0] = SignalAttachment
	protocols[100] = Message.MessageRegistration.new()
	protocolClassMap[100] = Message
	protocols[101] = Error.ErrorRegistration.new()
	protocolClassMap[101] = Error
	protocols[102] = Heartbeat.HeartbeatRegistration.new()
	protocolClassMap[102] = Heartbeat
	protocols[103] = Ping.PingRegistration.new()
	protocolClassMap[103] = Ping
	protocols[104] = Pong.PongRegistration.new()
	protocolClassMap[104] = Pong
	protocols[110] = PairIntLong.PairIntLongRegistration.new()
	protocolClassMap[110] = PairIntLong
	protocols[111] = PairLong.PairLongRegistration.new()
	protocolClassMap[111] = PairLong
	protocols[112] = PairString.PairStringRegistration.new()
	protocolClassMap[112] = PairString
	protocols[113] = PairLS.PairLSRegistration.new()
	protocolClassMap[113] = PairLS
	protocols[114] = TripleLong.TripleLongRegistration.new()
	protocolClassMap[114] = TripleLong
	protocols[115] = TripleString.TripleStringRegistration.new()
	protocolClassMap[115] = TripleString
	protocols[116] = TripleLSS.TripleLSSRegistration.new()
	protocolClassMap[116] = TripleLSS
	protocols[1200] = UdpHelloRequest.UdpHelloRequestRegistration.new()
	protocolClassMap[1200] = UdpHelloRequest
	protocols[1201] = UdpHelloResponse.UdpHelloResponseRegistration.new()
	protocolClassMap[1201] = UdpHelloResponse
	protocols[1300] = TcpHelloRequest.TcpHelloRequestRegistration.new()
	protocolClassMap[1300] = TcpHelloRequest
	protocols[1301] = TcpHelloResponse.TcpHelloResponseRegistration.new()
	protocolClassMap[1301] = TcpHelloResponse
	protocols[1400] = WebsocketHelloRequest.WebsocketHelloRequestRegistration.new()
	protocolClassMap[1400] = WebsocketHelloRequest
	protocols[1401] = WebsocketHelloResponse.WebsocketHelloResponseRegistration.new()
	protocolClassMap[1401] = WebsocketHelloResponse
	protocols[1600] = JsonHelloRequest.JsonHelloRequestRegistration.new()
	protocolClassMap[1600] = JsonHelloRequest
	protocols[1601] = JsonHelloResponse.JsonHelloResponseRegistration.new()
	protocolClassMap[1601] = JsonHelloResponse
	protocols[1700] = HttpHelloRequest.HttpHelloRequestRegistration.new()
	protocolClassMap[1700] = HttpHelloRequest
	protocols[1701] = HttpHelloResponse.HttpHelloResponseRegistration.new()
	protocolClassMap[1701] = HttpHelloResponse
	protocols[2070] = WebSocketPacketRequest.WebSocketPacketRequestRegistration.new()
	protocolClassMap[2070] = WebSocketPacketRequest
	protocols[2071] = WebSocketObjectA.WebSocketObjectARegistration.new()
	protocolClassMap[2071] = WebSocketObjectA
	protocols[2072] = WebSocketObjectB.WebSocketObjectBRegistration.new()
	protocolClassMap[2072] = WebSocketObjectB
	protocols[5000] = GatewayToProviderRequest.GatewayToProviderRequestRegistration.new()
	protocolClassMap[5000] = GatewayToProviderRequest
	protocols[5001] = GatewayToProviderResponse.GatewayToProviderResponseRegistration.new()
	protocolClassMap[5001] = GatewayToProviderResponse
	pass

static func getProtocol(protocolId: int):
	return protocols[protocolId]

static func getProtocolClass(protocolId: int):
	return protocolClassMap[protocolId]

static func newInstance(protocolId: int):
	var protocol = protocolClassMap[protocolId]
	return protocol.new()

static func write(buffer, packet):
	var protocolId: int = packet.protocolId()
	buffer.writeShort(protocolId)
	var protocol = protocols[protocolId]
	protocol.write(buffer, packet)

static func read(buffer):
	var protocolId = buffer.readShort()
	var protocol = protocols[protocolId]
	var packet = protocol.read(buffer)
	return packet