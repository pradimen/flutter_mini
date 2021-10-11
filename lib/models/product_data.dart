class Products {
  final String name;
  final String cost;
  final String quantity;
  final ProductAlbum photos;

  Products(
      {required this.name,
      required this.cost,
      required this.quantity,
      required this.photos});

  factory Products.fromJSON(Map<String, dynamic> data) {
    final name = data['name'] as String;
    final cost = data['cost'] as String;
    final quantity = data['quantity'] as String;
    final album =
        ProductAlbum.fromJson(Map<String, dynamic>.from(data['album']));
    ;
    // final location = data['location'] as String;
    // final ownerDetails = data['owner_details'] as String;
    // final albumData = Album.fromJson(Map<String, dynamic>.from(data['album']));
    // final contactInfo = data['contact'] as String;
    // final album = albumData != null
    //     ? albumData.map((userAlbum) => Album.fromJson(userAlbum)).toList()
    //     : <Album>[];
    return Products(name: name, cost: cost, quantity: quantity, photos: album);
  }

  Map<String, dynamic> toJson() {
    return {
      '$name': {
        'name': name,
        'cost': cost,
        'quantity': quantity,
        'album': photos.toJson(),
      }
    };
  }
}

class ProductAlbum {
  final List<String?> photos;
  final List<String?> videos;
  ProductAlbum({required this.photos, required this.videos});

  factory ProductAlbum.fromJson(Map<String, dynamic> data) {
    List<String?> photosList = [];
    List<String?> videosList = [];

    data.forEach((key, value) {
      if (key == "photos") {
        photosList.addAll((value as List).map((e) => e as String?).toList());
      } else {
        videosList.addAll((value as List).map((e) => e as String?).toList());
      }
    });
    return ProductAlbum(photos: photosList, videos: videosList);
  }

  Map<String, dynamic> toJson() {
    return {
      'photos': photos.length > 0 ? photos : [""],
      'videos': videos.length > 0 ? videos : [""],
    };
  }
}
