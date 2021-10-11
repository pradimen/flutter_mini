import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:petfit/Firebase/util.dart';
import 'package:petfit/models/product_data.dart';

class ViewProducts extends StatefulWidget {
  static const routeName = "/view_products";
  const ViewProducts({Key? key}) : super(key: key);

  @override
  _ViewProductsState createState() => _ViewProductsState();
}

class _ViewProductsState extends State<ViewProducts> {
  final _database = FirebaseDatabase.instance.reference();

  Widget buildListTileView() {
    return ListView.separated(
        separatorBuilder: (context, index) {
          return Column(
            children: [
              SizedBox(
                height: 5,
              ),
              Divider(
                color: Colors.purple,
              )
            ],
          );
        },
        // padding: EdgeInsets.all(10),
        itemCount: FirebaseConnection().productList.length,
        itemBuilder: (context, index) {
          final products = FirebaseConnection().productList[index];
          return Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), color: Colors.white),
            padding: EdgeInsets.all(10),
            child: ListTile(
              //horizontalTitleGap: 10,
              //minVerticalPadding: 10,

              // contentPadding: EdgeInsets.all(10),
              // dense: true,
              // visualDensity: VisualDensity(vertical: 50),
              shape: RoundedRectangleBorder(),
              leading: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                child: (products.photos.photos.first ?? "").length == 0
                    ? Image.asset(
                        'petfit_logo.png',
                        fit: BoxFit.cover,
                        width: 100,
                        height: 100,
                      )
                    : FadeInImage.assetNetwork(
                        placeholder: "petfit_logo.png",
                        image: products.photos.photos.first ?? "",
                        width: 100,
                        height: 100,
                        fit: BoxFit.fitWidth,
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
              title: Text(
                  '${index + 1} ${products.name}\nRs.${products.cost}\nQuantity: ${products.quantity}'),
              // subtitle: Text('Quantity: ${products.quantity}'),
              trailing: !FirebaseConnection().isAdmin
                  ? SizedBox()
                  : IconButton(
                      onPressed: () async {
                        FirebaseConnection().showCustomHUD("Please wait...");
                        await _database
                            .child('products/${products.name}')
                            .remove();
                        FirebaseConnection().hideCustomHUD();
                      },
                      icon: Icon(
                        Icons.delete_rounded,
                        color: Colors.purple,
                      )),
            ),
          );
        });
  }

  Widget buildProductListView() {
    return ListView.builder(
        itemCount: FirebaseConnection().productList.length,
        itemBuilder: (context, index) {
          final products = FirebaseConnection().productList[index];
          return Container(
            padding: EdgeInsets.all(5),
            child: Card(
              margin: EdgeInsets.all(5),
              elevation: 5,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    child: FadeInImage.assetNetwork(
                      placeholder: "petfit_logo.png",
                      image: products.photos.photos.first ?? "",
                      width: 100,
                      height: 100,
                      fit: BoxFit.fitWidth,
                      imageErrorBuilder: (context, error, stacktrace) {
                        return Image.asset(
                          'petfit_logo.png',
                          fit: BoxFit.fill,
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('$index ${products.name}'),
                      Text('Rs.${products.cost}'),
                      Text('Quantity: ${products.quantity}'),
                    ],
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 15,
                      ),
                      IconButton(
                          onPressed: () {
                            List<Products> filteredProduct =
                                FirebaseConnection().productList;
                            filteredProduct.removeAt(index);
                            var productJson = [];
                            filteredProduct.forEach((element) {
                              productJson.add(element.toJson());
                            });
                            _database.child('products').set(productJson);
                          },
                          icon: Icon(
                            Icons.delete_rounded,
                            color: Theme.of(context).colorScheme.secondary,
                          )),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    FirebaseConnection().showCustomHUD("Loading...");
    return Scaffold(
      appBar: AppBar(
        title: Text('All Products'),
      ),
      body: StreamBuilder(
          stream: _database.child('products').onValue.asBroadcastStream(),
          builder: (context, AsyncSnapshot<Event> snap) {
            if (snap.hasData) {
              if (snap.data!.snapshot.value != null) {
                final products =
                    Map<String, dynamic>.from(snap.data!.snapshot.value);
                FirebaseConnection().productList = products.values
                    .map((value) =>
                        Products.fromJSON(Map<String, dynamic>.from(value)))
                    .toList();
              }
            }
            FirebaseConnection().hideCustomHUD();
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
                    color: Theme.of(context)
                        .colorScheme
                        .secondary),
                child: FirebaseConnection().productList.length > 0
                    ? buildListTileView()
                    : Center(
                        child: Text('No Products available'),
                      ));
          }),
    );
  }
}
