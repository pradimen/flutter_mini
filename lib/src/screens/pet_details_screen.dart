import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:petfit/Firebase/util.dart';
import 'package:petfit/models/pet_data.dart';
import 'package:petfit/src/screens/home_screen.dart';
import 'package:petfit/src/screens/pet_album_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class PetDetails extends StatefulWidget {
  static const routeName = "/pet_details";
  const PetDetails({Key? key}) : super(key: key);
  @override
  State<PetDetails> createState() => _PetDetailsState();
}

class _PetDetailsState extends State<PetDetails> {
  late PetData selectedPet;
  final _database = FirebaseDatabase.instance.reference();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void triggerCaller() async {
    final String phoneUrl = "tel:${selectedPet.contactInfo}";
    if (await canLaunch(phoneUrl)) {
      await launch(phoneUrl);
    } else {
      throw 'Could not launch $phoneUrl';
    }
  }

  void deleteFirebaseEntry() async {
    FirebaseConnection()
        .showCustomHUD("Please wait while we delete your items...");
    await _database.child('pets/${selectedPet.name}').remove();
    FirebaseConnection().hideCustomHUD();
    Navigator.of(context).popUntil(ModalRoute.withName("/"));
  }

  @override
  Widget build(BuildContext context) {
    final routerArgs =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    selectedPet = routerArgs['pet'] as PetData;
    return Scaffold(
      appBar: AppBar(
        title: Text("Pet Details"),
      ),
      body: buildPetData(context),
    );
  }

  Widget buildPetData(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      color: Theme.of(context).colorScheme.secondary,

    child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: (selectedPet.album.photos.first ?? "").length == 0
                ? Image.asset(
                    'petfit_logo.png',
                    fit: BoxFit.cover,
                    width: 100,
                    height: 100,
                  )
                : FadeInImage.assetNetwork(
                    placeholder: 'petfit_logo.png',
                    image: selectedPet.album.photos.first ?? "",
                    fit: BoxFit.cover,
                    width: 150,
                    height: 150,
                    imageErrorBuilder: (context, error, stacktrace) {
                      return Image.asset(
                        'petfit_logo.png',
                        fit: BoxFit.cover,
                        width: 100,
                        height: 100,
                      );
                    },
                  ),
          ),
          SizedBox(
            height: 10,
          ),
          buildPetContainer(
            leadingText: "Pet Name:",
            petText: "${selectedPet.name}",
          ),
          SizedBox(
            height: 10,
          ),
          buildPetContainer(
            leadingText: "Pet DOB:",
            petText: "${selectedPet.dob}",
          ),
          SizedBox(
            height: 10,
          ),
          buildPetContainer(
            leadingText: "Pet Location:",
            petText: "${selectedPet.location}",
          ),
          SizedBox(
            height: 10,
          ),
          buildPetContainer(
            leadingText: "Pet Breed:",
            petText: "${selectedPet.bread}",
          ),
          Container(
            padding: EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Owner details"),
                SizedBox(
                  height: 10,
                ),
                Container(
                  alignment: Alignment.topLeft,
                  //  padding: EdgeInsets.all(10),
                  height: 100,
                  width: MediaQuery.of(context).size.width - 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white.withOpacity(0.7),
                  ),
                  child: Text("${selectedPet.ownerDetails}", maxLines: 5),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Album'),
                InkWell(
                  onTap: () {
                    Navigator.of(context)
                        .pushNamed(PetAlbum.routeName, arguments: selectedPet);
                  },
                  child: Icon(
                    Icons.photo_sharp,
                    size: 40,
                  ),
                )
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                    width: 100,
                    child: ElevatedButton(
                        onPressed: () {
                          triggerCaller();
                        },
                        child: Text('CALL'))),
                SizedBox(
                  width: 20,
                ),
                !FirebaseConnection().isAdmin
                    ? SizedBox()
                    : SizedBox(
                        width: 100,
                        child: ElevatedButton(
                            onPressed: () {
                              deleteFirebaseEntry();
                            },
                            child: Text('DELETE'))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container buildPetContainer(
      {required String leadingText, required String petText}) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Flexible(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 100,
              child: Text(
                leadingText,
                style: TextStyle(fontSize: 16),
              ),
            ),
            SizedBox(
              width: 30,
            ),
            Flexible(
              child: Text(
                petText,
                style: TextStyle(fontSize: 16),
                maxLines: 3,
                overflow: TextOverflow.clip,
              ),
            )
          ],
        ),
      ),
    );
  }
}
