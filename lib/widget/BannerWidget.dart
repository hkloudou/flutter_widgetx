import 'package:carousel_slider/carousel_slider.dart';
import 'package:corex/corex.dart';
import 'package:provider/provider.dart';

// import '../core/core.dart';
// import '../status/CfgSimpleBannerStatus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:styled_widget/styled_widget.dart';
// Consumer

class BannerWidget extends StatelessWidget {
  const BannerWidget({
    Key? key,
    this.iconColor = Colors.grey,
    this.textColor = Colors.black,
    this.iconSize = 18,
    this.fontSize = 12,
  }) : super(key: key);
  final Color iconColor;
  final Color textColor;
  final double iconSize;
  final double fontSize;
  @override
  Widget build(BuildContext context) {
    return Consumer<CfgSimpleBannerStatus>(builder: (_, a, child) {
      if (!a.ready || a.items.length == 0) {
        return Styled.widget();
      }
      var banners = a.items;

      if (banners.length == 0 || !a.ready) {
        return Container();
      }
      return CarouselSlider(
        options: CarouselOptions(
          aspectRatio: a.width / a.height,
          autoPlay: banners.length > 1,
          enlargeCenterPage: true,
          enableInfiniteScroll: banners.length > 1,
          viewportFraction: banners.length > 1 ? 0.93 : 1.0,
        ),
        items: banners.map((i) {
          return Builder(
            builder: (BuildContext context) {
              return Container(
                margin: EdgeInsets.fromLTRB(
                  banners.length > 1 ? 4 : 16,
                  0,
                  banners.length > 1 ? 4 : 16,
                  0,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  child: Stack(children: <Widget>[
                    (i.blur.isEmpty
                            ? Image.network(
                                i.img,
                                fit: BoxFit.fill,
                              )
                            : BlurHash(
                                imageFit: BoxFit.fill,
                                hash: i.blur,
                                image: i.img,
                              ))
                        .gestures(
                            behavior: HitTestBehavior.opaque,
                            onTap: () => WiseLaunchAdapter.go(
                                context, i.href, "",
                                openInBrowser: false))
                  ]),
                ),
              );
            },
          );
        }).toList(),
      );
    });
  }
}
