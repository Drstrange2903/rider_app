import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:rider_app/AllScreens/mainscreen.dart';
import 'package:rider_app/AllScreens/registerationScreen.dart';
import 'package:rider_app/Allwidgets/progressDialog.dart';
import 'package:rider_app/main.dart';

class LoginScreen extends StatelessWidget {
  static const String idScreen = "Login";
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(children: [
        SizedBox(
          height: 45.0,
        ),
        Image(
          image: AssetImage("images/logo.png"),
          width: 390.0,
          height: 250.0,
          alignment: Alignment.center,
        ),
        SizedBox(
          height: 1.0,
        ),
        Text(
          "login as a rider",
          style: TextStyle(fontSize: 24.0, fontFamily: "Brand Bold"),
          textAlign: TextAlign.center,
        ),
        Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(children: [
            SizedBox(
              height: 1.0,
            ),
            TextFormField(
              controller: emailTextEditingController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: "Email",
                labelStyle: TextStyle(
                  fontSize: 14.0,
                ),
                hintStyle: TextStyle(
                  color: Colors.grey,
                  fontSize: 10.0,
                ),
              ),
              style: TextStyle(fontSize: 14.0),
            ),
            SizedBox(
              height: 1.0,
            ),
            TextFormField(
              controller: passwordTextEditingController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "password",
                labelStyle: TextStyle(
                  fontSize: 14.0,
                ),
                hintStyle: TextStyle(
                  color: Colors.grey,
                  fontSize: 10.0,
                ),
              ),
              style: TextStyle(fontSize: 14.0),
            ),
            SizedBox(
              height: 1.0,
            ),
            RaisedButton(
              color: Colors.yellow,
              textColor: Colors.white,
              child: Container(
                height: 50.0,
                child: Center(
                  child: Text(
                    "Login",
                    style: TextStyle(fontSize: 18.0, fontFamily: "Brand Bold"),
                  ),
                ),
              ),
              shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(24.0),
              ),
              onPressed: () {
                if (!emailTextEditingController.text.contains("@")) {
                  displayToastMessage("email is not valid", context);
                } else if (passwordTextEditingController.text.length < 7) {
                  displayToastMessage("password is mandatory", context);
                }
                loginAndAuthenticateUser(context);
              },
            )
          ]),
        ),
        FlatButton(
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(
                context, RegisterationScreen.idScreen, (route) => false);
          },
          child: Text(
            "DO not have an account ? Register here.",
          ),
        )
      ]),
    );
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void loginAndAuthenticateUser(BuildContext context) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return ProgressDialog(
            message: "Authenticating, Please wait...",
          );
        });
    final User firebaseUser = (await _firebaseAuth
            .signInWithEmailAndPassword(
                email: emailTextEditingController.text,
                password: passwordTextEditingController.text)
            .catchError((errMsg) {
      Navigator.pop(context);
      displayToastMessage("error :" + errMsg.toString(), context);
    }))
        .user;

    if (firebaseUser != null) {
      userRef.child(firebaseUser.uid).once().then((DataSnapshot snap) {
        if (snap.value != null) {
          Navigator.pushNamedAndRemoveUntil(
              context, MainScreen.idScreen, (route) => false);
          displayToastMessage("you are logged in", context);
        } else {
          Navigator.pop(context);
          _firebaseAuth.signOut();
          displayToastMessage("no records found", context);
        }
      });
    } else {
      Navigator.pop(context);
      displayToastMessage("error occured cannot be found", context);
    }
  }
}
