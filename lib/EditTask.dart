import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditTask extends StatefulWidget {
  EditTask({this.index, this.judul, this.tanggal, this.isi});
  final index;
  final String judul;
  final DateTime tanggal;
  final String isi;
  @override
  _EditTaskState createState() => _EditTaskState();
}

class _EditTaskState extends State<EditTask> {
  TextEditingController controllerJudul;
  TextEditingController controllerIsi;

  String temptanggaldeadline;
  DateTime tanggaldeadline;

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

  simpanperubahanPengingat() {
    Firestore.instance.runTransaction((Transaction transaction) async {
      DocumentSnapshot snapshot = 
      await transaction.get(widget.index);
      await transaction.update(snapshot.reference, {
        "judul" : judulPengingat,
        "tanggal" : tanggaldeadline,
        "isi" : isiPengingat
      });
    });
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    tanggaldeadline = widget.tanggal;
    temptanggaldeadline =
        "${tanggaldeadline.day}/${tanggaldeadline.month}/${tanggaldeadline.year}";
    judulPengingat = widget.judul;
    isiPengingat = widget.isi;
    controllerJudul = new TextEditingController(text: widget.judul);
    controllerIsi = new TextEditingController(text: widget.isi);
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
              controller: controllerJudul,
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
              controller: controllerIsi,
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
                      simpanperubahanPengingat();
                    })
              ],
            ),
          )
        ]),
      ),
    );
  }
}
