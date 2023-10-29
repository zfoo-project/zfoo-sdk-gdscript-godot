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
const JProtobufHelloRequest = preload("res://zfoogd/jprotobuf/JProtobufHelloRequest.gd")
const JProtobufHelloResponse = preload("res://zfoogd/jprotobuf/JProtobufHelloResponse.gd")
const JsonHelloRequest = preload("res://zfoogd/json/JsonHelloRequest.gd")
const JsonHelloResponse = preload("res://zfoogd/json/JsonHelloResponse.gd")
const HttpHelloRequest = preload("res://zfoogd/http/HttpHelloRequest.gd")
const HttpHelloResponse = preload("res://zfoogd/http/HttpHelloResponse.gd")
const WebSocketPacketRequest = preload("res://zfoogd/websocket/WebSocketPacketRequest.gd")
const WebSocketObjectA = preload("res://zfoogd/websocket/WebSocketObjectA.gd")
const WebSocketObjectB = preload("res://zfoogd/websocket/WebSocketObjectB.gd")
const GatewayToProviderRequest = preload("res://zfoogd/gateway/GatewayToProviderRequest.gd")
const GatewayToProviderResponse = preload("res://zfoogd/gateway/GatewayToProviderResponse.gd")

const protocols: Dictionary = {
	0: SignalAttachment,
	100: Message,
	101: Error,
	102: Heartbeat,
	103: Ping,
	104: Pong,
	110: PairIntLong,
	111: PairLong,
	112: PairString,
	113: PairLS,
	114: TripleLong,
	115: TripleString,
	116: TripleLSS,
	1200: UdpHelloRequest,
	1201: UdpHelloResponse,
	1300: TcpHelloRequest,
	1301: TcpHelloResponse,
	1400: WebsocketHelloRequest,
	1401: WebsocketHelloResponse,
	1500: JProtobufHelloRequest,
	1501: JProtobufHelloResponse,
	1600: JsonHelloRequest,
	1601: JsonHelloResponse,
	1700: HttpHelloRequest,
	1701: HttpHelloResponse,
	2070: WebSocketPacketRequest,
	2071: WebSocketObjectA,
	2072: WebSocketObjectB,
	5000: GatewayToProviderRequest,
	5001: GatewayToProviderResponse
}

static func getProtocol(protocolId: int):
	return protocols[protocolId]

static func newInstance(protocolId: int):
	var protocol = protocols[protocolId]
	return protocol.new()

static func write(buffer, packet):
	var protocolId: int = packet.PROTOCOL_ID
	buffer.writeShort(protocolId)
	var protocol = protocols[protocolId]
	protocol.write(buffer, packet)

static func read(buffer):
	var protocolId = buffer.readShort()
	var protocol = protocols[protocolId]
	var packet = protocol.read(buffer)
	return packet
