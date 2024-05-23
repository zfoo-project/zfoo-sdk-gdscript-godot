# zfoo sdk gdscript for godot

zfoo sdk of gdscript for godot

```
support GdScript in godot version >= 4.1
```

# Start Server

- start server
  in [TcpServerTest](https://github.com/zfoo-project/zfoo/blob/main/net/src/test/java/com/zfoo/net/core/tcp/server/TcpServerTest.java)

# Start Client

- await usage

```
var answer: TcpHelloResponse = await tcpClient.asyncAsk(request)
```

- send packet in GdScript

```
tcpClient.send(request)
```