import 'dart:io';
import 'package:intl/intl.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:petfit/Firebase/util.dart';
import 'package:petfit/models/media.dart';
import 'package:petfit/models/pet_data.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:petfit/src/componenets/camera/custom_image_picker.dart';

class AddPet extends StatefulWidget {
  static const routeName = "/add_pet";
  const AddPet({Key? key}) : super(key: key);

  @override
  _AddPetState createState() => _AddPetState();
}

class _AddPetState extends State<AddPet> {
  final _database = FirebaseDatabase.instance.reference();
  final petnameController = TextEditingController();
  final petDOBController = TextEditingController();
  final petLocationController = TextEditingController();
  final petBreadController = TextEditingController();
  final ownerDetailsController = TextEditingController();
  final mobileNumberController = TextEditingController();
  String petName = "";
  String petDOB = "";
  String petLocation = "";
  String petBread = "";
  String ownerDetails = "";
  String mobileNumber = "";
  List<String> uploadedImageURLList = [];
  List<String> uploadedVideoURLList = [];

  // Future uploadImageToStorage(BuildContext context) async {
  //   FirebaseConnection().showCustomHUD("Adding pets");
  //   selectedMedia.forEach((element) async {
  //     int sizeInBytes = element.lengthSync();
  //     double sizeInMb = sizeInBytes / (1024 * 1024);
  //     if (sizeInMb < 10) {
  //       // _firebaseStorage.ref().child('pets/kitty/').p
  //       Reference ref = FirebaseConnection().firebaseStorage.ref().child(
  //           'pets/images/${petnameController.text}${DateTime.now().millisecondsSinceEpoch}');
  //       UploadTask uploadTask = ref.putFile(element);
  //       TaskSnapshot snapshot = await uploadTask;
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
      PetData uploadPetData = PetData(
          name: petName,
          bread: petBread,
          dob: petDOB,
          ownerDetails: ownerDetails,
          location: petLocation,
          album:
              Album(photos: uploadedImageURLList, videos: uploadedVideoURLList),
          contactInfo: mobileNumberController.text);
      var jsonString = uploadPetData.toJson();
      print("Firebase JSON $jsonString");
      await _database.child('pets/').update(jsonString);
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
      required TextInputType customTextInputType}) {
    return TextFormField(
      controller: controller,
      validator: (val) {},
      minLines: minLine,
      maxLines: maxLine,
      keyboardType: customTextInputType,
      autofocus: false,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 5),
          // hintStyle: TextStyle(fontSize: 12),
          hintText: hint,
          labelText: label,
          labelStyle: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 15, color: Colors.purple),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.purple)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.purple)),
          fillColor: Colors.white),
    );
  }

  String? _validateName(String value) {
    if (value.length == 0) {
      return '*Required Field';
    } else if (value.length < 3) {
      return 'Name is too short';
    } else {
      return null;
    }
  }

  String? _validateLocation(String value) {
    if (value.length == 0) {
      return '*Required Field';
    } else if (value.length < 3) {
      return 'Location is too short';
    } else {
      return null;
    }
  }

  bool validatePetData(BuildContext context) {
    petName = petnameController.text;
    // petDOB = petDOBController.text;
    petLocation = petLocationController.text;
    petBread = petBreadController.text;
    ownerDetails = ownerDetailsController.text;
    String errMsg = "";
    bool isValid = false;
    if (petName.length == 0) {
      isValid = false;
      errMsg = "Name cannot be empty";
    } else if (petName.length < 3) {
      errMsg = "Please enter a valid name";
      isValid = false;
    } else if (petDOB.length == 0) {
      errMsg = "DOB cannot be empty";
      isValid = false;
    } else if (petDOB.length < 3) {
      errMsg = "Please enter a valid DOB";
      isValid = false;
    } else if (petLocation.length == 0) {
      errMsg = "Location cannot be empty";
      isValid = false;
    } else if (petLocation.length < 3) {
      errMsg = "Please enter a valid location";
      isValid = false;
    } else if (petBread.length == 0) {
      errMsg = "Pet breed cannot be empty";
      isValid = false;
    } else if (petBread.length < 3) {
      errMsg = "Please enter a valid pet breed";
      isValid = false;
    } else if (ownerDetails.length == 0) {
      errMsg = "Owner details cannot be empty";
      isValid = false;
    } else if (ownerDetails.length < 3) {
      errMsg = "Please provide valid owner details";
      isValid = false;
    } else if (mobileNumberController.text.length == 0) {
      errMsg = "Mobile numnber cannot be empty";
      isValid = false;
    } else if (uploadedImageURLList.length == 0 &&
        uploadedVideoURLList.length == 0) {
      errMsg = "Please choose Images/ Photos";
    } else {
      isValid = true;
    }
    if (errMsg.length > 0) {
      FirebaseConnection().displayAlert(context, "PetFit", errMsg, "error.png");
    }

    return isValid;
  }

  Widget addPetWidget() {
    return Container(
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
      child: ListView(
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
              minLine: 1,
              maxLine: 1,
              hint: 'Name of your pet',
              label: 'Pet name',
              validator: (value) {
                this.petName = "";
                if (value.length == 0) {
                  return '*Required Field';
                } else if (value.length < 3) {
                  return 'Name is too short';
                } else {
                  this.petName = value;
                  return null;
                }
              },
              onSaveCallBack: () {},
              controller: petnameController,
              customTextInputType: TextInputType.name),
          SizedBox(
            height: 15,
          ),
          Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.purple),
                borderRadius: BorderRadius.all(Radius.circular(10))),
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  petDOB.length > 0 ? "$petDOB" : "Choose Pet's DOB",
                  style: TextStyle(color: Colors.purple),
                ),
                Spacer(),
                IconButton(
                    onPressed: () async {
                      DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101));
                      if (pickedDate != null) {
                        setState(() {
                          petDOB = DateFormat('MMM dd yyyy').format(pickedDate);
                        });
                      }
                    },
                    icon: Icon(
                      Icons.date_range_outlined,
                      color: Colors.purple,
                      // size: 50,
                    ))
              ],
            ),
          ),
          SizedBox(
            height: 15,
          ),
          getTextFormField(
              minLine: 1,
              maxLine: 1,
              hint: 'Enter Pet Location',
              label: 'Pet Location',
              validator: () {},
              onSaveCallBack: () {},
              controller: petLocationController,
              customTextInputType: TextInputType.name),
          SizedBox(
            height: 15,
          ),
          getTextFormField(
              minLine: 1,
              maxLine: 1,
              hint: 'Enter Pet Breed',
              label: 'Pet breed',
              validator: () {},
              onSaveCallBack: () {},
              controller: petBreadController,
              customTextInputType: TextInputType.name),
          SizedBox(
            height: 15,
          ),
          getTextFormField(
              minLine: 1,
              maxLine: 5,
              hint: 'Enter Owner Address',
              label: 'Owner Details',
              validator: () {},
              onSaveCallBack: () {},
              controller: ownerDetailsController,
              customTextInputType: TextInputType.name),
          SizedBox(
            height: 15,
          ),
          getTextFormField(
              minLine: 1,
              maxLine: 5,
              hint: 'Enter Owner Mobile number',
              label: 'Contact details',
              validator: () {},
              onSaveCallBack: () {},
              controller: mobileNumberController,
              customTextInputType: TextInputType.number),
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
                              arguments: 'pets')
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
                if (validatePetData(context)) {
                  FirebaseConnection().showCustomHUD("Adding new Pet Info...");
                  saveToDB();
                }
              },
              child: Text("ADD"))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Pet'),
      ),
      body: addPetWidget(),
    );
  }
}
