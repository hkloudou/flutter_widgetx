import 'package:corex/corex.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_richappbar/flutter_richappbar.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:widgetx/page/AssetHistoryPage.dart';
import 'package:date_format/date_format.dart' as dfmt;

class RechargePage extends StatefulWidget {
  @override
  State<RechargePage> createState() {
    return new _RechargePageState();
  }

  RechargePage(this.asset, this.chian, {this.minConfirm = 20});
  final String asset;
  final String chian;
  final int minConfirm;
}

class _RechargePageState extends State<RechargePage> {
  CancelToken? _cancelToken;
  String addr = "";
  int createdAt = 0;
  int expiredAt = 0;
  @override
  initState() {
    _cancelToken = CancelToken();
    super.initState();
  }

  @override
  void dispose() {
    _cancelToken?.cancel();
    super.dispose();
  }

  Widget _getQrcode() {
    return [
      Image.asset(
        "packages/widgetx/assets/images/qrcode_border.png",
        width: 200,
        height: 200,
      ),
      Styled.widget(
              child: QrImage(
        data: addr,
        version: QrVersions.auto,
        size: 180,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        gapless: true,
      ))
          .opacity(addr.isEmpty ? 0 : 1, animate: true)
          .padding(all: 3)
          .backgroundColor(Colors.white)
          .animate(Duration(milliseconds: 200), Curves.ease),
    ]
        .toStack(alignment: AlignmentDirectional.center)
        .padding(vertical: 36, top: 50)
        .gestures(
          behavior: HitTestBehavior.translucent,
        );
  }

  List<Widget> _getAddrAndParseBtn(BuildContext context) {
    return [
      [
        [
          Styled.text(
                  "${widget.asset.toUpperCase()}εεΌε°ε (${widget.chian.toUpperCase()})")
              .textColor(EColor.second)
              .fontSize(12)
              .alignment(Alignment.centerLeft),
          Styled.text(
            addr.isEmpty ? "..." : addr,
          )
              .fontSize(13)
              .fontWeight(FontWeight.w500)
              .textColor(EColor.main)
              // .animate(Duration(milliseconds: 200), Curves.ease)
              .padding(right: 12),
        ].toColumn(crossAxisAlignment: CrossAxisAlignment.start).expanded(),
        Styled.icon(Icons.copy, size: 16)
      ]
          .toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween)
          .padding(all: 12)
          .backgroundColor(Theme.of(context).scaffoldBackgroundColor)
          .gestures(
              onTap: addr.isEmpty
                  ? null
                  : () {
                      Clipboard.setData(ClipboardData(text: addr));
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("ε€εΆζε"),
                          duration: Duration(milliseconds: 500),
                        ),
                      );
                    })
          .padding(all: 15),
    ];
  }

  List<Widget> _getExt(BuildContext context) {
    var extStyle = TextStyle(
        color: EColor.second, fontSize: 10, fontStyle: FontStyle.normal);
    return [
      createdAt > 0
          ? Styled.text(
              "εε»ΊζΆι΄οΌ" +
                  dfmt.formatDate(
                      DateTime.fromMillisecondsSinceEpoch(createdAt * 1000), [
                    dfmt.yyyy,
                    "εΉ΄",
                    dfmt.mm,
                    "ζ",
                    dfmt.dd,
                    " ",
                    dfmt.HH,
                    ":",
                    dfmt.nn,
                    ":",
                    dfmt.ss
                  ]),
              style: extStyle)
          : Container(),
      expiredAt > 0
          ? Styled.text(
              "θΏζζΆι΄οΌ" +
                  dfmt.formatDate(
                      DateTime.fromMillisecondsSinceEpoch(expiredAt * 1000), [
                    dfmt.yyyy,
                    "εΉ΄",
                    dfmt.mm,
                    "ζ",
                    dfmt.dd,
                    " ",
                    dfmt.HH,
                    ":",
                    dfmt.nn,
                    ":",
                    dfmt.ss
                  ]),
              style: extStyle)
          : (addr == ""
              ? Container()
              : Styled.text("θΏζζΆι΄οΌζ°ΈδΉζζ", style: extStyle)),
    ];
  }

  Widget _getTop(BuildContext context) {
    // var exTimeSize = 11.00;
    // var extColor = Theme.of(context).primaryColor;

    return [
      _getQrcode(),
      ..._getAddrAndParseBtn(context),
      _getExt(context)
          .toColumn(crossAxisAlignment: CrossAxisAlignment.start)
          .height(36),
    ]
        .toColumn()
        .padding(bottom: 16)
        .backgroundColor(Colors.white)
        .clipRRect(
          bottomLeft: 30,
          bottomRight: 30,
        )
        .borderRadius(all: 25, animate: false)
        .elevation(
          20,
          borderRadius: BorderRadius.circular(25),
          shadowColor: Color(0x30000000),
        );
  }

  Widget _getTip(BuildContext context) {
    return [
      Styled.text("ζδ½ζη€ΊοΌ")
          .fontSize(13)
          .textColor(Theme.of(context).primaryColor)
          .bold()
          .padding(vertical: 8),
      Styled.text(
              '1. η¦ζ­’ε${widget.asset}ε°εεεΌεΆδ»θ΅δΊ§οΌεζ¬εΆδ»ε³θθ΅δΊ§οΌε¦εε°ζ ζ³ζΎεγ\n2. εεΌιθ¦${widget.minConfirm}δΈͺη½η»θηΉη‘?θ?€ζθ½ε°θ΄¦γ',
              style: TextStyle(height: 1.8))
          .textColor(EColor.normal)
          // .letterSpacing(1.1)
          .fontSize(12)
          .padding(vertical: 4),
    ]
        .toColumn(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
        )
        .padding(horizontal: 12, vertical: 16)
        .alignment(Alignment.centerLeft);
  }

  @override
  Widget build(BuildContext context) {
    EdgeInsets devicePadding = MediaQuery.of(context).padding;
    return [
      _getTop(context),
      _getTip(context),
      SizedBox(height: devicePadding.bottom)
    ].toColumn().parent(
          ({required child}) => RichAppBarPage(
            body: child,
            title: "${widget.asset} εεΌ",
            controler: RickRefreshControler(initialRefresh: true),
            onRefresh: () async {
              // print("RechargePage onRefresh");
              // setState(() {
              //   addr = "";
              // });
              await DioAdapter()
                  .getRequest<Map<String, dynamic>>(
                      "system", "/wallet.getaddr.${widget.chian}",
                      cancelToken: _cancelToken, sign: true)
                  .then((res) {
                if (!mounted || res.canced) {
                  return;
                } else if (res.code != 0) {
                  alert(context, res.msg,
                      cb: () => Navigator.of(context).pop());
                  return;
                }
                if (res.msg != "") {
                  ScaffoldMessenger.maybeOf(context)?.showSnackBar(
                      SnackBar(content: Styled.text(res.msg).fontSize(13)));
                }
                setState(() {
                  addr = res.data?["addr"] ?? "";
                  createdAt = res.data?["createdAt"] ?? 0;
                  expiredAt = res.data?["expiredAt"] ?? 0;
                });
              });
            },
            actions: [
              IconButton(
                icon: Icon(Icons.pending_actions_sharp),
                onPressed: () => showAnimatePage(
                    context, AssetsHistoryPage(defaultReson: "recharge"),
                    replace: true),
              )
            ],
          ),
        );
  }
}
