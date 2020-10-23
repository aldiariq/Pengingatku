import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';

import 'MyTask.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = new GoogleSignIn();

  _signin() async {
    try {
      GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
      GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final AuthResult authResult =
          await firebaseAuth.signInWithCredential(credential);
      final FirebaseUser user = authResult.user;

      setState(() {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    MyTask(user: user, googleSignIn: googleSignIn)));
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Stack(
        children: <Widget>[
          new Container(
            decoration: new BoxDecoration(
                image: new DecorationImage(
                    image: new AssetImage("images/bgtaskflutter.png"),
                    fit: BoxFit.fill)),
          ),
          SingleChildScrollView(
            child: new Container(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Image.asset("images/tasklogo.png"),
                    new InkWell(
                      child: new Image.asset(
                        "images/signinlogo.png",
                        width: 300,
                      ),
                      onTap: () {
                        _signin();
                      },
                    ),
                  ]),
            ),
          ),
        ],
      ),
    );
  }
}