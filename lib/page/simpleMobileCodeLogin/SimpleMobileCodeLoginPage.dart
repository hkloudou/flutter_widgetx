import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:corex/corex.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/rendering.dart';
import 'package:flare_flutter/flare.dart';
import 'package:flare_flutter/flare_controls.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:provider/provider.dart';
// import '../../core/core.dart';
part './bear/input_helper.dart';
part './bear/signin_button.dart';
part './bear/teddy_controller.dart';
part './bear/tracking_text_input.dart';
part './PinCodeVerificationPage.dart';
part './CompContrySelectPage.dart';


getFlareActor({
  FlareControls? teddyController,
  String filename = "packages/widgetx/assets/images/Teddy.flr",
  Alignment alignment = Alignment.bottomCenter,
  BoxFit fit: BoxFit.contain,
}) =>
    FlareActor(
      filename,
      // shouldClip: false,
      alignment: alignment,
      fit: fit,
      controller: teddyController,
    );

class SimpleMobileCodeLoginPage extends StatefulWidget {
  SimpleMobileCodeLoginPage({this.com});

  @override
  _SimpleMobileCodeLoginPageState createState() =>
      _SimpleMobileCodeLoginPageState();
  final Completer? com;
}

class _SimpleMobileCodeLoginPageState extends State<SimpleMobileCodeLoginPage> {
  String? mobile;
  final Color colorGrey = Color(0xFFC5CFD5);
  final Color colorGrey2 = Color(0xFFE7EBEE);

  final _formKey = GlobalKey<FormState>();
  TeddyController? _teddyController;
  CancelToken? _cancelToken;

  @override
  initState() {
    _teddyController = TeddyController();
    super.initState();
    _cancelToken = CancelToken();
  }

  @override
  void dispose() {
    // print("dispose");
    if (!(widget.com?.isCompleted ?? true)) {
      widget.com?.complete();
    }
    _cancelToken?.cancel();
    super.dispose();
  }

  @override
  void deactivate() {
    super.deactivate();
    // print("login deactivate");
  }

  VoidCallback authAction(BuildContext context) {
    return () async {
      _teddyController!.pauseAutoHandDown();
      FocusScope.of(context).requestFocus(FocusNode());
      _teddyController!.playHandsDown();

      if (!_formKey.currentState!.validate()) {
        _teddyController!.playFail();
        _teddyController!.resumeAutoHandDown();
        return;
      }
      _teddyController!.playSuccess();
      _teddyController!.resumeAutoHandDown();
      // var tip = "";
      // try {
      //   // parseLongInt(mobile ?? "");
      //   int.tryParse(mobile ?? "");
      //   // Int64.t
      // } catch (e) {}
      showProgress(context);
      DioAdapter()
          .getRequest<void>(
        "auth",
        "/getcode",
        cancelToken: _cancelToken,
        queryParameters: {
          "mobile": mobile ?? "",
          "contryCode": "86",
        },
        sign: true,
      )
          .then((res) {
        hideProgress(context);
        if (!mounted || res.canced) {
          return;
        }
        print("res:$res");
        if (res.code != 0) {
          _teddyController?.playFail();
          alert(context, res.msg, cb: () => Navigator.of(context).pop());
          return;
        }
        if (res.msg != "") {
          ScaffoldMessenger.maybeOf(context)?.showSnackBar(
              SnackBar(content: Styled.text(res.msg).fontSize(13)));
        }
        showAnimatePage(
          context,
          PinCodeVerificationPage(contry: 86, mobile: mobile ?? ""),
          replace: true, // a random number, please don't call xD
        );
      });
    };
  }

  void selectContry() async {
    Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
          builder: (context) => CompContrySelectPage(), fullscreenDialog: true),
    );
  }

  @override
  Widget build(BuildContext context) {
    var _p = Theme.of(context).primaryColor;
    EdgeInsets devicePadding = MediaQuery.of(context).padding;
    // final Color _bg = Color.fromRGBO(170, 207, 212, 1);
    final Color _bg = Theme.of(context).primaryColor;
    return Scaffold(
      // appBar: Null,
      // backgroundColor: Theme.of(context).primaryColor,
      backgroundColor: Colors.white,
      body: Container(
        child: [
          /*中间元素 */
          [
            //熊
            (getFlareActor(
              teddyController: _teddyController,
            ) as Widget)
                .padding(
                    left: 30.0, right: 30.0, top: devicePadding.top + 50 /* */)
                .height((MediaQuery.of(context).size.height * 0.372)
                    .roundToDouble())
                .decorated(color: _bg)
                .clipRRect(bottomLeft: 50),
            Form(
              key: _formKey,
              child: [
                TextButton(
                    onPressed: null,
                    child: Flex(
                      direction: Axis.horizontal,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Styled.text("+86")
                            .fontSize(15)
                            .padding(vertical: 5)
                            .flexible(),
                        Styled.icon(Icons.keyboard_arrow_down).flexible()
                      ],
                    )),
                TrackingTextInput(
                  teddyController: _teddyController!,
                  label: "手机号",
                  hint: "请输入手机号",
                  // focusNode: _focus,
                  // isObscured: true,
                  onCaretMoved: (Offset? caret) {
                    // print(caret);
                    _teddyController?.coverEyes(caret != null);
                    _teddyController?.lookAt(null);
                  },
                  onTextChanged: (String value) {
                    mobile = value;
                  },
                ),
                TextButton(
                        // backgroundColor: Colors.red,
                        style: TextButton.styleFrom(
                          primary: Colors.white,
                          backgroundColor: _bg,
                          onSurface: Colors.grey,
                        ),
                        onPressed: authAction(context),
                        child: Text("下一步"))
                    .constrained(width: double.infinity, height: 50)
                    .clipRRect(all: 25) // clip ripple
                    .borderRadius(all: 25)
                    .elevation(
                      20,
                      borderRadius: BorderRadius.circular(25),
                      shadowColor: Color(0x30000000),
                    )
                    .padding(vertical: 8),
                SizedBox(
                  height: 30,
                  width: double.infinity,
                )
              ].toColumn(
                //输入框
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
              ),
            ).padding(all: 30),
          ]
              .toColumn(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                // mainAxisSize: MainAxisSize.min
              )
              .scrollable()
              .gestures(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    // print("小熊");
                    //关闭键盘，小熊手张开
                    FocusScope.of(context).requestFocus(FocusNode());
                  })
              .parent(
                ({required child}) => Positioned.fill(
                  child: child,
                ),
              ),
          /*关闭按钮*/
          Positioned(
            right: 20,
            top: devicePadding.top + 20,
            child: IconButton(
              icon: Icon(Icons.close),
              // iconSize: 24,
              color: Colors.white,
              hoverColor: Color.fromRGBO(_p.red, _p.green, _p.blue, 0.7),
              onPressed: () {
                // print("cose");
                Navigator.of(context).pop();
              },
            ),
          )
        ].toStack(),
      ),
    );
  }
}

// Future<void> Function(
//   BuildContext context,
//   int contry,
//   String mobile, {
//   CancelToken? cancelToken,
// }) _requestGetCode = (BuildContext context, contry, mobile,
//         {CancelToken? cancelToken}) =>
//     Future.error("未初始化");

// late Future<void> Function(
//   BuildContext context,
//   int contry,
//   String mobile,
//   String code, {
//   CancelToken? cancelToken,
// }) _requestCodeLogin = (
//   BuildContext context,
//   int contry,
//   String mobile,
//   String code, {
//   CancelToken? cancelToken,
// }) =>
//     Future.error("未初始化");

// late Future<void> Function(
//   int contry,
//   String mobile, {
//   CancelToken? cancelToken,
// }) _requestGetCode;

// void registerGetCodeHandle(
//     Future<void> Function(
//   BuildContext context,
//   int contry,
//   String mobile, {
//   CancelToken? cancelToken,
// })
//         fun) {
//   _requestGetCode = fun;
// }

// void registerCodeLoginHandle(
//     Future<void> Function(
//   BuildContext context,
//   int contry,
//   String mobile,
//   String code, {
//   CancelToken? cancelToken,
// })
//         fun) {
//   _requestCodeLogin = fun;
// }
