import 'dart:isolate';

import 'package:async/async.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextButton(
              child: const Text('Send1 await'),
              onPressed: () {
                _sendAndReceive1();
              },
            ),
            TextButton(
              child: const Text('Send2'),
              onPressed: () {
                _sendAndReceive2();
              },
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> _sendAndReceive1() async {
  final p = ReceivePort();
  await Isolate.spawn(_readAndParseJsonService, p.sendPort);
  final events = StreamQueue<dynamic>(p);
  SendPort sendPort = await events.next;
  for (int i = 0; i < 1000; i++) {
    // here is the key
    await _sendMsg(sendPort, i, events);
  }
  sendPort.send(null);
  await events.cancel();
}

Future<void> _sendAndReceive2() async {
  final p = ReceivePort();
  await Isolate.spawn(_readAndParseJsonService, p.sendPort);
  final events = StreamQueue<dynamic>(p);
  SendPort sendPort = await events.next;
  for (int i = 0; i < 1000; i++) {
    // here is the key
    _sendMsg(sendPort, i, events);
  }
  sendPort.send(null);
  await events.cancel();
}

/// Send msg
Future<void> _sendMsg(
    SendPort sendPort, int msg, StreamQueue<dynamic> events) async {
  sendPort.send(msg);
  int startTime = DateTime.now().millisecondsSinceEpoch;
  List<double> message = await events.next;
  print('$msg totalTime: ${DateTime.now().millisecondsSinceEpoch - startTime}');
}

Future<void> _readAndParseJsonService(SendPort p) async {
  final commandPort = ReceivePort();
  p.send(commandPort.sendPort);
  await for (final message in commandPort) {
    if (message is int) {
      // Waited here for 100ms
      await Future.delayed(Duration(milliseconds: 100));
      List<double> list = [
        0.40123534202575684,
        0.4524056315422058,
        0.00867229700088501,
        0.39696791768074036,
        0.4476972818374634,
        0.0051798224449157715,
        0.39849936962127686,
        0.45601627230644226,
        0.00898754596710205,
        0.3887423574924469,
        0.44440126419067383,
        0.004356265068054199,
        0.3898424804210663,
        0.4814954698085785,
        0.007597416639328003,
        0.4343965947628021,
        0.4207075238227844,
        0.01747027039527893,
        0.4418308734893799,
        0.5389193892478943,
        0.01574954390525818,
        0.6368562579154968,
        0.4160435199737549,
        0.04152598977088928,
        0.5248788595199585,
        0.5731270909309387,
        0.049778103828430176,
        0.6799426674842834,
        0.4648876488208771,
        0.03314819931983948,
        0.6151921153068542,
        0.5728471279144287,
        0.031746089458465576,
        0.528715193271637,
        0.44795486330986023,
        0.026020139455795288,
        0.5244162678718567,
        0.5302380323410034,
        0.04090416431427002,
        0.5953572392463684,
        0.41853097081184387,
        0.023987919092178345,
        0.5954821109771729,
        0.5078464150428772,
        0.042212456464767456,
        0.7790898680686951,
        0.4381481111049652,
        0.4381481111049652,
        0.4381481111049652,
        0.4381481111049652,
        0.4381481111049652
      ];
      p.send(list);
    } else if (message == null) {
      break;
    }
  }

  print('Spawned isolate finished.');
  Isolate.exit();
}
