import 'package:corex/corex.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_richappbar/flutter_richappbar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:flutter_uibox/flutter_uibox.dart';
import 'package:provider/provider.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:widgetx/page/AssetHistoryPage.dart';
// import 'package:app/commons/EColor.dart';
// import '../core/core.dart';
// import '../utils/DioAdapter.dart';
// import '../status/UserAssetStatus.dart';

class WithDrawPage extends StatefulWidget {
  @override
  State<WithDrawPage> createState() {
    return new _WithDrawPageState();
  }

  WithDrawPage(
      {this.minAmount = 100, required this.feeCalcer, required this.feeTip});
  final double minAmount;
  final double Function(double val) feeCalcer;
  final String feeTip;
}

class _WithDrawPageState extends State<WithDrawPage> {
  var cAddr = TextEditingController();
  var cAmount = TextEditingController();
  var _formKey = GlobalKey<FormState>();
  double _real = 0;
  CancelToken? _cancelToken;

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

  List<Widget> _getTextBox(BuildContext context, UserAssetStatus u) {
    var base = InputDecoration(
      fillColor: Theme.of(context).scaffoldBackgroundColor,
      contentPadding: new EdgeInsets.all(12.0),
      filled: true,
      hintStyle: TextStyle(fontSize: 13, color: Color(0xFFC0C4CC)),
      border: InputBorder.none,
      // enabledBorder:
    );
    return [
      Styled.text("地址")
          .textColor(EColor.normal)
          .fontSize(12)
          .bold()
          .alignment(Alignment.centerLeft)
          .padding(vertical: 5),
      TextFormField(
        controller: cAddr,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        enabled: u.usdt != null,
        validator: (String? v) {
          var addr = (v ?? "").trim();
          if (addr.isEmpty) {
            return "请输入提现地址";
          } else if (!addr.startsWith("T")) {
            return "提现地址错误";
          } else if (addr.length != 34) {
            return "提现地址长度错误";
          }
        },
        decoration: base.copyWith(
          hintText: "点击粘贴地址",
          suffixIcon: Styled.icon(Icons.qr_code,
                  size: 18, color: Color(0xFFC0C4CC))
              .parent(({required child}) =>
                  MouseRegion(cursor: SystemMouseCursors.click, child: child)),
        ),
      ),
      Styled.text("提现金额")
          .textColor(EColor.normal)
          .fontSize(12)
          .bold()
          .alignment(Alignment.centerLeft)
          .padding(vertical: 5),
      TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: cAmount,
        onFieldSubmitted: (value) => {print("value: $value")},
        enabled: u.usdt != null,
        onChanged: (value) {
          Future.delayed(Duration(milliseconds: 200), () => setState(() {}));
        },
        onEditingComplete: () {
          setState(() {});
        },
        validator: (String? v) {
          var n = (double.tryParse(v ?? "") ?? 0);
          if ((v ?? "").isEmpty) {
            return "请输入提现金额";
          } else if (n == 0) {
            _real = 0;
            return "提现金额填写错误";
          } else if (n < widget.minAmount) {
            _real = 0;
            return "最小提现金额为${widget.minAmount}USDT";
          } else if (n > (u.usdt?.free ?? 0)) {
            _real = 0;
            return "提现金额必须小于余额";
          }
          _real = widget.feeCalcer(n);
          if (_real < 0) {
            return "最终到账金额小于0";
          }
        },
        decoration: base.copyWith(
            hintText: "最少${widget.minAmount}",
            suffixIcon: u.usdt == null
                ? null
                : [
                    Styled.text("USDT")
                        .bold()
                        .fontSize(13)
                        .textColor(EColor.second),
                    TextButton(
                      onPressed: () {
                        cAmount.text =
                            u.usdt?.free.toStringAsRoundDown(2) ?? "0";
                        setState(() {
                          // _real = (u.usdt?.free ?? 0) * 0.99;
                          _real = widget
                              .feeCalcer(double.tryParse(cAmount.text) ?? 0);
                        });
                      },
                      child: Styled.text("全部提现")
                          .fontSize(13)
                          .bold()
                          .textColor(Theme.of(context).primaryColor)
                          // .textColor(EColor.main)
                          .padding(horizontal: 5),
                    ),
                  ].toRow(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min)),
      ),
      [
        (u.usdt == null)
            ? [
                Styled.text("读取中")
                    .textColor(EColor.second)
                    .textColor(Colors.black)
                    .bold()
                    .fontSize(12)
                    .alignment(Alignment.centerLeft),
                SpinKitThreeBounce(
                  color: EColor.second,
                  size: 12,
                )
              ].toRow()
            : Styled.text("可用余额 ${u.usdt?.free.toStringAsRoundDown(2)} USDT")
                .textColor(EColor.second)
                .textColor(Colors.black)
                .bold()
                .fontSize(12)
                .alignment(Alignment.centerLeft),
        Styled.text(widget.feeTip)
            .fontSize(12)
            .textColor(EColor.normal)
            .bold()
            // .textColor(Theme.of(crontext).primaryColor)
            // .textColor(Colors.blueAccent)

            .alignment(Alignment.centerLeft)
      ]
          .toRow(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
          )
          .padding(vertical: 5),
    ];
  }

  Widget _getWidget(BuildContext context, UserAssetStatus u) {
    return Form(
        key: _formKey,
        child: [..._getTextBox(context, u)]
            .toColumn()
            .padding(horizontal: 15, vertical: 30)
            .backgroundColor(Colors.white)
            .clipRRect(
              bottomLeft: 30,
              bottomRight: 30,
            ));
  }

  Widget _getTotal(BuildContext context, UserAssetStatus u) {
    EdgeInsets devicePadding = MediaQuery.of(context).padding;
    return [
      [
        Styled.text("实际到账", overflow: TextOverflow.clip)
            .textColor(Color(0xFF909399))
            .fontSize(12),
        Styled.text("${_real.toStringAsRoundDown(2)} USDT",
                overflow: TextOverflow.clip)
            .textColor(Color(0xFF303133))
            .fontSize(14)
            .bold(),
        // Styled.text("手续费 0.00 USDT").textColor(Color(0xFF909399)).fontSize(12),
      ]
          .toColumn(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start)
          .padding(right: 5),
      // FlatButton(onPressed: () {}),
      OutlinedButton(
        // onPressed: _real>0 () {
        //   if (_formKey.currentState?.validate() == true) {
        //     alert(context, "可以提现");
        //   }
        // }:null,
        onPressed: _real > 0
            ? () {
                if (_formKey.currentState?.validate() == true) {
                  alert(context,
                      "提现：\n${cAmount.text} USDT\n到：\n${cAddr.text}\n此操作不可逆，请认真核对地址\n请确认？",
                      cancelBtn: true, cb: () {
                    FocusScope.of(context).requestFocus(FocusNode());

                    showProgress(context);
                    DioAdapter().getRequest("system", "/asset.withdraw",
                        sign: true,
                        cancelToken: _cancelToken,
                        queryParameters: {
                          "group": 0,
                          "asset": "usdt",
                          "addr": cAddr.text,
                          "amount": cAmount.text,
                        }).then((res) {
                      hideProgress(context);
                      if (!mounted || res.canced) {
                        return;
                      } else if (res.code != 0) {
                        alert(context, res.msg,
                            cb: () => Navigator.of(context).pop());
                        return;
                      }
                      if (res.msg != "") {
                        ScaffoldMessenger.maybeOf(context)?.showSnackBar(
                            SnackBar(
                                content: Styled.text(res.msg).fontSize(13)));
                      }
                    });
                  });
                }
              }
            : null,
        child: Text(
          "提现",
          style: TextStyle(fontSize: 13),
        ),
        style: OutlinedButton.styleFrom(
            elevation: 0,
            primary: Colors.white,
            // shadowColor: Theme.of(context).primaryColor,
            backgroundColor:
                _real > 0 ? Theme.of(context).primaryColor : EColor.placehilder,
            shadowColor: Colors.red
            // textStyle: TextStyle(color: Colors.white, fontSize: 13),
            ),
      )
    ]
        .toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween)
        .padding(all: 12, bottom: devicePadding.bottom + 12)
        .backgroundColor(Colors.white)
        .border(
          top: 1,
          color: Color(0xFF909399).withAlpha(20),
        );
  }

  @override
  Widget build(BuildContext context) {
    EdgeInsets devicePadding = MediaQuery.of(context).padding;
    return Consumer<UserAssetStatus>(builder: (_, u, child) {
      return [
        _getWidget(context, u),
        [
          Styled.text("操作提示：")
              .fontSize(13)
              .textColor(Theme.of(context).primaryColor)
              .bold()
              .padding(vertical: 8),
          Styled.text(r'''
1. 请核对USDT收款地址，一旦填写错误，将无法收到资产。
2. 由于ETH矿工费上涨，暂只支持TRC20链提现。
''', style: TextStyle(height: 1.8))
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
            .alignment(Alignment.centerLeft),
        SizedBox(height: devicePadding.bottom),
      ].toColumn().parent(
            ({required child}) => RichAppBarPage(
              body: child,
              title: "USDT 提现",
              bodyBottom: _getTotal(context, u),
              onRefresh: () => context.read<UserAssetStatus>().init(),
              actions: [
                IconButton(
                  icon: Icon(Icons.pending_actions_sharp),
                  onPressed: () => showAnimatePage(
                      context, AssetsHistoryPage(defaultReson: "withdraw"),
                      replace: true),
                )
              ],
            ),
          );
    }).gestures(onTap: () {
      FocusScope.of(context).requestFocus(FocusNode());
    });
  }
}
