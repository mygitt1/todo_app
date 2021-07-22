import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/screens/addtask_screen.dart';
import 'package:todo_app/screens/description_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  CollectionReference ref = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser.uid)
      .collection('task');

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown.shade900,
        centerTitle: true,
        title: Text('Task Screen'),
        actions: [
          IconButton(
              icon: Icon(Icons.logout),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
              })
        ],
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 6.0,
        backgroundColor: Colors.brown.shade900,
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (ctx) => AddTask(),
              )).then((value) {
            setState(() {});
          });
        },
        child: Icon(
          Icons.add,
        ),
      ),
      body: Container(
        height: height,
        width: width,
        child: FutureBuilder(
          future: ref.get(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.docs.length == 0) {
                return Center(
                  child: Text(
                    'You Have no Task',
                    style: GoogleFonts.roboto(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }

              return ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    Map data = snapshot.data.docs[index].data();
                    DateTime date = data['createdAt'].toDate();
                    String formatTime = DateFormat.yMd().add_jm().format(date);

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DescriptionScreen(
                              data,
                              formatTime,
                              snapshot.data.docs[index].reference,
                            ),
                          ),
                        ).then((value) {
                          setState(() {});
                        });
                      },
                      child: Container(
                          height: 120,
                          padding: EdgeInsets.all(10),
                          margin: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [
                                    Colors.brown.shade900,
                                    Colors.brown.shade50
                                  ],
                                  begin: Alignment.centerRight,
                                  end: Alignment.centerLeft),
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text('${data['title']}',
                                  style: GoogleFonts.roboto(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  )),
                              Text(formatTime),
                              Text(
                                '${data['description']}',
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.roboto(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          )),
                    );
                  });
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
