import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:petfit/Firebase/util.dart';
import 'package:petfit/models/pet_data.dart';
import 'package:petfit/src/componenets/carousel_view.dart';
import 'package:petfit/src/componenets/pet_list_view.dart';
import 'package:petfit/src/drawer/main_navigation_drawer.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _database = FirebaseDatabase.instance.reference();
  List<String?> imagList = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _activateListener();
  }

  void _activateListener() {
    _database.child('pets').onValue.listen((event) {
      final pets = event.snapshot.value as List;
      print('pet firebase \n $pets');
      List<PetData> dummyList = pets
          .map(
              (petJson) => PetData.fromJSON(Map<String, dynamic>.from(petJson)))
          .toList();
      List<String?> dummyPetImageList = [];
      dummyList.forEach((element) {
        dummyPetImageList.addAll(element.album.photos);
        dummyPetImageList.addAll(element.album.videos);
      });
      // setState(() {
      //   FirebaseConnection().petList = (pets.map((pet) {
      //     PetData.fromJSON(Map<String, dynamic>.from(pet));
      //   }).toList() as List<PetData>);
      // });

      setState(() {
        FirebaseConnection().petList = dummyList;
        this.imagList.addAll(dummyPetImageList);
        // print('pet list $petList');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final PreferredSizeWidget appBar = AppBar(
      title: Text('Petfit'),
    );
    FirebaseConnection().showCustomHUD("Loading...");
    return Scaffold(
      drawer: MainDrawer(),
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('Pet Fit'),
      ),
      body: buildHomeStream(context, mediaQuery, appBar),
    );

  }

  StreamBuilder<Event> buildHomeStream(BuildContext context,
      MediaQueryData mediaQuery, PreferredSizeWidget appBar) {
    return StreamBuilder(
      stream: _database.child('pets').onValue.asBroadcastStream(),
      builder: (ctx, AsyncSnapshot<Event> snap) {
        if (snap.hasData) {
          if (snap.data!.snapshot.value != null) {
            this.imagList = [];
            final pets = Map<String, dynamic>.from(snap.data!.snapshot.value);
            print('pet firebase \n $pets');
            //FirebaseConnection().petList = pets.values.map((pet) => PetData.fromJSON(data));
            FirebaseConnection().petList = [];
            FirebaseConnection().petList = pets.values
                .map((petJson) =>
                    PetData.fromJSON(Map<String, dynamic>.from(petJson)))
                .toList();
            List<String?> dummyPetImageList = [];
            FirebaseConnection().petList.forEach((element) {
              dummyPetImageList.addAll(element.album.photos);
              //]\\]
              //]]]  dummyPetImageList.addAll(element.album.videos);
            });
            this.imagList.addAll(dummyPetImageList);
          }
          // print('pet list $petList');

          return buildHomeScreen(mediaQuery, appBar);
        } else {
          return Center(
            child: Text("No Pet data found"),
          );
        }
      },
    );
  }

  SingleChildScrollView buildHomeScreen(
      MediaQueryData mediaQuery, PreferredSizeWidget appBar) {
    FirebaseConnection().hideCustomHUD();
    return SingleChildScrollView(
      child: Container(
          height: (mediaQuery.size.height -
              appBar.preferredSize.height -
              mediaQuery.padding.top -
              mediaQuery.padding.bottom),
          color: Theme.of(context).colorScheme.secondary,
          child: FirebaseConnection().petList.length > 0
              ? Column(
                  children: [
                    Container(
                        height: (mediaQuery.size.height -
                                appBar.preferredSize.height -
                                mediaQuery.padding.top) *
                            0.3,
                        child: Container(
                            child: CarouselLoading(
                          imagList,
                          (mediaQuery.size.height -
                                  appBar.preferredSize.height -
                                  mediaQuery.padding.top) *
                              0.3,
                        ))),
                    Container(
                      color: Theme.of(context).colorScheme.secondary,
                      height: (mediaQuery.size.height -
                              appBar.preferredSize.height -
                              mediaQuery.padding.top) *
                          0.65,
                      child: FirebaseConnection().petList.length > 0
                          ? Container(
                              // padding: EdgeInsets.all(10),
                              // height: (mediaQuery.size.height -
                              //         appBar.preferredSize.height -
                              //         mediaQuery.padding.top) *
                              //     0.7,
                              child: PetsListView(FirebaseConnection().petList),
                            )
                          : Container(
                              width: mediaQuery.size.width,
                            ),
                    )
                  ],
                )
              : Center(
                  child: CircularProgressIndicator(),
                )),
    );
  }
}
