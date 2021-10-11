import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:petfit/Firebase/firebase_auth_handler.dart';
import 'package:petfit/Firebase/util.dart';
import 'package:petfit/src/componenets/camera/custom_image_picker.dart';
import 'package:petfit/src/drawer/main_navigation_drawer.dart';
import 'package:petfit/src/screens/add_pet_details.dart';
import 'package:petfit/src/screens/add_product_details.dart';
import 'package:petfit/src/screens/full_image_view.dart';
import 'package:petfit/src/screens/home_screen.dart';
import 'package:petfit/src/screens/pet_album_screen.dart';
import 'package:petfit/src/screens/pet_details_screen.dart';
import 'package:petfit/src/screens/video_player.dart';
import 'package:petfit/src/screens/view_products_screen.dart';
// ignore: implementation_imports
import 'package:provider/src/provider.dart';
import './screens/login_screen.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User?>();
    if (firebaseUser != null) {
      FirebaseConnection().isAdmin = context
          .read<AuthenticationProvider>()
          .checkForAdminUser(firebaseUser);
      //  context.read<AuthenticationProvider>().isUserLoggedIn(firebaseUser);
    }
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          // primarySwatch: Colors.amber,
          colorScheme: ColorScheme.fromSwatch(
              accentColor: Colors.lime,
              primarySwatch: Colors.purple,
              primaryColorDark: Colors.black),
          canvasColor: Color.fromRGBO(255, 254, 229, 1),
          fontFamily: 'RobotoCondensed',
          textTheme: ThemeData.light().textTheme.copyWith(
              bodyText1: TextStyle(color: Color.fromRGBO(20, 51, 51, 1)),
              bodyText2: TextStyle(
                  //color: Color.fromRGBO(20, 51, 51, 1),
                  fontFamily: "Raleway",
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
              headline1: TextStyle(
                  fontSize: 24.0,
                  fontFamily: 'RobotoCondensed',
                  fontWeight: FontWeight.bold),
              headline3: TextStyle(
                  fontSize: 20.0,
                  fontFamily: 'RobotoCondensed',
                  fontWeight: FontWeight.bold),
              headline6: TextStyle(
                fontSize: 18.0,
                fontFamily: 'Raleway',
                fontWeight: FontWeight.bold,
              ))),
      home: Scaffold(

          body: firebaseUser != null
              ? HomeScreen()
              : LoginScreen() // This trailing comma makes auto-formatting nicer for build methods.
          ),
      // initialRoute:
      //     firebaseUser != null ? HomeScreen.routeName : LoginScreen.routeName,
      routes: {
        // LoginScreen.routeName: (ctx) => LoginScreen(),
        // HomeScreen.routeName: (ctx) => HomeScreen(),
        PetDetails.routeName: (ctx) => PetDetails(),
        PetAlbum.routeName: (ctx) => PetAlbum(),
        FullScreenImage.routeName: (ctx) => FullScreenImage(),
        AppVideoPlayer.routeName: (ctx) => AppVideoPlayer(),
        AddPet.routeName: (ctx) => AddPet(),
        AddProducts.routeName: (context) => AddProducts(),
        ViewProducts.routeName: (context) => ViewProducts(),
        CustomImagePicker.routeName: (context) => CustomImagePicker(),
      },
    );
  }
}
