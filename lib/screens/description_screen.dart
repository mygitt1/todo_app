import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

class DescriptionScreen extends StatefulWidget {
  final String time;
  final Map data;
  final DocumentReference ref;

  DescriptionScreen(this.data, this.time, this.ref);

  @override
  _DescriptionScreenState createState() => _DescriptionScreenState();
}

class _DescriptionScreenState extends State<DescriptionScreen> {
  final _formKey = GlobalKey<FormState>();

  String title = '';
  String description = '';
  bool isEdit = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: isEdit
          ? FloatingActionButton(
              backgroundColor: Colors.brown.shade900,
              onPressed: updateTask,
              child: Icon(Icons.save),
            )
          : null,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: Text('Description'),
        backgroundColor: Colors.brown.shade900,
        actions: [
          IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                setState(() {
                  isEdit = !isEdit;
                });
              }),
          IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                showMyDialog();
              }),
        ],
      ),
      body: Container(
        color: Colors.brown.shade50,
        padding: EdgeInsets.all(10),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration: InputDecoration.collapsed(
                  hintText: 'Title',
                  hintStyle: GoogleFonts.roboto(
                    color: Colors.black,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: GoogleFonts.roboto(
                  color: Colors.black,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
                onChanged: (val) {
                  title = val;
                },
                validator: (val) {
                  if (val.isEmpty) {
                    return "Can't be empty !";
                  } else {
                    return null;
                  }
                },
                initialValue: widget.data['title'],
                enabled: isEdit,
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 12.0,
                  bottom: 12.0,
                ),
                child: Text(
                  widget.time,
                  style: GoogleFonts.roboto(
                    color: Colors.grey,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.6,
                child: TextFormField(
                  maxLines: 20,
                  decoration: InputDecoration.collapsed(
                    hintText: 'Description',
                    hintStyle: GoogleFonts.roboto(
                      color: Colors.black,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: GoogleFonts.roboto(
                    color: Colors.black,
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                  onChanged: (val) {
                    description = val;
                  },
                  validator: (val) {
                    if (val.isEmpty) {
                      return "Can't be empty !";
                    } else {
                      return null;
                    }
                  },
                  initialValue: widget.data['description'],
                  enabled: isEdit,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void deleteTask() async {
    await widget.ref.delete();
    Navigator.pop(context);
  }

  updateTask() async {
    if (_formKey.currentState.validate()) {
      await widget.ref.update(
        {
          'title': title,
          'description': description,
        },
      ).then((value) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Task Updated'),
          ),
        );
      });

      Navigator.pop(context);
    }
  }

  Future showMyDialog() async {
    return showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Task'),
          content: Text('Are you sure you want to delete this task ?'),
          actions: <Widget>[
            TextButton(
              child: Text('Yes'),
              onPressed: () {
                deleteTask();
                print('Confirmed');
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
