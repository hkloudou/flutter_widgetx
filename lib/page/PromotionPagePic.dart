import 'dart:convert';
import 'dart:math';
import 'package:corex/corex.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

// import 'package:abc/entrys/PlatformConfig.dart';
// import 'package:abc/status/PlatformConfigStatus.dart';
// import 'package:abc/status/share.dart';
import 'package:styled_widget/styled_widget.dart';

class PromotionPagePic extends StatefulWidget {
  // TabController _tabController = new TabController(vsync: this, length: 2);

  PromotionPagePic({required this.ivtCode});
  @override
  State<PromotionPagePic> createState() {
    return new _PromotionPagePicState();
  }

  // final UsePromotion item;
  final String ivtCode;
}

class _PromotionPagePicState extends State<PromotionPagePic> {
  // CancelToken? _cancelToken;
  CfgPromotionPost? config;
  @override
  initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      var configs = context.read<CfgBaseStatus>().config?.promotions ?? [];

      if (configs.length > 0) {
        try {
          config = configs.elementAt(new Random().nextInt(configs.length));
        } catch (e) {
          config = configs.first;
        }
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    // _cancelToken?.cancel();
    super.dispose();
  }

  Widget _getQrcode(String url) {
    return url.isEmpty
        ? SpinKitCircle(
            color: Colors.black,
            size: 50,
          ).height(120)
        : Styled.widget(
            child: QrImage(
            data: url,
            version: QrVersions.auto,
            size: 120,
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.black,
            gapless: true,
          )).backgroundColor(Colors.white);
  }

  @override
  Widget build(BuildContext context) {
    if (config == null) {
      return Scaffold(
        appBar: AppBar(
          title: Styled.text("暂无数据"),
        ),
      );
    }
    return [
      ((config!.blur.isEmpty
              ? Image.network(
                  config!.img,
                  fit: BoxFit.fitHeight,
                )
              : BlurHash(
                  imageFit: BoxFit.fitHeight,
                  hash: config!.blur,
                  image: config!.img,
                )))
          .parent(({required child}) => Positioned.fill(
                child: Container(
                  color: Color(config!.bgColor),
                  child: child,
                ),
              )),
      (config!.url.isEmpty)
          ? SpinKitFadingCircle(size: 24, color: Colors.white)
          : [
              Styled.text("邀请码：${widget.ivtCode}")
                  .bold()
                  .fontSize(12)
                  .textColor(Colors.white)
                  .padding(all: 3, horizontal: 20)
                  // .backgroundColor(Colors.white)
                  .clipRRect(all: 20)
                  .padding(all: 5),
              _getQrcode(
                  config!.url.replaceAll(r"{code}", widget.ivtCode.toString()))
            ].toColumn().positioned(bottom: 30 + 50),
    ]
        .toStack(alignment: Alignment.center)
        .gestures(
          onTap: () => Navigator.of(context).pop(),
        )
        .parent(({required child}) => Scaffold(body: child));
  }
}
