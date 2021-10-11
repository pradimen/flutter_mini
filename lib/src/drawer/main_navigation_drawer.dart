import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:petfit/Firebase/util.dart';
import 'package:petfit/src/app.dart';
import 'package:petfit/src/screens/add_pet_details.dart';
import 'package:petfit/src/screens/add_product_details.dart';
import 'package:petfit/src/screens/view_products_screen.dart';
import '/Firebase/firebase_auth_handler.dart';
import 'package:provider/provider.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({Key? key}) : super(key: key);
  Widget buildListTile(String title, IconData icon, VoidCallback? tapHandler) {
    return ListTile(
      // tileColor: Colors.black,
      leading: Icon(icon, size: 26),
      title: Text(
        title,
        style: TextStyle(
            fontFamily: 'RobotoCondensed',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black),
      ),
      onTap: tapHandler,
    );
  }

  Widget getSignOutList(BuildContext context) {
    if (FirebaseConnection().isLoggedIn) {
      return buildListTile("Logout", Icons.logout, () {
        context.read<AuthenticationProvider?>()?.signOut();
        Navigator.pop(context);
      });
    }
    return SizedBox();
  }

  Widget getAddProductsList(BuildContext context) {
    if (FirebaseConnection().isAdmin) {
      return buildListTile("Add Products", Icons.add, () {
        Navigator.popAndPushNamed(context, AddProducts.routeName);
      });
    }
    return SizedBox();
  }

  Widget getAddPetList(BuildContext context) {
    if (FirebaseConnection().isAdmin) {
      return buildListTile('Add Pets', Icons.add_circle, () {
        Navigator.popAndPushNamed(context, AddPet.routeName);
      });
    }
    return SizedBox();
  }

  Widget getViewProductsList(BuildContext context) {
    if (FirebaseConnection().isLoggedIn) {
      return buildListTile('View Products', Icons.view_list_sharp, () {
        Navigator.popAndPushNamed(context, ViewProducts.routeName);
      });
    }
    return SizedBox();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Scaffold(
        appBar: AppBar(
          title: Text("All Products"),
        ),
        body: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            FirebaseConnection().isAdmin
                ? Container(
                    alignment: Alignment.center,
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                        // borderRadius: BorderRadius.circular(10),
                        color: Theme.of(context).colorScheme.secondary),
                    child: Text(
                      "Admin User",
                      style: TextStyle(color: Colors.red),
                    ),
                  )
                : SizedBox(),
            buildListTile("Home", Icons.list, () {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (ctx) => App()));
              //MaterialPageRoute(builder: (ctx) => App());
            }),
            Divider(),
            getAddProductsList(context),
            FirebaseConnection().isAdmin ? Divider() : SizedBox(),
            getAddPetList(context),
            FirebaseConnection().isAdmin ? Divider() : SizedBox(),
            getViewProductsList(context),
            FirebaseConnection().isLoggedIn ? Divider() : SizedBox(),
            getSignOutList(context),
          ],
        ),
      ),
    );
  }
}
