part of 'SimpleMobileCodeLoginPage.dart';

class PinCodeVerificationPage extends StatefulWidget {
  final int contry;
  final String mobile;

  PinCodeVerificationPage({required this.contry, required this.mobile});

  @override
  _PinCodeVerificationPageState createState() =>
      _PinCodeVerificationPageState();
}

class _PinCodeVerificationPageState extends State<PinCodeVerificationPage> {
  // late var onTapRecognizer;
  Timer? _countdownTimer;
  String _codeCountdownStr = '重新发送';
  int _countdownNum = 60;
  FocusNode _focusNode = FocusNode();
  TextEditingController textEditingController = TextEditingController()
    ..text = "";
  late StreamController<ErrorAnimationType> errorController;

  bool hasError = false;
  String currentText = "";
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  CancelToken? _cancelToken;

  void reGetCountdown() {
    setState(() {
      if (_countdownTimer != null) {
        return;
      }
      // Timer的第一秒倒计时是有一点延迟的，为了立刻显示效果可以添加下一行。
      _codeCountdownStr = '重新获取(${_countdownNum--})';
      _countdownTimer = new Timer.periodic(new Duration(seconds: 1), (timer) {
        setState(() {
          if (_countdownNum > 0) {
            _codeCountdownStr = '重新获取(${_countdownNum--})';
          } else {
            _codeCountdownStr = "重新获取";
            _countdownNum = 60;
            _countdownTimer?.cancel();
            _countdownTimer = null;
          }
        });
      });
    });
  }

  @override
  void initState() {
    _cancelToken = CancelToken();
    errorController = StreamController<ErrorAnimationType>();
    reGetCountdown();
    super.initState();
  }

  @override
  void dispose() {
    errorController.close();
    _countdownTimer?.cancel();
    _countdownTimer = null;
    super.dispose();
    _cancelToken?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    var _p = Theme.of(context).primaryColor;
    EdgeInsets devicePadding = MediaQuery.of(context).padding;
    return Scaffold(
      // backgroundColor: Colors.blue.shade50,
      // backgroundColor: AppConfig.colorPrimary,
      key: scaffoldKey,
      body: [
        [
          FlareActor(
            "packages/widgetx/assets/images/otp.flr",
            animation: "otp",
            fit: BoxFit.fitHeight,
            alignment: Alignment.center,
          )
              .height(
                  (MediaQuery.of(context).size.height * 0.372).roundToDouble())
              .decorated(color: Color.fromRGBO(_p.red, _p.green, _p.blue, 0.2))
              .clipRRect(bottomLeft: 50),

          //.backgroundColor(Color.fromRGBO(130, 170, 237, 1)),
          Styled.text("+${widget.contry} ${widget.mobile}",
                  textAlign: TextAlign.center)
              .fontSize(22)
              .bold()
              .padding(vertical: 8),
          Styled.text("更换手机号")
              .fontSize(15)
              .textColor(_p)
              .bold()
              .padding(vertical: 8)
              .gestures(
                behavior: HitTestBehavior.opaque,
                onTap: () => {
                  showAnimatePage(
                    context,
                    SimpleMobileCodeLoginPage(),
                    replace: true, // a random number, please don't call xD
                  ),
                },
              ),
          PinCodeTextField(
            keyboardType: TextInputType.number,
            appContext: context,
            focusNode: _focusNode,
            autoFocus: true,
            autoDismissKeyboard: true,
            length: 6,
            obscureText: false,
            animationType: AnimationType.fade,
            pinTheme: PinTheme(
              shape: PinCodeFieldShape.box,
              // borderRadius: BorderRadius.circular(5),
              fieldHeight: 50,
              fieldWidth: 40,
              activeFillColor: Colors.white,
              inactiveFillColor: Colors.white,
              inactiveColor: Color.fromRGBO(244, 67, 54, 0.7),
              selectedFillColor: Color.fromRGBO(_p.red, _p.green, _p.blue, 0.2),
            ),
            validator: (v) {
              if ((v ?? "").length < 6) {
                return "请输入6位验证码";
              } else {
                return null;
              }
            },
            animationDuration: Duration(milliseconds: 300),
            // backgroundColor: Colors.blue.shade50,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            backgroundColor: Colors.transparent,
            enableActiveFill: true,
            errorAnimationController: errorController,
            controller: textEditingController,
            onCompleted: (v) {
              var tip = "";
              showProgress(context);
              DioAdapter()
                  .getRequest<Map<String, dynamic>>(
                "auth",
                "/login",
                cancelToken: _cancelToken,
                queryParameters: {
                  "mobile": widget.mobile,
                  "contryCode": widget.contry,
                  "code": v,
                },
                sign: true,
              )
                  .then((res) {
                hideProgress(context);
                if (res.code != 0) {
                  alert(context, res.msg, cb: () {
                    textEditingController.clear();
                    FocusScope.of(context).requestFocus(_focusNode);
                  });
                  return Future.value();
                }
                if (res.msg != "") {
                  ScaffoldMessenger.maybeOf(context)?.showSnackBar(
                      SnackBar(content: Styled.text(res.msg).fontSize(13)));
                }
                var userName = (res.data?["username"] ??
                    res.data?["user_name"] ??
                    res.data?["userName"] ??
                    res.data?["UserName"]) as String?;
                var token =
                    (res.data?["token"] ?? res.data?["Token"]) as String?;
                if (userName == null || token == null) {
                  return Future.error("参数错误");
                }
                context.read<AuthStatus>().login(userName, base64Decode(token));
                Navigator.of(context).pop();
              });
              // _requestCodeLogin(context, widget.contry, widget.mobile, v)
              //     .catchError((err) {
              //   tip = err;
              // }).whenComplete(() {
              //   hideProgress(context);
              //   if (tip.length > 0) {
              //     alert(context, tip, cb: () {
              //       textEditingController.clear();
              //       FocusScope.of(context).requestFocus(_focusNode);
              //     });
              //   } else {
              //     Navigator.of(context).pop();
              //   }
              // });
            },
            onChanged: (value) {
              // print(value);
              setState(() {
                currentText = value;
              });
            },
            beforeTextPaste: (text) {
              print("Allowing to paste $text");
              //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
              //but you can show anything you want here, like your pop up saying wrong paste format or etc
              return true;
            },
            // Styled.text("*请输入验证码")
          ).padding(vertical: 8, horizontal: 20),
          [
            Styled.text("没有收到验证码?     ").fontSize(15),
            _codeCountdownStr == "重新获取"
                ? Styled.text(_codeCountdownStr)
                    .fontSize(16)
                    .textColor(_p)
                    .padding(all: 10)
                    .gestures(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          // var tip = "";
                          showProgress(context);
                          DioAdapter()
                              .getRequest<void>(
                            "auth",
                            "/getcode",
                            cancelToken: _cancelToken,
                            queryParameters: {
                              "mobile": widget.mobile,
                              "contryCode": widget.contry,
                            },
                            sign: true,
                          )
                              .then((res) {
                            hideProgress(context);

                            if (!mounted || res.canced) {
                              return Future.value();
                            }
                            textEditingController.clear();
                            if (res.code != 0) {
                              alert(context, res.msg,
                                  cb: () => Navigator.of(context).pop());
                              return Future.value();
                            }
                            if (res.msg != "") {
                              ScaffoldMessenger.maybeOf(context)?.showSnackBar(
                                  SnackBar(
                                      content:
                                          Styled.text(res.msg).fontSize(13)));
                            }
                          });

                          // _requestGetCode(context, widget.contry, widget.mobile)
                          //     .catchError((err) {
                          //   tip = err;
                          // }).whenComplete(() {
                          //   hideProgress(context);
                          //   textEditingController.clear();
                          //   if (tip.length > 0) {
                          //     alert(context, tip, cb: () {
                          //       FocusScope.of(context).requestFocus(_focusNode);
                          //     });
                          //   } else {
                          //     FocusScope.of(context).requestFocus(_focusNode);
                          //     reGetCountdown();
                          //   }
                          // });
                        })
                : Styled.text(_codeCountdownStr)
                    .fontSize(16)
                    .textColor(Colors.grey)
                    .padding(all: 10)
          ].toRow(mainAxisAlignment: MainAxisAlignment.center)
        ]
            .toColumn()
            .scrollable()
            .parent(({required child}) => Positioned.fill(child: child)),
        Positioned(
          right: 20,
          top: devicePadding.top + 20,
          child: IconButton(
            icon: Icon(Icons.close),
            // iconSize: 24,
            color: Colors.black,
            // hoverColor: _p,
            onPressed: () {
              // print("cose");
              Navigator.of(context).pop();
            },
          ),
        )
      ].toStack(),
    );
  }
}
