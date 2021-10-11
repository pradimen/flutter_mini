// import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:petfit/Firebase/firebase_auth_handler.dart';
import 'package:petfit/Firebase/util.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_svprogresshud/flutter_svprogresshud.dart';

typedef void OnLoginCallback(bool? resultStatus, UserCredential userCredential);

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var userNameTextController = TextEditingController();
  var passwordTextController = TextEditingController();
  FToast ftoast = FToast();

  VoidCallback? loginCallBack(AuthResultStatus authResultStatus) {
    if (authResultStatus == AuthResultStatus.successful) {
    } else {
      FirebaseConnection().hideCustomHUD();
      // showCustomToast('Error in login');
      final errormsg =
          AuthExceptionHandler.generateExceptionMessage(authResultStatus);
      FirebaseConnection()
          .displayAlert(context, "Pet Fit", errormsg, "error.png");
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  void firebaselogin(BuildContext context) async {
    await context.read<AuthenticationProvider>().signIn(
        email: userNameTextController.text,
        password: passwordTextController.text,
        onLogin: (authCredintials) {
          loginCallBack(authCredintials);
        });
  }

  void showCustomToast(String message) {
    Widget toast = FirebaseConnection().getCustomToast(message);
    ftoast.showToast(child: toast, toastDuration: Duration(seconds: 3));
  }

  Widget loginWidget(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 10,
      height: MediaQuery.of(context).size.height,
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.all(10),
      alignment: Alignment.topCenter,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
          color: Theme.of(context).colorScheme.secondary),
      child: ClipRRect(
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              SizedBox(height: 70,),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  'petfit_logo.png',
                  fit: BoxFit.fill,
                  width: 100,
                  height: 100,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: userNameTextController,
                decoration: InputDecoration(
                  hintText: "New user",
                  fillColor: Colors.white,
                  filled: true,
                  border: InputBorder.none,
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.white)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.white)),
                ),
                style: TextStyle(backgroundColor: Colors.white),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: passwordTextController,
                decoration: InputDecoration(
                  hintText: "Password",
                  fillColor: Colors.white,
                  filled: true,
                  border: InputBorder.none,
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.white)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.white)),
                ),
                style: TextStyle(backgroundColor: Colors.white),
                obscureText: true,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                  onPressed: () {
                    if (userNameTextController.text.length > 0 &&
                        passwordTextController.text.length > 0) {
                      FirebaseConnection().showCustomHUD("Loading...");

                      // final progress = ProgressHUD.of(context);
                      // progress?.showWithText('Loading...');
                      FocusScope.of(context).requestFocus(new FocusNode());
                      firebaselogin(context);
                    }
                  },
                  child: Text(
                    "Login",
                    style: TextStyle(fontSize: 18),
                  )),
              SizedBox(height: 20),
              // ElevatedButton(
              //     onPressed: () {},
              //     child: Text(
              //       "Login As Admin",
              //       style: TextStyle(fontSize: 18),
              //     ))
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ftoast.init(context);
    return loginWidget(context);
    // return ProgressHUD(
    //     borderColor: Colors.orange,
    //     backgroundColor: Colors.pink.shade300,
    //     child: Builder(
    //       builder: (context) => loginWidget(context),
    //     ));
  }
}
