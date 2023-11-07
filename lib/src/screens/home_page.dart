import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final _messageStreamController = StreamController<String>();
  List notificationList = [];

  @override
  void initState() {
    super.initState();
    _firebaseMessaging.getToken().then((token) {
      print("Token FCM: $token");
    });

    Future<dynamic> myBackgroundMessageHandler(
        Map<String, dynamic> message) async {
      if (message.containsKey('data')) {
        final dynamic data = message['data'];
        print("pasa por data");
      }

      if (message.containsKey('notification')) {
        final dynamic notification = message['notification'];
        print("pasa por notification");
      }
    }

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("Mensaje en primer plano: " + message["notification"]["body"]);
        _messageStreamController.add(message["notification"]["body"]);
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("La aplicación estaba cerrada: " + message["data"]["body"]);
        _messageStreamController.add(message["data"]["body"]);
      },
      onResume: (Map<String, dynamic> message) async {
        print("La aplicación estaba en segundo plano: " +
            message["data"]["body"]);
        _messageStreamController.add(message["data"]["body"]);
      },
      //onBackgroundMessage: myBackgroundMessageHandler,
    );

    _firebaseMessaging.subscribeToTopic('prueba-conecta-mayor');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('FCM Mensajes'),
          automaticallyImplyLeading: false,
          backgroundColor: Colors.grey,
        ),
        body: Center(
          child: StreamBuilder<String>(
            stream: _messageStreamController.stream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                notificationList.add(snapshot.data);
                print("tamaño notificationList: " +
                    notificationList.length.toString());
                return SingleChildScrollView(
                  child: RichText(
                    text: TextSpan(
                      // Note: Styles for TextSpans must be explicitly defined.
                      // Child text spans will inherit styles from parent
                      style: const TextStyle(
                        fontSize: 24.0,
                        color: Colors.black,
                      ),
                      children: <TextSpan>[
                        TextSpan(text: "Mensaje recibido:"),
                        for (int i = notificationList.length - 1;
                            i >= 0 && notificationList.length - i <= 50;
                            i--)
                          TextSpan(
                              text: "\nn°" +
                                  (i + 1).toString() +
                                  ": ${notificationList[i]}"),
                      ],
                    ),
                  ),
                );
              } else {
                return RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 24.0,
                      color: Colors.black,
                    ),
                    children: <TextSpan>[
                      TextSpan(text: "Esperando mensajes..."),
                    ],
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _messageStreamController.close();
    super.dispose();
  }
}
