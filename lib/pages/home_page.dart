
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tooot/services/authentication.dart';


class FirestoreCRUDPage extends StatefulWidget {
  FirestoreCRUDPage({Key key, this.auth, this.userId, this.logoutCallback})
      : super(key: key);
        final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;
  @override
  FirestoreCRUDPageState createState() {
    return FirestoreCRUDPageState();
  }
}

class FirestoreCRUDPageState extends State<FirestoreCRUDPage> {
  


  String id;
  final db = Firestore.instance;
  final _formKey = GlobalKey<FormState>();
  String name;
  signOut() async {
    try {
      await widget.auth.signOut();
      widget.logoutCallback();
    } catch (e) {
      print(e);
    }
  }
  TextFormField buildTextFormField() {
    return TextFormField(
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: 'name',
        fillColor: Colors.grey[300],
        filled: true,
      ),
      // ignore: missing_return
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter some text';
        }
      },
      onSaved: (value) => name = value,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
          title: new Text(widget.userId),
          actions: <Widget>[
            new FlatButton(
                child: new Text('Logout',
                    style: new TextStyle(fontSize: 17.0, color: Colors.white)),
                onPressed: signOut)
          ],
        ),
      body: ListView(
        padding: EdgeInsets.all(0),
        children: <Widget>[
          StreamBuilder<QuerySnapshot>(
            stream: db.collection('CRUD').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                    children: snapshot.data.documents
                        .map((doc) => buildItem(doc))
                        .toList());
              } else {
                return SizedBox();
              }
            },
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {

        },
      ),
    );
  }

  void createData() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      DocumentReference ref = await db
          .collection('CRUD')
          .add({'name': '$name ', 'todo': 'uyuy'});
      setState(() => id = ref.documentID);
      print(ref.documentID);
    }
  }

  void readData() async {
    DocumentSnapshot snapshot = await db.collection('CRUD').document(id).get();

    print(snapshot.data['name']);
  }

  void updateData(DocumentSnapshot doc) async {
    await db
        .collection('CRUD')
        .document(doc.documentID)
        .updateData({'todo': 'please ةةة🤫'});
  }

  void deleteData(DocumentSnapshot doc) async {
    await db.collection('CRUD').document(doc.documentID).delete();
    setState(() => id = null);
  }



  Container buildItem(DocumentSnapshot doc) {
    return Container(
        decoration: BoxDecoration(   border: Border(

          top: BorderSide( //                    <--- top side
            color: Colors.blue,
            width: 1.0,
          ),
        ),),
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
           doc.data['name'],
                textDirection: TextDirection.rtl,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: doc.data['gify'] == null
                  ? Text("data")
                  : Image.network(doc.data['gify'],
                      headers: {'accept': 'image/*'}),
            )
          ],
        ),
      ),
    );
  }
}
