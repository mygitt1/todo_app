import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthForm extends StatefulWidget {
  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _userName = '';
  var _email = '';
  var _password = '';
  bool isLogin = false;
  startAuthentication() async {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      _formKey.currentState.save();
      submitForm(_email, _password, _userName);
    }
  }

  submitForm(String email, String password, String username) async {
    final auth = FirebaseAuth.instance;
    try {
      if (!isLogin) {
        UserCredential credential = await auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        UserCredential credential = await auth.createUserWithEmailAndPassword(
            email: email, password: password);
        String uid = credential.user.uid;
        await FirebaseFirestore.instance.collection('users').doc(uid).set({
          'username': username,
          'email': email,
        });
      }
    } catch (e) {
      print(e.toString());
      return e;
    }
  }

  @override
  Widget build(BuildContext context) {
    // double height = MediaQuery.of(context).size.height;
    // double width = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            isLogin
                ? Text(
                    'Create a new account',
                    style: GoogleFonts.roboto(
                        fontSize: 35, fontWeight: FontWeight.bold),
                  )
                : Text(
                    'Welcome Back !',
                    style: GoogleFonts.roboto(
                        fontSize: 35, fontWeight: FontWeight.bold),
                  ),
            SizedBox(
              height: 10,
            ),
            if (isLogin)
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                key: ValueKey('username'),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Enter Username',
                  focusColor: Theme.of(context).accentColor,
                  labelStyle:
                      GoogleFonts.roboto(color: Theme.of(context).accentColor),
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Incorrect Username';
                  }
                  return null;
                },
                onSaved: (value) {
                  _userName = value;
                },
              ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              key: ValueKey('email'),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(),
                ),
                filled: true,
                fillColor: Colors.white,
                hintText: 'Enter Email',
                labelStyle: GoogleFonts.roboto(),
              ),
              validator: (value) {
                if (value.isEmpty || !value.contains('@')) {
                  return 'Incorrect email';
                }
                return null;
              },
              onSaved: (value) {
                _email = value;
              },
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              obscureText: true,
              keyboardType: TextInputType.emailAddress,
              key: ValueKey('password'),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(),
                ),
                filled: true,
                fillColor: Colors.white,
                hintText: 'Enter Password',
                labelStyle: GoogleFonts.roboto(),
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Incorrect Password';
                }
                return null;
              },
              onSaved: (value) {
                _password = value;
              },
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 46,
              width: 200,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    elevation: 6.0,
                    primary: Colors.brown.shade900,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20))),
                onPressed: () => startAuthentication(),
                child: isLogin
                    ? Text(
                        'SignUp',
                        style: GoogleFonts.roboto(fontSize: 20),
                      )
                    : Text(
                        'Login',
                        style: GoogleFonts.roboto(fontSize: 20),
                      ),
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  isLogin = !isLogin;
                });
              },
              child: isLogin
                  ? Text(
                      'Already a User? Log In',
                      style: GoogleFonts.roboto(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                    )
                  : Text(
                      'Not a Member? Sign In',
                      style: GoogleFonts.roboto(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
