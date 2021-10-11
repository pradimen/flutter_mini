import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:petfit/Firebase/util.dart';
import 'package:petfit/models/media.dart';
import 'package:petfit/models/product_data.dart';
import 'dart:io';

import 'package:petfit/src/componenets/camera/custom_image_picker.dart';

class AddProducts extends StatefulWidget {
  static const routeName = "/add_products";
  const AddProducts({Key? key}) : super(key: key);

  @override
  _AddProductsState createState() => _AddProductsState();
}

class _AddProductsState extends State<AddProducts> {
  final GlobalKey<FormFieldState> _formkey = GlobalKey<FormFieldState>();
  final _database = FirebaseDatabase.instance.reference();
  final productNameController = TextEditingController();
  final productCostController = TextEditingController();
  final availableStockController = TextEditingController();
  List<String> uploadedImageURLList = [];
  List<String> uploadedVideoURLList = [];
  //List<File> selectedMedia = [];
  List<String> uploadAssetPath = [];

  // Future uploadImageToStorage(BuildContext context) async {
  //   FirebaseConnection().showCustomHUD("Adding products");
  //   uploadAssetPath = [];
  //   selectedMedia.forEach((element) async {
  //     int sizeInBytes = element.lengthSync();
  //     double sizeInMb = sizeInBytes / (1024 * 1024);
  //     if (sizeInMb < 20) {
  //       // _firebaseStorage.ref().child('pets/kitty/').p
  //       Reference ref = FirebaseConnection().firebaseStorage.ref().child(
  //           'products/images/${productNameController.text}${DateTime.now().millisecondsSinceEpoch}');
  //       UploadTask uploadTask = ref.putFile(element);
  //       TaskSnapshot snapshot = await uploadTask.whenComplete(() => null);
  //       snapshot.ref.fullPath;
  //       String imageURL = await snapshot.ref.getDownloadURL();
  //       uploadAssetPath.add(imageURL);
  //       if (element == selectedMedia.last) {
  //         saveToDB();
  //       }
  //     }
  //   });
  // }

  void saveToDB() async {
    try {
      Products uploadProductsData = Products(
          name: productNameController.text,
          cost: productCostController.text,
          quantity: availableStockController.text,
          photos: ProductAlbum(
              photos: uploadedImageURLList, videos: uploadedVideoURLList));
      print("uploadProductsData $uploadProductsData");
      var jsonString = uploadProductsData.toJson();
      print("Firebase JSON $jsonString");
      await _database.child('products/').update(jsonString);
      FirebaseConnection().hideCustomHUD();
      Navigator.pop(context);
    } catch (e) {
      print('error in uploading data $e');
    }
  }

  Widget getTextFormField(
      {required String hint,
      required String label,
      required Function validator,
      required Function onSaveCallBack,
      required int minLine,
      required int maxLine,
      required TextEditingController controller,
      required TextInputType keyboardCustomType}) {
    return TextFormField(
      inputFormatters: [],
      controller: controller,
      validator: (value) {},
      minLines: minLine,
      maxLines: maxLine,
      keyboardType: keyboardCustomType,
      autofocus: false,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 5),
          // hintStyle: TextStyle(fontSize: 12),
          errorStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: Colors.purple),
          hintText: hint,
          labelText: label,
          labelStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: Colors.purple),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.purple)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.purple)),
          fillColor: Colors.white),
    );
  }

  bool validateProductData(BuildContext context) {
    String errMsg = "";
    bool isValid = false;
    if (productNameController.text.isEmpty) {
      errMsg = "Name Cannot be empty";
      isValid = false;
    } else if (productNameController.text.length < 3) {
      errMsg = 'Please enter a valid name';
      isValid = false;
    } else if (productCostController.text.isEmpty) {
      errMsg = 'Please enter the cost';
      isValid = false;
    } else if (availableStockController.text.isEmpty) {
      errMsg = 'Please enter the available stock';
      isValid = false;
    } else if (uploadedImageURLList.length == 0 &&
        uploadedVideoURLList.length == 0) {
      errMsg = "Please choose Images/ Photos";
    } else {
      isValid = true;
    }

    if (errMsg.length > 0) {
      FirebaseConnection().displayAlert(context, "PetFit", errMsg, 'error.png');
    }
    return isValid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Products'),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.all(10),
          alignment: Alignment.topCenter,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
              color: Theme.of(context).colorScheme.secondary),
          child: Column(
            children: [
              Container(
                alignment: Alignment.center,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    'petfit_logo.png',
                    fit: BoxFit.fill,
                    width: 100,
                    height: 100,
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              getTextFormField(
                  hint: "Please enter the Product Name",
                  label: "Product Name",
                  validator: (value) {
                    if (value.length == 0) {
                      return '*Required Field';
                    } else if (value.length < 3) {
                      return 'Name is too short';
                    } else {
                      return null;
                    }
                  },
                  onSaveCallBack: () {},
                  minLine: 1,
                  maxLine: 1,
                  controller: productNameController,
                  keyboardCustomType: TextInputType.text),
              SizedBox(
                height: 15,
              ),
              getTextFormField(
                  hint: "Please enter the cost",
                  label: "Product Cost",
                  validator: (value) {
                    if (value.length == 0) {
                      return '*Required Field';
                    } else {
                      return null;
                    }
                  },
                  onSaveCallBack: () {},
                  minLine: 1,
                  maxLine: 1,
                  controller: productCostController,
                  keyboardCustomType: TextInputType.number),
              SizedBox(
                height: 15,
              ),
              getTextFormField(
                  hint: "Please enter the stock",
                  label: "Product Stock",
                  validator: (value) {
                    if (value.length == 0) {
                      return '*Required Field';
                    } else {
                      return null;
                    }
                  },
                  onSaveCallBack: () {},
                  minLine: 1,
                  maxLine: 1,
                  controller: availableStockController,
                  keyboardCustomType: TextInputType.number),
              SizedBox(
                height: 15,
              ),
              Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.purple),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: (uploadedImageURLList.length > 0 ||
                            uploadedVideoURLList.length > 0)
                        ? Colors.purple
                        : null),
                height: 60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      (uploadedImageURLList.length > 0 ||
                              uploadedVideoURLList.length > 0)
                          ? 'File Uploaded'
                          : 'Add Photo/Video',
                      style: (uploadedImageURLList.length > 0 ||
                              uploadedVideoURLList.length > 0)
                          ? TextStyle(color: Colors.white)
                          : TextStyle(color: Colors.purple),
                    ),
                    Spacer(),
                    IconButton(
                        onPressed: () {
                          uploadedImageURLList = [];
                          uploadedVideoURLList = [];
                          Navigator.of(context)
                              .pushNamed(CustomImagePicker.routeName,
                                  arguments: 'products')
                              .then((media) {
                            FirebaseConnection().hideCustomHUD();
                            setState(() {
                              uploadedImageURLList = (media as Media).images!;
                              uploadedVideoURLList = (media).videos!;
                            });
                          });
                        },
                        icon: Icon(
                          Icons.photo_camera,
                          color: Colors.purple,
                          // size: 50,
                        ))
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              ElevatedButton(
                  onPressed: () {
                    if (validateProductData(context)) {
                      FirebaseConnection().showCustomHUD("Saving Pet data");
                      saveToDB();
                      //  uploadImageToStorage(context);
                    }
                  },
                  child: Text("ADD"))
            ],
          ),
        ),
      ),
    );
  }
}
