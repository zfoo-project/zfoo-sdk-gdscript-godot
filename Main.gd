extends Node2D

const ProtocolManager = preload("res://zfoogd/ProtocolManager.gd")
const TcpClient = preload("res://net/TcpClient.gd")
const TcpClientThreads = preload("res://net/TcpClientThreads.gd")
const WebsocketClient = preload("res://net/WebsocketClient.gd")

const TcpHelloRequest = preload("res://zfoogd/tcp/TcpHelloRequest.gd")
const TcpHelloResponse = preload("res://zfoogd/tcp/TcpHelloResponse.gd")


var tcpClient = TcpClient.new("127.0.0.1:9000")

func _ready():
	ProtocolManager.initProtocol()
	tcpClient.start()
	
	tcpClient.registerReceiver(TcpHelloResponse, Callable(self, "atTcpHelloRequest"))
	$SendPacket.connect("pressed", Callable(self, "sendPacketButton"))
	$AsyncAsk.connect("pressed", Callable(self, "asyncAskButton"))
	pass

func _exit_tree():
	tcpClient.removeReceiver(TcpHelloResponse)
	pass

func atTcpHelloRequest(packet: TcpHelloResponse):
	print("atTcpHelloRequest -> ", packet)
	pass

func sendPacketButton() -> void:
	var request = TcpHelloRequest.new()
	request.message = "send packet pressed"
	tcpClient.send(request)
	pass

func asyncAskButton() -> void:
	var request = TcpHelloRequest.new()
	request.message = "send packet pressed"
	var answer: TcpHelloResponse = await tcpClient.asyncAsk(request)
	print("async TcpHelloRequest -> ", answer)
	pass
	
func _process(_delta):
	tcpClient.update()
	pass
