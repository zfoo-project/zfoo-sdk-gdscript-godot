# zfoo sdk gdscript for godot

zfoo sdk of gdscript for godot

```
support GdScript in godot version >= 4.1
```

# Start Server

- start server
  in [TcpServerTest](https://github.com/zfoo-project/zfoo/blob/64a9fec7bac3fb10cb798a567f75bb6d7230a121/net/src/test/java/com/zfoo/net/core/tcp/server/TcpServerTest.java)

# Start Client

- await usage

```
var answer: TcpHelloResponse = await tcpClient.asyncAsk(request)
```

- send packet in GdScript

```
tcpClient.send(request)
```