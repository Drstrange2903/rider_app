import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rider_app/AllScreens/loginScreen.dart';
import 'package:rider_app/AllScreens/mainscreen.dart';
import 'package:rider_app/Allwidgets/progressDialog.dart';
import 'package:rider_app/main.dart';

// ignore: must_be_immutable
class RegisterationScreen extends StatelessWidget {
  static const String idScreen = "register";
  // ignore: non_constant_identifier_names
  TextEditingController NameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController phoneTextEditingController = TextEditingController();
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
          " register as a rider",
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
              controller: NameTextEditingController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: "Name",
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
              controller: phoneTextEditingController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: "phone no",
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
                    "Create account",
                    style: TextStyle(fontSize: 18.0, fontFamily: "Brand Bold"),
                  ),
                ),
              ),
              shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(24.0),
              ),
              onPressed: () {
                if (NameTextEditingController.text.length < 4) {
                  displayToastMessage(
                      "name must be atleast three character ", context);
                } else if (!emailTextEditingController.text.contains("@")) {
                  displayToastMessage("email is not valid", context);
                } else if (phoneTextEditingController.text.isEmpty) {
                  displayToastMessage("phone is mandotary", context);
                } else if (passwordTextEditingController.text.length < 7) {
                  displayToastMessage("password must be six charcter", context);
                } else {
                  registerNewuser(context);
                }
              },
            )
          ]),
        ),
        FlatButton(
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(
                context, LoginScreen.idScreen, (route) => false);
          },
          child: Text(
            "Already have an account ? Login here.",
          ),
        )
      ]),
    );
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void registerNewuser(BuildContext context) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return ProgressDialog(
            message: "registering, Please wait...",
          );
        });
    final User firebaseUser = (await _firebaseAuth
            .createUserWithEmailAndPassword(
                email: emailTextEditingController.text,
                password: passwordTextEditingController.text)
            .catchError((errMsg) {
      displayToastMessage("error :" + errMsg.toString(), context);
    }))
        .user;
    if (firebaseUser != null) {
      userRef.child(firebaseUser.uid);

      Map userDataMap = {
        "name": NameTextEditingController.text.trim(),
        "email": emailTextEditingController.text.trim(),
        "phone": phoneTextEditingController,
      };

      userRef.child(firebaseUser.uid).set(userDataMap);
      displayToastMessage("your account has been created", context);
      Navigator.pushNamedAndRemoveUntil(
          context, MainScreen.idScreen, (route) => false);
    } else {
      displayToastMessage("new user has not been created", context);
    }
  }
}

displayToastMessage(String message, BuildContext context) {
  Fluttertoast.showToast(msg: message);
}
