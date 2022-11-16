import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_aliface/flutter_aliface.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    [Permission.camera, Permission.storage].request();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            children: [
              TextButton(
                  onPressed: () async {
                    var aa = await FlutterAliface.getMetaInfos();
                    print(aa);
                  },
                  child: Text("GetMemberInfo")),
              TextButton(
                  onPressed: () async {
                    var aa = await FlutterAliface.verify("å");
                    print(aa);
                  },
                  child: Text("Verify"))
            ],
          ),
        ),
      ),
    );
  }
}
