import 'package:flutter/material.dart';
import 'package:petfit/models/pet_data.dart';
import 'package:petfit/src/screens/pet_details_screen.dart';

class PetsListView extends StatelessWidget {
  final List<PetData> petList;
  PetsListView(this.petList);

  void petDetailAction(
      BuildContext context, PetData selectedPet, int petIndex) {
    Navigator.pushNamed(context, PetDetails.routeName,
        arguments: {'pet': selectedPet, 'index': petIndex});
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: petList.length,
        itemBuilder: (context, index) {
          String imageURL = petList[index].album.photos.first ?? "";
          return InkWell(
            onTap: () {
              petDetailAction(context, petList[index], index);
            },
            child: Container(
              padding: EdgeInsets.all(5),
              child: Card(
                // margin: EdgeInsets.all(10),
                elevation: 5,
                child: Container(
                  padding: EdgeInsets.all(5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      imageURL.length == 0
                          ? Image.asset(
                              'petfit_logo.png',
                              fit: BoxFit.cover,
                              width: 100,
                              height: 100,
                            )
                          : FadeInImage.assetNetwork(
                              placeholder: "petfit_logo.png",
                              image: imageURL,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                              imageErrorBuilder: (context, error, stacktrace) {
                                return Image.asset(
                                  'petfit_logo.png',
                                  fit: BoxFit.cover,
                                  width: 100,
                                  height: 100,
                                );
                              },
                            ),
                      SizedBox(
                        width: 5,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Pet name:"),
                          SizedBox(
                            height: 10,
                          ),
                          Text("Pet Age:"),
                          SizedBox(
                            height: 10,
                          ),
                          Text("Pet Location:"),
                          SizedBox(
                            height: 10,
                          ),
                          Text("Pet breed:")
                        ],
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Flexible(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${this.petList[index].name}",
                              maxLines: 1, overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "${this.petList[index].dob}",
                              maxLines: 1, overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "${this.petList[index].location}",
                              maxLines: 1, overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "${this.petList[index].bread}",
                              maxLines: 1, overflow: TextOverflow.ellipsis,
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
