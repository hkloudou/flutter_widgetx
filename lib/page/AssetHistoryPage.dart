import 'dart:math';

import 'package:corex/corex.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
// import '../core/core.dart';
// import '../utils/DioAdapter.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:date_format/date_format.dart' as dfmt;

class AssetsHistoryPage extends StatefulWidget {
  AssetsHistoryPage({this.defaultReson, Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return new _AssetsHistoryPageState();
  }

  final String? defaultReson;
}

class _AssetsHistoryPageState extends State<AssetsHistoryPage> {
  List<String> status = [
    ";全部",
    "recharge;充值",
    "withdraw;提现",
    // "buycard;点卡购买",
    // "carduse;点卡消耗",
    // "profit;盈利",
    "commission;推广收益",
    "trade;交易",
    "system;系统",
  ];
  RefreshController _refreshController =
      RefreshController(initialRefresh: true);
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  // AssetHistory? _info;
  List<AssetHistory> _infos = [];
  String filter = "";
  double _op = 0;
  late ScrollController _scrollController;

  var style1 = TextStyle(
      color: EColor.second, fontSize: 12, fontWeight: FontWeight.w300);
  var style2 =
      TextStyle(color: EColor.main, fontSize: 13, fontWeight: FontWeight.w600);
  double pad1 = 8;
  double pad2 = 6;

  String getResonString(String reson) {
    return status
        .firstWhere((e) => e.startsWith(reson), orElse: () {
          return ";未知";
        })
        .split(";")
        .last;
  }

  List<AssetHistory> mergaData(
      List<AssetHistory> oldItem, List<AssetHistory> newItem) {
    List<AssetHistory> tmp = oldItem;
    newItem.forEach((e) {
      if (true ==
          oldItem.every((e2) {
            if (e2.iD == e.iD) {
              return false;
            }
            return true;
          })) {
        tmp.add(e);
      }
    });
    tmp.sort((left, right) => right.iD.compareTo(left.iD));
    return tmp;
  }

  Widget _getDefaultItem(BuildContext context, AssetHistory e) {
    return [
      Styled.text("${getResonString(e.reson)}")
          .fontSize(14)
          .bold()
          .textColor(EColor.main)
          .alignment(Alignment.centerLeft)
          .padding(vertical: 8),
      [
        Styled.text("数量(${e.name == 'voucher' ? '点卡' : e.name.toUpperCase()})",
                style: style1)
            .expanded(flex: 1),
        Styled.text("状态", style: style1)
            .alignment(Alignment.center)
            .expanded(flex: 1),
        Styled.text("时间", style: style1)
            .alignment(Alignment.centerRight)
            .expanded(flex: 2)
      ].toRow().padding(top: pad1),
      [
        Styled.text(
          "${e.amount.startsWith("-") ? e.amount : "+" + e.amount}",
          style: style2,
          overflow: TextOverflow.clip,
          maxLines: 1,
        ).expanded(flex: 1),
        Styled.text(
          "已完成",
          style: style2,
          overflow: TextOverflow.clip,
          maxLines: 1,
        )
            // .textColor(Colors.green)
            .alignment(Alignment.center)
            .expanded(flex: 1),
        Styled.text(
          // datefor
          // datefor
          dfmt.formatDate(DateTime.fromMillisecondsSinceEpoch(e.createdAt), [
            dfmt.yyyy,
            "年",
            dfmt.mm,
            "月",
            dfmt.dd,
            " ",
            dfmt.HH,
            ":",
            dfmt.nn
          ]),
          style: style2, overflow: TextOverflow.clip,
          maxLines: 1,
        ).alignment(Alignment.centerRight).expanded(flex: 2)
      ].toRow().padding(top: pad2),
    ].toColumn();
  }

  String _getCommissionFrom(String str, int str2) {
    // var str = meta["from"] as String? ?? "";
    // print("from: $str meta:$meta");
    if (str == "qqfh") {
      if (str2 == 1) {
        return "推广收益 - 分红";
      } else if (str2 == 2) {
        return "推广收益 - 分红";
      } else if (str2 == 3) {
        return "推广收益 - 分红";
      }
    } else if (str == "yjjl") {
      return "推广收益 - 奖金";
    }
    return "推广收益";
  }

  Widget _getCommissionItem(BuildContext context, AssetHistory e) {
    return [
      Styled.text(
              "${_getCommissionFrom(e.meta["from"] as String? ?? "", e.meta["times"] as int? ?? 0)}")
          .fontSize(14)
          .bold()
          .textColor(EColor.main)
          .alignment(Alignment.centerLeft)
          .padding(vertical: 8),
      [
        Styled.text("数量(${e.name == 'voucher' ? '点卡' : e.name.toUpperCase()})",
                style: style1)
            .expanded(flex: 1),
        Styled.text("状态", style: style1)
            .alignment(Alignment.center)
            .expanded(flex: 1),
        Styled.text("时间", style: style1)
            .alignment(Alignment.centerRight)
            .expanded(flex: 2)
      ].toRow().padding(top: pad1),
      [
        Styled.text("${e.amount.startsWith("-") ? e.amount : "+" + e.amount}",
                style: style2)
            .expanded(flex: 1),
        Styled.text("已完成", style: style2)
            // .textColor(Colors.green)
            .alignment(Alignment.center)
            .expanded(flex: 1),
        Styled.text(
                // datefor
                // datefor
                dfmt.formatDate(
                    DateTime.fromMillisecondsSinceEpoch(e.createdAt), [
                  dfmt.yyyy,
                  "年",
                  dfmt.mm,
                  "月",
                  dfmt.dd,
                  " ",
                  dfmt.HH,
                  ":",
                  dfmt.nn
                ]),
                style: style2)
            .alignment(Alignment.centerRight)
            .expanded(flex: 2)
      ].toRow().padding(top: pad2),
    ].toColumn();
  }

  Widget _getBuyGiftItem(BuildContext context, AssetHistory e) {
    return <Widget>[
      Styled.text("${getResonString(e.reson)}")
          .fontSize(14)
          .bold()
          .textColor(EColor.main)
          .alignment(Alignment.centerLeft)
          .padding(vertical: 8),
      [
        Styled.text("数量(${e.name == 'voucher' ? '点卡' : e.name.toUpperCase()})",
                style: style1)
            .expanded(flex: 1),
        Styled.text("状态", style: style1)
            .alignment(Alignment.center)
            .expanded(flex: 1),
        Styled.text("时间", style: style1)
            .alignment(Alignment.centerRight)
            .expanded(flex: 2)
      ].toRow(),
      [
        Styled.text(
          "${e.amount.startsWith("-") ? e.amount : "+" + e.amount}",
          style: style2,
          overflow: TextOverflow.clip,
          maxLines: 1,
        ).expanded(flex: 1),
        Styled.text(
          e.name == 'voucher' ? '已到账' : '已扣除',
          style: style2,
          overflow: TextOverflow.clip,
          maxLines: 1,
        ).alignment(Alignment.center).expanded(flex: 1),
        Styled.text(
          // datefor
          // datefor
          dfmt.formatDate(DateTime.fromMillisecondsSinceEpoch(e.createdAt), [
            dfmt.yyyy,
            "年",
            dfmt.mm,
            "月",
            dfmt.dd,
            " ",
            dfmt.HH,
            ":",
            dfmt.nn
          ]),
          style: style2, overflow: TextOverflow.clip,
          maxLines: 1,
        ).alignment(Alignment.centerRight).expanded(flex: 2)
      ].toRow().padding(top: 3)
    ].toColumn().gestures(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            var j = e.meta;
            showGeneralDialog(
              context: context,
              barrierLabel: "购买详情",
              barrierDismissible: true,
              transitionDuration: Duration(milliseconds: 300),
              pageBuilder: (BuildContext context, Animation animation,
                  Animation secondaryAnimation) {
                return Material(
                  child: Container(
                    width: double.infinity,
                    color: Colors.black.withOpacity(animation.value),
                    child: [
                      Styled.text("点卡购买 - 明细")
                          .fontSize(16)
                          .bold()
                          .padding(vertical: 10),
                      ...(j['title'] as String? ?? '').isEmpty
                          ? <Widget>[]
                          : [
                              Styled.text("套餐名称", style: style1)
                                  .padding(top: pad1),
                              Styled.text(j['title'] as String? ?? '',
                                      style: style2)
                                  .padding(top: pad2)
                            ],
                    ]
                        .toColumn(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start)
                        .padding(all: 16),
                  ),
                ).safeArea().alignment(Alignment.bottomCenter);
              },
            );
          },
        );
  }

  Widget _getWithDrawItem(BuildContext context, AssetHistory e) {
    Map<int, String> _steps = {
      0: "待处理",
      1: "审核中",
      2: "转账中",
      10: "成功",
      11: "失败",
    };
    Map<int, Color> _colors = {
      0: Colors.yellow.shade900,
      1: Colors.yellow.shade900,
      2: Colors.yellow.shade900,
      10: EColor.main,
      11: Colors.red,
    };
    return <Widget>[
      Styled.text("${getResonString(e.reson)}")
          .fontSize(14)
          .bold()
          .textColor(EColor.main)
          .alignment(Alignment.centerLeft)
          .padding(vertical: 8),
      [
        Styled.text("数量(${e.name == 'voucher' ? '点卡' : e.name.toUpperCase()})",
                style: style1)
            .expanded(flex: 1),
        Styled.text("状态", style: style1)
            .alignment(Alignment.center)
            .expanded(flex: 1),
        Styled.text("时间", style: style1)
            .alignment(Alignment.centerRight)
            .expanded(flex: 2)
      ].toRow(),
      [
        Styled.text("${e.amount.startsWith("-") ? e.amount : "+" + e.amount}",
                style: style2)
            .expanded(flex: 1),
        Styled.text(_steps[e.step] ?? "未知", style: style2)
            .textColor(_colors[e.step] ?? EColor.main)
            .alignment(Alignment.center)
            .expanded(flex: 1),
        Styled.text(
                // datefor
                // datefor
                dfmt.formatDate(
                    DateTime.fromMillisecondsSinceEpoch(e.createdAt), [
                  dfmt.yyyy,
                  "年",
                  dfmt.mm,
                  "月",
                  dfmt.dd,
                  " ",
                  dfmt.HH,
                  ":",
                  dfmt.nn
                ]),
                style: style2)
            .alignment(Alignment.centerRight)
            .expanded(flex: 2)
      ].toRow().padding(top: 3)
    ].toColumn().gestures(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            var j = e.meta;
            // print("tx: ${}");
            showGeneralDialog(
              context: context,
              barrierLabel: "提现详情",
              barrierDismissible: true,
              transitionDuration: Duration(milliseconds: 300),
              pageBuilder: (BuildContext context, Animation animation,
                  Animation secondaryAnimation) {
                return Material(
                  child: Container(
                    width: double.infinity,
                    color: Colors.black.withOpacity(animation.value),
                    child: [
                      [
                        Styled.text("提现 - ${_steps[e.step] ?? "未知"}")
                            .fontSize(16)
                            .bold(),
                        e.step == 10
                            ? Container()
                            : IconButton(
                                icon: Icon(Icons.refresh_outlined),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  _refreshController.requestRefresh();
                                })
                      ]
                          .toRow(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween)
                          .padding(vertical: 10),
                      ...[
                        Styled.text("币种")
                            .fontSize(10)
                            .textColor(EColor.placehilder)
                            .padding(top: pad1),
                        Styled.text(e.name.toUpperCase())
                            .textColor(EColor.main)
                            .fontSize(13)
                            .padding(top: pad2)
                      ],
                      ...(j['addr'] as String? ?? '').isEmpty
                          ? <Widget>[]
                          : [
                              Styled.text("目标地址", style: style1)
                                  .padding(top: pad1),
                              Styled.text(j['addr'] as String? ?? '',
                                      style: style2)
                                  .padding(top: pad2)
                            ],
                      ...(j['errtip'] as String? ?? '').isEmpty
                          ? <Widget>[]
                          : [
                              Styled.text("失败提示", style: style1)
                                  .padding(top: pad1),
                              Styled.text(j['errtip'] as String? ?? '')
                                  .textColor(Colors.red)
                                  .fontSize(13)
                                  .padding(top: pad2)
                            ],
                      ...(j['txid'] as String? ?? '').isEmpty
                          ? <Widget>[]
                          : [
                              Styled.text("区块id", style: style1)
                                  .padding(top: pad1),
                              Styled.text(j['txid'] as String? ?? '',
                                      style: style2)
                                  .padding(top: pad2)
                            ],
                      ...((j['txid'] as String? ?? '').isEmpty ||
                              (j['txurl'] as String? ?? '').isEmpty)
                          ? <Widget>[]
                          : [
                              OutlinedButton(
                                      onPressed: () {
                                        WiseLaunchAdapter.go(context,
                                            j['txurl'] as String? ?? '', "转账查询",
                                            openInBrowser: false);
                                      },
                                      child:
                                          Styled.text("查看转账区块详情").fontSize(10)
                                      // .textColor(EColor.placehilder),
                                      )
                                  .padding(vertical: 12)
                            ],
                    ]
                        .toColumn(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start)
                        .padding(all: 16),
                  ),
                ).safeArea().alignment(Alignment.bottomCenter);
              },
            );
          },
        );
  }

  Widget _getRechargeItem(BuildContext context, AssetHistory e) {
    Map<int, String> _steps = {
      0: "确认中",
      1: "到账中",
      // 2: "转账中",
      10: "成功",
      11: "失败",
    };
    Map<int, Color> _colors = {
      0: Colors.yellow.shade900,
      1: Colors.yellow.shade900,
      // 2: Colors.yellow.shade900,
      10: EColor.main,
      11: Colors.red,
    };
    return <Widget>[
      Styled.text("${getResonString(e.reson)}")
          .fontSize(14)
          .bold()
          .textColor(EColor.main)
          .alignment(Alignment.centerLeft)
          .padding(vertical: 8),
      [
        Styled.text("数量(${e.name == 'voucher' ? '点卡' : e.name.toUpperCase()})",
                style: style1)
            .expanded(flex: 1),
        Styled.text("状态", style: style1)
            .alignment(Alignment.center)
            .expanded(flex: 1),
        Styled.text("时间", style: style1)
            .alignment(Alignment.centerRight)
            .expanded(flex: 2)
      ].toRow(),
      [
        Styled.text("${e.amount.startsWith("-") ? e.amount : "+" + e.amount}",
                style: style2)
            .expanded(flex: 1),
        Styled.text(_steps[e.step] ?? "未知", style: style2)
            .textColor(_colors[e.step] ?? EColor.main)
            .alignment(Alignment.center)
            .expanded(flex: 1),
        Styled.text(
                // datefor
                // datefor
                dfmt.formatDate(
                    DateTime.fromMillisecondsSinceEpoch(e.createdAt).toLocal(),
                    [
                      dfmt.yyyy,
                      "年",
                      dfmt.mm,
                      "月",
                      dfmt.dd,
                      " ",
                      dfmt.HH,
                      ":",
                      dfmt.nn
                    ]),
                style: style2)
            .alignment(Alignment.centerRight)
            .expanded(flex: 2)
      ].toRow().padding(top: 3)
    ].toColumn().gestures(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            var j = e.meta;
            // print("tx: ${j}");
            showGeneralDialog(
              context: context,
              barrierLabel: "充值详情",
              barrierDismissible: true,
              transitionDuration: Duration(milliseconds: 300),
              pageBuilder: (BuildContext context, Animation animation,
                  Animation secondaryAnimation) {
                return Material(
                  child: Container(
                    width: double.infinity,
                    color: Colors.black.withOpacity(animation.value),
                    child: [
                      [
                        Styled.text("充值 - ${_steps[e.step] ?? "未知"}")
                            .fontSize(16)
                            .bold()
                            .padding(vertical: 10),
                        e.step == 10
                            ? Container()
                            : IconButton(
                                icon: Icon(Icons.refresh_outlined),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  _refreshController.requestRefresh();
                                })
                      ].toRow(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween),
                      ...[
                        Styled.text("币种")
                            .fontSize(10)
                            .textColor(EColor.placehilder)
                            .padding(top: pad1),
                        Styled.text(e.name.toUpperCase())
                            .textColor(EColor.main)
                            .fontSize(13)
                            .padding(top: pad2)
                      ],
                      ...[
                        Styled.text("确认数")
                            .fontSize(10)
                            .textColor(EColor.placehilder)
                            .padding(top: pad1),
                        Styled.text((j['confirmed'] as int? ?? 0).toString())
                            .textColor(EColor.main)
                            .fontSize(13)
                            .padding(top: pad2)
                      ],
                      ...(j['ts'] as int? ?? 0) == 0
                          ? <Widget>[]
                          : [
                              Styled.text("发起时间", style: style1)
                                  .padding(top: pad1),
                              Styled.text(
                                      dfmt.formatDate(
                                          DateTime.fromMillisecondsSinceEpoch(
                                                  (j['ts'] as int? ?? 0))
                                              .toLocal(),
                                          [
                                            dfmt.yyyy,
                                            "年",
                                            dfmt.mm,
                                            "月",
                                            dfmt.dd,
                                            " ",
                                            dfmt.HH,
                                            ":",
                                            dfmt.nn,
                                            ":",
                                            dfmt.ss
                                          ]),
                                      style: style2)
                                  .padding(top: pad2)
                            ],
                      ...(j['fromAddr'] as String? ?? '').isEmpty
                          ? <Widget>[]
                          : [
                              Styled.text("发送地址", style: style1)
                                  .padding(top: pad1),
                              Styled.text(j['fromAddr'] as String? ?? '',
                                      style: style2)
                                  .padding(top: pad2)
                            ],
                      ...(j['addr'] as String? ?? '').isEmpty
                          ? <Widget>[]
                          : [
                              Styled.text("收款地址", style: style1)
                                  .padding(top: pad1),
                              Styled.text(j['addr'] as String? ?? '',
                                      style: style2)
                                  .padding(top: pad2)
                            ],
                      ...(j['reqTime'] as int? ?? 0) == 0
                          ? <Widget>[]
                          : [
                              Styled.text("发起时间", style: style1)
                                  .padding(top: pad1),
                              Styled.text(
                                      dfmt.formatDate(
                                          DateTime.fromMillisecondsSinceEpoch(
                                                  (j['reqTime'] as int? ?? 0) *
                                                      1000)
                                              .toLocal(),
                                          [
                                            dfmt.yyyy,
                                            "年",
                                            dfmt.mm,
                                            "月",
                                            dfmt.dd,
                                            " ",
                                            dfmt.HH,
                                            ":",
                                            dfmt.nn,
                                            ":",
                                            dfmt.ss
                                          ]),
                                      style: style2)
                                  .padding(top: pad2)
                            ],
                      ...(j['errtip'] as String? ?? '').isEmpty
                          ? <Widget>[]
                          : [
                              Styled.text("失败提示", style: style1)
                                  .padding(top: pad1),
                              Styled.text(j['errtip'] as String? ?? '')
                                  .textColor(Colors.red)
                                  .fontSize(13)
                                  .padding(top: pad2)
                            ],
                      ...(j['txid'] as String? ?? '').isEmpty
                          ? <Widget>[]
                          : [
                              Styled.text("区块id", style: style1)
                                  .padding(top: pad1),
                              Styled.text(j['txid'] as String? ?? '',
                                      style: style2)
                                  .padding(top: pad2)
                            ],
                      ...((j['txid'] as String? ?? '').isEmpty ||
                              (j['txurl'] as String? ?? '').isEmpty)
                          ? <Widget>[]
                          : [
                              OutlinedButton(
                                      onPressed: () {
                                        WiseLaunchAdapter.go(context,
                                            j['txurl'] as String? ?? '', "转账查询",
                                            openInBrowser: false);
                                      },
                                      child:
                                          Styled.text("查看转账区块详情").fontSize(10)
                                      // .textColor(EColor.placehilder),
                                      )
                                  .padding(vertical: 12)
                            ],
                    ]
                        .toColumn(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start)
                        .padding(all: 16),
                  ),
                ).safeArea().alignment(Alignment.bottomCenter);
              },
            );
          },
        );
  }

  Widget _getItem(BuildContext context, AssetHistory item) {
    switch (item.reson) {
      case "buycard":
        return _getBuyGiftItem(context, item);
      case "recharge":
        return _getRechargeItem(context, item);
      case "withdraw":
        return _getWithDrawItem(context, item);
      case "commission":
        return _getCommissionItem(context, item);
      default:
        return _getDefaultItem(context, item);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Opacity(
          opacity: _op,
          child: Text(
            "资产明细",
          ),
        ),
        actions: [
          IconButton(
              icon: Icon(
                Icons.filter_alt_outlined,
                color: Theme.of(context).primaryColor,
              ),
              onPressed: () {
                if (_refreshController.isLoading ||
                    _refreshController.isLoading) {
                  return;
                }
                showCupertinoModalPopup(
                    context: context,
                    builder: (ctx) {
                      return CupertinoActionSheet(
                          cancelButton: CupertinoActionSheetAction(
                            onPressed: () {
                              Navigator.pop(ctx);
                            },
                            child: Styled.text("取消").textColor(EColor.second),
                          ),
                          actions: status
                              .map((e) => CupertinoActionSheetAction(
                                    onPressed: () {
                                      setState(() {
                                        filter = e.split(";").first;
                                        _infos = [];
                                      });
                                      Navigator.of(ctx).pop();
                                      _refreshController.resetNoData();
                                      _refreshController.requestRefresh();
                                    },
                                    child: Styled.text(e.split(";").last)
                                        .textColor(e.split(";").first == filter
                                            ? Theme.of(context).primaryColor
                                            : EColor.second),
                                  ))
                              .toList());
                    });
              })
        ],
      ),
      body: SmartRefresher(
          enablePullDown: true,
          enablePullUp: true,
          physics: AlwaysScrollableScrollPhysics(),
          // header: WaterDropHeader(),
          // header: ,
          footer: CustomFooter(
            // loadStyle: LoadStyle.ShowWhenLoading,
            loadStyle: LoadStyle.ShowAlways,
            builder: (BuildContext context, LoadStatus? mode) {
              // Widget body;
              if (mode == LoadStatus.idle) {
                // body = Text("pull up load");
                return [
                  Styled.icon(Icons.arrow_downward,
                      color: EColor.second, size: 13),
                  Styled.text("上拉刷新").textColor(EColor.second).fontSize(13)
                ].toRow(mainAxisAlignment: MainAxisAlignment.center).height(50);
              } else if (mode == LoadStatus.loading) {
                return [
                  SpinKitThreeBounce(
                      size: 13, color: Theme.of(context).primaryColor),
                  Styled.text("加载中...")
                      .textColor(Theme.of(context).primaryColor)
                      .fontSize(13)
                ].toRow(mainAxisAlignment: MainAxisAlignment.center).height(50);
              } else if (mode == LoadStatus.failed) {
                // body = Text("Load Failed!Click retry!");
                return Styled.text("加载失败")
                    .textColor(EColor.second)
                    .center()
                    .height(50);
              } else if (mode == LoadStatus.canLoading) {
                return [
                  SpinKitThreeBounce(
                      size: 13, color: Theme.of(context).primaryColor),
                  Styled.text("加载中...")
                      .textColor(Theme.of(context).primaryColor)
                      .fontSize(13)
                ].toRow(mainAxisAlignment: MainAxisAlignment.center).height(50);
              } else {
                // body = Text("No more Data");
                return Styled.text("没有更多数据")
                    .fontSize(13)
                    .textColor(EColor.second)
                    .center()
                    .height(50);
              }
            },
          ),
          controller: _refreshController,
          scrollController: _scrollController,
          onRefresh: () async {
            if (_refreshController.isLoading) {
              _refreshController.refreshToIdle();
              return;
            }
            await DioAdapter().assetHistory(0, filter).then((res) {
              if (!mounted || res.canced) {
                return;
              } else if (res.code != 0) {
                _refreshController.refreshFailed();
                toast(res.msg);
                // ScaffoldMessenger.maybeOf(context)?.hideCurrentSnackBar();
                // ScaffoldMessenger.maybeOf(context)
                //     ?.showSnackBar(SnackBar(content: Text("刷新失败，请检查网络")));
                // alert(context, res.msg, cb: () => Navigator.of(context).pop());
                return;
              }
              if (res.msg != "") {
                toast(res.msg);
                // ScaffoldMessenger.maybeOf(context)?.hideCurrentSnackBar();
                // ScaffoldMessenger.maybeOf(context)?.showSnackBar(
                //     SnackBar(content: Styled.text(res.msg).fontSize(13)));
              }
              setState(() {
                // _infos = mergaData(_infos, value.items);
                _infos = res.data ?? [];
              });
              if (_infos.length < 20) {
                _refreshController.loadNoData();
              }
              _refreshController.refreshCompleted();
            });
          },
          onLoading: () async {
            if (_refreshController.isRefresh) {
              _refreshController.loadComplete();
              return;
            }
            // await Future.delayed(Duration(milliseconds: 3000));
            int _min = 99999999999;
            if ((_infos).length == 0) {
              _min = 0;
            } else {
              _infos.forEach((e) {
                if (e.iD < _min) {
                  _min = e.iD;
                }
              });
            }
            // print("min: $_min");
            await DioAdapter().assetHistory(_min, filter).then((res) {
              if (!mounted || res.canced) {
                return;
              } else if (res.code != 0) {
                _refreshController.refreshFailed();
                toast(res.msg);
                // ScaffoldMessenger.maybeOf(context)?.hideCurrentSnackBar();
                // ScaffoldMessenger.maybeOf(context)
                //     ?.showSnackBar(SnackBar(content: Text("刷新失败，请检查网络")));
                // alert(context, res.msg, cb: () => Navigator.of(context).pop());
                return;
              }
              if (res.msg != "") {
                toast(res.msg);
                // ScaffoldMessenger.maybeOf(context)?.hideCurrentSnackBar();
                // ScaffoldMessenger.maybeOf(context)?.showSnackBar(
                //     SnackBar(content: Styled.text(res.msg).fontSize(13)));
              }
              setState(() {
                _infos = mergaData(_infos, res.data ?? []);
              });
              if (_infos.length < 20) {
                _refreshController.loadNoData();
              } else {
                _refreshController.loadComplete();
              }
            });
          },
          child: [
            [
              Styled.text("资产明细")
                  .textColor(Theme.of(context).primaryColor)
                  .fontSize(24)
                  .bold(),
              Styled.text(status
                      .firstWhere((e) => e.startsWith(filter), orElse: () {
                        return ';';
                      })
                      .split(';')
                      .last
                      .replaceAll("全部", ""))
                  .fontSize(13)
                  .textColor(EColor.main)
                  .bold()
                  // .textColor(Theme.of(context).primaryColor.withOpacity(0.8))
                  .padding(left: 5)
            ]
                .toRow()
                .height(50)
                .padding(left: 15)
                .backgroundColor(Colors.white),
            ..._infos
                .map((e) => _getItem(context, e)
                    .padding(all: 8)
                    .border(bottom: 1, color: EColor.border3)
                    .backgroundColor(Colors.white))
                .toList(),
            SizedBox(height: MediaQuery.of(context).padding.bottom)
          ].toColumn().scrollable(
              // physics: AlwaysScrollableScrollPhysics(),
              )),
    );
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    if (widget.defaultReson != null &&
        widget.defaultReson!.isNotEmpty &&
        status
                .where((e) => e.contains("${widget.defaultReson!};"))
                .toSet()
                .length !=
            0) {
      filter = widget.defaultReson!;
    }
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _scrollController.addListener(() {
        var tmp2 =
            (max(min(_scrollController.offset - 20, 50 - 20), 0) / (50 - 20));
        // print("tmp2: $tmp2 off:${_scrollController.offset}");
        if (_op != tmp2) {
          setState(() {
            _op = tmp2;
          });
        }
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
