import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddTask extends StatefulWidget {
  AddTask({this.email});
  final String email;
  @override
  _AddTaskState createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  String temptanggaldeadline;
  DateTime tanggaldeadline = new DateTime.now();

  _pilihtanggaldeadline(BuildContext context) async {
    final deadline = await showDatePicker(
        context: context,
        initialDate: tanggaldeadline,
        firstDate: DateTime(2020),
        lastDate: DateTime(2030));

    if (deadline != null) {
      setState(() {
        tanggaldeadline = deadline;
        temptanggaldeadline =
            "${deadline.day}/${deadline.month}/${deadline.year}";
      });
    }
  }

  String judulPengingat;
  String isiPengingat;

  simpanPengingat() async {
    Firestore.instance.runTransaction((Transaction transcaction) async {
      CollectionReference reference =
          Firestore.instance.collection('pengingat');
      await reference.add({
        "email": widget.email,
        "judul": judulPengingat,
        "tanggal": tanggaldeadline,
        "isi": isiPengingat
      });
    });
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    temptanggaldeadline =
        "${tanggaldeadline.day}/${tanggaldeadline.month}/${tanggaldeadline.year}";
  }

  @override
  Widget build(BuildContext context) {
    return new Material(
      child: SingleChildScrollView(
        child: Column(children: <Widget>[
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
                  Text("Pengingatku..",
                      style: new TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          letterSpacing: 2,
                          fontFamily: "Anggada")),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Text("Tambah Pengingat",
                        style: new TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            letterSpacing: 2)),
                  ),
                  Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 30,
                  )
                ]),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              onChanged: (String str) {
                setState(() {
                  judulPengingat = str;
                });
              },
              decoration: new InputDecoration(
                icon: Icon(Icons.list),
                hintText: "Judul Pengingat",
              ),
              style: new TextStyle(fontSize: 20),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: Icon(Icons.date_range),
                ),
                Expanded(
                    child: Text("Tanggal Deadline : ",
                        style: new TextStyle(fontSize: 20))),
                FlatButton(
                  child: Text(temptanggaldeadline,
                      style: new TextStyle(fontSize: 20)),
                  onPressed: () => _pilihtanggaldeadline(context),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              onChanged: (String str) {
                setState(() {
                  isiPengingat = str;
                });
              },
              decoration: new InputDecoration(
                icon: Icon(Icons.note),
                hintText: "Isi Pengingat",
              ),
              style: new TextStyle(fontSize: 20),
              maxLines: 5,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                IconButton(
                    icon: Icon(Icons.close),
                    iconSize: 30,
                    onPressed: () {
                      setState(() {
                        Navigator.pop(context);
                      });
                    }),
                IconButton(
                    icon: Icon(Icons.check),
                    iconSize: 30,
                    onPressed: () {
                      simpanPengingat();
                    })
              ],
            ),
          )
        ]),
      ),
    );
  }
}
