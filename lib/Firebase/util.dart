import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svprogresshud/flutter_svprogresshud.dart';
import 'package:petfit/models/product_data.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../models/pet_data.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class FirebaseConnection extends ChangeNotifier {
  static FirebaseConnection _instance = FirebaseConnection._internal();
  factory FirebaseConnection() => _instance;
  FirebaseConnection._internal();
  List<PetData> petList = [];
  List<Products> productList = [];
  bool isHUDShown = false;
  final firebaseStorage = FirebaseStorage.instance;
  bool isAdmin = false;
  bool isLoggedIn = false;
  void showCustomHUD(String message) {
    var finalMessage = message;
    if (message.length == 0) {
      finalMessage = "Loading...";
    }
    SVProgressHUD.setMinimumSize(Size(100, 100));
    SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.dark);
    // SVProgressHUD.dismiss();
    // SVProgressHUD.setBackgroundColor(Colors.black.withOpacity(0.3))
    SVProgressHUD.show(status: finalMessage);
  }

  void hideCustomHUD() {
    SVProgressHUD.dismiss();
  }

  Widget getCustomToast(String message) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          color: Colors.black.withOpacity(0.5)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Icon(
            Icons.login,
            color: Colors.white,
          ),
          SizedBox(
            width: 12,
          ),
          Text(
            message,
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }

  void displayAlert(
      BuildContext context, String title, String msg, String imageName) {
    Alert alertDialog = Alert(
        context: context,
        style: AlertStyle(
            titleStyle: TextStyle(
                fontFamily: 'Raleway',
                fontWeight: FontWeight.bold,
                color: Colors.white),
            descStyle: TextStyle(
                fontFamily: 'RobotoCondensed',
                fontSize: 13,
                color: Colors.white),
            backgroundColor: Colors.white12),
        closeIcon: Icon(
          Icons.close,
          color: Theme.of(context).colorScheme.secondary.withOpacity(0.5),
        ),
        title: title,
        desc: msg,
        image: Image.asset(
          imageName.length > 0 ? imageName : 'petfit_logo.png',
          width: 50,
          height: 50,
        ),
        buttons: [
          DialogButton(
              color: Theme.of(context).colorScheme.secondary.withOpacity(0.5),
              child: Text(
                "OK",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.pop(context);
              })
        ]);
    alertDialog.show();
    // Alert()
  }
}
