//import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';

class CarouselLoading extends StatelessWidget {
  final List<String?> imageList;
  final double itemHeight;
  CarouselLoading(this.imageList, this.itemHeight);

  @override
  Widget build(BuildContext context) {
    return imageList.length > 0
        ? Container(
            padding: EdgeInsets.all(10),
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
            child: Swiper(
              pagination: SwiperPagination(
                margin: EdgeInsets.all(5.0),
              ),
              loop: true,
              autoplay: true,
              itemCount: imageList.length,
              itemHeight: this.itemHeight,
              itemWidth: 150,
              layout: SwiperLayout.DEFAULT,
              itemBuilder: (ctx, index) {
                String imageURL = imageList[index]!;
                return ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    child: imageURL.isEmpty
                        ? Image.asset(
                            'petfit_logo.png',
                            fit: BoxFit.cover,
                            width: 100,
                            height: 100,
                          )
                        : FadeInImage.assetNetwork(
                            placeholder: 'petfit_logo.png',
                            image: imageURL,
                            fit: BoxFit.fill,
                            imageErrorBuilder: (context, error, stacktrace) {
                              return Image.asset(
                                'petfit_logo.png',
                                fit: BoxFit.fill,
                              );
                            },
                          ));
              },
              scrollDirection: Axis.horizontal,
            ),
          )
        : Container(
            width: MediaQuery.of(context).size.width,
            child: Text(
              'Please wait...',
              style: Theme.of(context).textTheme.headline6,
            ),
          );
  }
}
