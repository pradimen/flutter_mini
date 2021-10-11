import 'dart:convert';

class PetData {
  final String name;
  final String bread;
  final String dob;
  final String ownerDetails;
  final String location;
  final Album album;
  final String contactInfo;

  PetData(
      {required this.name,
      required this.bread,
      required this.dob,
      required this.ownerDetails,
      required this.location,
      required this.album,
      required this.contactInfo});

  factory PetData.fromJSON(Map<String, dynamic> data) {
    final name = data['name'] as String;
    final bread = data['bread'] as String;
    final dob = data['dob'] as String;
    final location = data['location'] as String;
    final ownerDetails = data['owner_details'] as String;
    final albumData = Album.fromJson(Map<String, dynamic>.from(data['album']));
    final contactInfo = data['contact'] as String;
    // final album = albumData != null
    //     ? albumData.map((userAlbum) => Album.fromJson(userAlbum)).toList()
    //     : <Album>[];
    return PetData(
        name: name,
        bread: bread,
        dob: dob,
        ownerDetails: ownerDetails,
        location: location,
        album: albumData,
        contactInfo: contactInfo);
  }

  Map<String, dynamic> toJson() {
    return {
      '$name': {
        'name': name,
        'bread': bread,
        'dob': dob,
        'location': location,
        'album': album.toJson(),
        'contact': contactInfo,
        'owner_details': ownerDetails,
      }
    };
  }
}

class Album {
  final List<String?> photos;
  final List<String?> videos;
  Album({required this.photos, required this.videos});

  factory Album.fromJson(Map<String, dynamic> data) {
    List<String?> photosList = [];
    List<String?> videosList = [];

    data.forEach((key, value) {
      if (key == "photos") {
        photosList.addAll((value as List).map((e) => e as String?).toList());
      } else {
        videosList.addAll((value as List).map((e) => e as String?).toList());
      }
    });
    return Album(photos: photosList, videos: videosList);
  }

  Map<String, dynamic> toJson() {
    return {
      'photos': photos.length > 0 ? photos : [""],
      'videos': videos.length > 0 ? videos : [""],
    };
  }
}
