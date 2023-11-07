import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flushbar/flushbar.dart';
import 'home_page.dart';

// import 'package:flutter_launcher_icons/android.dart';
// import 'package:flutter_launcher_icons/constants.dart';
// import 'package:flutter_launcher_icons/custom_exceptions.dart';
// import 'package:flutter_launcher_icons/ios.dart';
// import 'package:flutter_launcher_icons/main.dart';
// import 'package:flutter_launcher_icons/utils.dart';
// import 'package:flutter_launcher_icons/xml_templates.dart';

bool visiblePass = false;

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _StateLoginPage();
}

class _StateLoginPage extends State<LoginPage> {
  TextEditingController userController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController institutionController = TextEditingController();
  FocusNode _userFocusNode = FocusNode();
  GlobalKey<ScaffoldState> scaffoldState;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      FocusScope.of(context).requestFocus(_userFocusNode);
    });
  }

  //FUNCIONES DE COMUNICACION CON EL SERVIDOR
  Future<String> sendlogin(String a, String b) async {
    final response =
        await http.post("http://201.188.252.164/test_mayor/login.php", body: {
      'user': a,
      'password': b,
    });

    print("response:::" + response.body);
    return response.body;
  }

  //VARIABLE PARA DEGRADE DE COLORES EN LETRAS
  final Shader linearGradient = LinearGradient(
    colors: <Color>[Colors.grey[900], Colors.grey[700]],
  ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text('Iniciar Sesión'),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.grey,
      ),
      key: scaffoldState,
      body: Center(
        child: Padding(
            padding: EdgeInsets.all(10),
            child: ListView(
              children: <Widget>[
                Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(10),
                    child: Text(
                      'Ingreso',
                      style: TextStyle(
                          //color: Colors.green,
                          fontWeight: FontWeight.w500,
                          foreground: Paint()..shader = linearGradient,
                          fontSize: 30),
                    )),
                Container(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    controller: userController,
                    focusNode: _userFocusNode,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Usuario',
                        hintText: "Escriba su nombre de usuario"),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: TextField(
                    obscureText: visiblePass ? false : true,
                    controller: passwordController,
                    autofocus: true,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Ingrese contraseña aquí"),
                  ),
                ),
                Container(
                    height: 50,
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: RaisedButton(
                      elevation: 10,
                      child: RichText(
                        text: TextSpan(
                          style: const TextStyle(
                              fontSize: 17.0,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold),
                          children: <TextSpan>[
                            TextSpan(
                                text: !visiblePass
                                    ? "Click aquí para mostrar contraseña"
                                    : "Click aquí para ocultar contraseña"),
                          ],
                        ),
                      ),
                      onPressed: () async {
                        if (visiblePass == true) {
                          setState(() {
                            visiblePass = false;
                          });
                        } else {
                          setState(() {
                            visiblePass = true;
                          });
                        }
                      },
                    )),
                Container(
                  height: 20,
                ),
                Container(
                    height: 50,
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: RaisedButton(
                      textColor: Colors.white,
                      color: Colors.grey,
                      child: RichText(
                        text: TextSpan(
                          style: const TextStyle(
                              fontSize: 24.0,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                          children: <TextSpan>[
                            TextSpan(text: "Ingreso"),
                          ],
                        ),
                      ),
                      onPressed: () async {
                        String response = await sendlogin(
                            userController.text, passwordController.text);
                        if (response == "Sesion iniciada satisfactoriamente") {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) {
                              return MyHomePage();
                            }),
                          );
                        } else {
                          Flushbar(
                            icon: Icon(Icons.clear),
                            duration: Duration(seconds: 4),
                            onTap: (flushbar) {
                              Navigator.pop(context);
                            },
                            message: response,
                            margin: EdgeInsets.all(8),
                            borderRadius: 8,
                            backgroundColor: Colors.blueGrey[500],
                          ).show(context);
                        }
                      },
                    )),
              ],
            )),
      ),
    );
  }
}
