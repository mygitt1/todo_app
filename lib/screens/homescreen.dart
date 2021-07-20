import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/screens/addtask_screen.dart';
import 'package:todo_app/screens/description_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String uid = '';
  @override
  void initState() {
    getUid();
    super.initState();
  }

  getUid() {
    FirebaseAuth auth = FirebaseAuth.instance;
    User user = auth.currentUser;
    setState(() {
      uid = user.uid;
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('To-do'),
        actions: [
          IconButton(
              icon: Icon(Icons.logout),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
              })
        ],
      ),
      body: Container(
        height: height,
        width: width,
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('Todos')
                .doc(uid)
                .collection('mytodos')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                final document = snapshot.data.docs;
                return ListView.builder(
                    itemCount: document.length,
                    itemBuilder: (context, index) {
                      var time =
                          (document[index]['timestamp'] as Timestamp).toDate();

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DescriptionScreen(
                                title: document[index]['title'],
                                description: document[index]['description'],
                              ),
                            ),
                          );
                        },
                        child: Container(
                          height: 100,
                          padding: EdgeInsets.all(10),
                          margin: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.lightBlueAccent,
                              borderRadius: BorderRadius.circular(10)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(document[index]['title'],
                                      style: GoogleFonts.roboto(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      )),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(DateFormat.yMd().add_jm().format(time)),
                                  // Text(document[index]['description'])
                                ],
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () async {
                                  await FirebaseFirestore.instance
                                      .collection('Todos')
                                      .doc(uid)
                                      .collection('mytodos')
                                      .doc(document[index]['time'])
                                      .delete();

                                  Fluttertoast.showToast(msg: 'Task Deleted');
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    });
              }
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          var route = MaterialPageRoute(builder: (ctx) => AddTask());
          Navigator.push(context, route);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
