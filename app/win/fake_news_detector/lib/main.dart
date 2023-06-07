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
      _lr_result = decodedResponse["lr"];
      _dt_result = decodedResponse["dt"];

    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(

        child: Row(

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
