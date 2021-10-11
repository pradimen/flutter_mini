import 'package:flutter/material.dart';
import 'package:petfit/models/pet_data.dart';
import 'package:petfit/src/componenets/album_grid.dart';

class PetAlbum extends StatefulWidget {
  static const routeName = '/pet_album';
  const PetAlbum({Key? key}) : super(key: key);

  @override
  State<PetAlbum> createState() => _PetAlbumState();
}

class _PetAlbumState extends State<PetAlbum> with TickerProviderStateMixin {
  late TabController _tabController;
  late PetData selectedPet;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final routeArgs = ModalRoute.of(context)!.settings.arguments;
    selectedPet = routeArgs as PetData;
    return Scaffold(
      appBar: AppBar(
        title: Text('${selectedPet.name} Album'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              icon: Icon(Icons.photo_library),
              text: 'Photos',
            ),
            Tab(
              icon: Icon(Icons.video_stable),
              text: 'Videos',
            )
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Center(
              child: selectedPet.album.photos.length > 0
                  ? AlbumGrid(
                      albumData: selectedPet.album.photos, photoFlag: true)
                  : Text('No Photos available')),
          Center(
              child: selectedPet.album.photos.length > 0
                  ? AlbumGrid(
                      albumData: selectedPet.album.videos, photoFlag: false)
                  : Text('No Videos available')),
        ],
      ),
    );
  }
}
