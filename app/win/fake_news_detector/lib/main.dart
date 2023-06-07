import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFc5c3ea), background: Color(0xFF191c1e),
          onPrimaryContainer: Color(0xFFc5c3ea), onSurface: Color(0xFFc5c3ea),
          surfaceTint: Color(0xFFc5c3ea), inversePrimary: Color(0xFF2e2d4d),
          primaryContainer: Color(0xFF2e2d4d)

        ),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Fake News Detector'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

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
  String _input = "";
  String _lr_result = "FAKE";
  String _dt_result = "REAL";
  var client = http.Client();
  TextEditingController _newsFieldController = new TextEditingController();



  Future<void> _fetchResults() async {

    _input = _newsFieldController.text;
    var url = Uri.http('localhost:8080', 'check', {"q": _input});
    print(url);
    var response = await client.get(url);
    var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
    print(decodedResponse);
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _lr_result = decodedResponse["lr"];
      _dt_result = decodedResponse["dt"];

    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Row(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.spaceAround,

          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: width * 0.2,
                  height: height * 0.2,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: Color(0xFFbce9ff),
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12) ),
                  ),
                  child: Text(
                    _dt_result,
                    textScaleFactor: 4,
                    style: TextStyle(
                      color:
                          _dt_result == "REAL" ?
                          Color(0xff00b780) :
                          Color(0xffff5e6c)
                    ),
                  ),
                ),
                Container(
                  width: width * 0.2,
                  height: height * 0.075,
                  color: Color(0xFF004d63),
                  alignment: Alignment.center,
                  child: Text(
                      "ACCORDING TO DECISION TREE",
                    style: const TextStyle(
                      color: Color(0xFFbce9ff),
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: width * 0.2,
                  height: height * 0.2,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: Color(0xFFcfe6f2),
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12) ),
                  ),
                  child: Text(
                    _lr_result,
                    textScaleFactor: 4,
                    style: TextStyle(
                        color:
                        _lr_result == "REAL" ?
                        Color(0xff00b780) :
                        Color(0xffff5e6c)
                    ),
                  ),
                ),
                Container(
                  width: width * 0.2,
                  height: height * 0.075,
                  color: Color(0xFF354a53),
                  alignment: Alignment.center,
                  child: Text(
                    "ACCORDING TO LOGISTRIC REG.",
                    style: const TextStyle(
                      color: Color(0xFFcfe6f2),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: width * 0.9,
              height: height * 0.1,
              child: TextField(
                controller: _newsFieldController,
                style: const TextStyle(
                ),
              ),
            ),
            FloatingActionButton(
              onPressed: _fetchResults,
              tooltip: 'Increment',
              child: const Icon(Icons.send),
            ),
          ],
        ),
      ),
    );
  }
}
