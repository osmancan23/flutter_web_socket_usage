import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  // ignore: use_key_in_widget_constructors
  const MyApp();

  @override
  Widget build(BuildContext context) {
    const title = 'WebSocket Demo';
    return const MaterialApp(
      title: title,
      home: MyHomePage(
        title: title,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  // ignore: use_key_in_widget_constructors
  const MyHomePage({
    required this.title,
  });

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _controller = TextEditingController();
  final _channel = IOWebSocketChannel.connect(
    Uri.parse("wss://beta.annelersatiyor.com/api/message/auth/ws"),
    headers: {
      "userid": "22",
      "Authorization":
          "Token eyJhbGciOiJIUzUxMiJ9.eyJpc3MiOiJhcyIsInN1YiI6ImEyMjk0NTg1IiwidXNlcklkIjoiMjIiLCJlbWFpbCI6ImFAZ21haWwuY29tIiwidXNlcm5hbWUiOiJhMjI5NDU4NSIsImV4cCI6MTY1MzU2NTQyNH0.BJvpGoB9mBqPSc_6oXJjMq7P1cNCLmyOxeKEHGs9P0IqBwxAd1UxegjiIH7fcDXGPSUoCcaTpxGo8mMJf6vRpQ"
    },
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Form(
              child: TextFormField(
                controller: _controller,
                decoration: const InputDecoration(labelText: 'Send a message'),
              ),
            ),
            const SizedBox(height: 24),
            StreamBuilder(
              stream: _channel.stream,
              builder: (context, snapshot) {
                return Text(snapshot.hasError ? '${snapshot.error}' : '');
              },
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _sendMessage,
        tooltip: 'Send message',
        child: const Icon(Icons.send),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

/*
  Future<void> _getConnection() async {
    final addr = ;

    final response = await Dio().post(addr,
        options: Options(contentType: "application/x-www-form-urlencoded", headers:));
    String _cookie = response.headers["set-cookie"]![0];
    print(_cookie);
  }
*/
  void _sendMessage() {
    print("a");
    if (_controller.text.isNotEmpty) {
      print(_controller.text);

      _channel.sink.add(
        _controller.text,
      );
      _channel.stream.listen(
        (data) {
          print("Socket: data => " + data.toString());
        },
        onError: (error) {
          print("Socket: error => " + error.toString());
        },
        onDone: () {
          print("Socket: done");
        },
      );
    }
  }

  @override
  void dispose() {
    _channel.sink.close();
    _controller.dispose();
    super.dispose();
  }
}
