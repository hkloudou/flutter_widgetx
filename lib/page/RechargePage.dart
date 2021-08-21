import 'package:corex/corex.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_richappbar/flutter_richappbar.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:widgetx/page/AssetHistoryPage.dart';

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
        "packages/flutter_uibox/assets/images/qrcode_border.png",
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
                  "${widget.asset.toUpperCase()}充值地址 (${widget.chian.toUpperCase()})")
              .textColor(Color(0xFF909399))
              .fontSize(12)
              .alignment(Alignment.centerLeft),
          Styled.text(
            addr.isEmpty ? "..." : addr,
          )
              .fontSize(13)
              .fontWeight(FontWeight.w500)
              .textColor(Colors.black)
              // .animate(Duration(milliseconds: 200), Curves.ease)
              .padding(right: 12)
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
                          content: Text("复制成功"),
                          duration: Duration(milliseconds: 500),
                        ),
                      );
                    })
          .padding(all: 15),
    ];
  }

  Widget _getTop(BuildContext context) {
    return [
      _getQrcode(),
      ..._getAddrAndParseBtn(context),
    ]
        .toColumn()
        .padding(bottom: 30)
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
      Styled.text("操作提示：")
          .fontSize(13)
          .textColor(Theme.of(context).primaryColor)
          .bold()
          .padding(vertical: 8),
      Styled.text(
              '1. 禁止向${widget.asset}地址充值其他资产，包括其他关联资产，否则将无法找回。\n2. 充值需要${widget.minConfirm}个网络节点确认才能到账。',
              style: TextStyle(height: 1.8))
          .textColor(Colors.grey.shade600)
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
            title: "${widget.asset} 充值",
            onRefresh: () async {
              setState(() {
                addr = "";
              });
              await DioAdapter()
                  .getRequest<String>(
                      "asset", "/getaddr/${widget.asset}/${widget.chian}",
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
                  addr = res.data ?? "";
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
