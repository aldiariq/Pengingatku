import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'AddTask.dart';
import 'EditTask.dart';
import 'main.dart';

class MyTask extends StatefulWidget {
  MyTask({this.user, this.googleSignIn});
  final FirebaseUser user;
  final GoogleSignIn googleSignIn;

  @override
  _MyTaskState createState() => _MyTaskState();
}

class _MyTaskState extends State<MyTask> {
  _signOut() async {
    AlertDialog alertDialog = new AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15))),
        content: Container(
          height: 250,
          child: Column(
            children: <Widget>[
              ClipOval(
                child: new Image.network(widget.user.photoUrl),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  "Yakin ingin keluar?",
                  style: new TextStyle(fontSize: 20),
                ),
              ),
              Divider(),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Column(
                          children: <Widget>[
                            Icon(Icons.close),
                            Padding(padding: const EdgeInsets.all(5)),
                            Text(
                              "Tidak",
                            )
                          ],
                        )),
                    InkWell(
                        onTap: () {
                          widget.googleSignIn.signOut();
                          Navigator.pop(context);
                          setState(() {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MyHomePage()));
                          });
                        },
                        child: Column(
                          children: <Widget>[
                            Icon(Icons.check),
                            Padding(padding: const EdgeInsets.all(5)),
                            Text(
                              "Ya",
                            )
                          ],
                        )),
                  ])
            ],
          ),
        ));

    showDialog(context: context, child: alertDialog);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: new FloatingActionButton(
          onPressed: () {
            setState(() {
              Navigator.of(context).push(new MaterialPageRoute(
                  builder: (BuildContext context) => new AddTask(
                        email: widget.user.email,
                      )));
            });
          },
          child: Icon(Icons.add),
          backgroundColor: Colors.lightBlueAccent),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 170.0),
            child: StreamBuilder(
              stream: Firestore.instance
                  .collection("pengingat")
                  .where("email", isEqualTo: widget.user.email)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return new Container(
                      child: Center(child: CircularProgressIndicator()));
                }
                return new TaskList(
                  document: snapshot.data.documents,
                );
              },
            ),
          ),
          Container(
            height: 170,
            width: double.infinity,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomLeft: const Radius.circular(10.0),
                    bottomRight: const Radius.circular(10.0)),
                image: DecorationImage(
                  image: new AssetImage("images/bgtaskflutter.png"),
                  fit: BoxFit.cover,
                ),
                boxShadow: [
                  new BoxShadow(color: Colors.black, blurRadius: 20)
                ]),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text("Pengingatku..",
                      style: new TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          letterSpacing: 2,
                          fontFamily: "Anggada")),
                ),
                Row(children: <Widget>[
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: new NetworkImage(widget.user.photoUrl),
                          fit: BoxFit.cover),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: new Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            new Text("Selamat Datang",
                                style: new TextStyle(
                                    fontSize: 20.0, color: Colors.white)),
                            new Text(widget.user.displayName,
                                style: new TextStyle(
                                    fontSize: 20.0, color: Colors.white)),
                          ]),
                    ),
                  ),
                  new IconButton(
                    icon: Icon(Icons.exit_to_app),
                    color: Colors.white,
                    iconSize: 30,
                    onPressed: () {
                      _signOut();
                    },
                  ),
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TaskList extends StatelessWidget {
  TaskList({this.document});
  final List<DocumentSnapshot> document;
  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        String judul = document[index].data['judul'];
        String isi = document[index].data['isi'];
        DateTime tanggal = document[index].data["tanggal"].toDate();
        String temptanggal = "${tanggal.day}/${tanggal.month}/${tanggal.year}";

        return Dismissible(
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Container(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Padding(
                                  padding: const EdgeInsets.only(right: 5),
                                  child: Text(judul,
                                      style: new TextStyle(
                                          fontSize: 20,
                                          letterSpacing: 1,
                                          fontWeight: FontWeight.bold))),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(right: 5),
                                child: Icon(Icons.date_range),
                              ),
                              Text(
                                temptanggal,
                                style: new TextStyle(fontSize: 17.5),
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(right: 5),
                                child: Icon(Icons.note),
                              ),
                              Flexible(
                                child: Text(
                                  isi,
                                  style: new TextStyle(fontSize: 17.5),
                                  softWrap: true,
                                ),
                              )
                            ],
                          ),
                        ]),
                  ),
                ),
                new IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    Navigator.of(context).push(new MaterialPageRoute(
                        builder: (context) => new EditTask(
                              index: document[index].reference,
                              judul: judul,
                              tanggal: document[index].data["tanggal"].toDate(),
                              isi: isi,
                            )));
                  },
                ),
              ],
            ),
          ),
          key: new Key(document[index].documentID),
          onDismissed: (directon) {
            Firestore.instance.runTransaction((transaction) async {
              DocumentSnapshot snapshot =
                  await transaction.get(document[index].reference);
              await transaction.delete(snapshot.reference);
            });

            Scaffold.of(context).showSnackBar(
                new SnackBar(content: new Text("Pengingat Berhasil Dihapus!")));
          },
        );
      },
      itemCount: document.length,
    );
  }
}

class MaterialRoute {}
