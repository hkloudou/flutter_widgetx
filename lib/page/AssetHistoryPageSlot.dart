part of './AssetHistoryPage.dart';

List<AssetsHistoryPageSlot> defaultUaserAssetHistorySlots = [
  AssetsHistoryPageSlot(),
  AssetsHistoryPageSlot(filter: "recharge", cn: "充值"),
  AssetsHistoryPageSlot(filter: "withdraw", cn: "提现"),
  // AssetsHistoryPageSlot(filter: "commission", cn: "推广收益"),
  // AssetsHistoryPageSlot(filter: "safetybond", cn: "保障金"),
  AssetsHistoryPageSlot(filter: "system", cn: "系统"),
];
var style1 =
    TextStyle(color: EColor.second, fontSize: 12, fontWeight: FontWeight.w300);
var style2 =
    TextStyle(color: EColor.main, fontSize: 13, fontWeight: FontWeight.w600);
double pad1 = 8;
double pad2 = 6;
Widget _getDefaultItem(
    BuildContext context, String filter, String cn, AssetHistory e) {
  return [
    Styled.text("$cn")
        .fontSize(14)
        .bold()
        .textColor(EColor.main)
        .alignment(Alignment.centerLeft)
        .padding(vertical: 8),
    [
      Styled.text("数量(${EConfig.getAssetName(e.asset).toUpperCase()})",
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

// String _getCommissionFrom(String str, int str2) {
//   // var str = meta["from"] as String? ?? "";
//   // print("from: $str meta:$meta");
//   if (str == "qqfh") {
//     if (str2 == 1) {
//       return "推广收益 - 分红";
//     } else if (str2 == 2) {
//       return "推广收益 - 分红";
//     } else if (str2 == 3) {
//       return "推广收益 - 分红";
//     }
//   } else if (str == "yjjl") {
//     return "推广收益 - 奖金";
//   }
//   return "推广收益";
// }

// Widget _getCommissionItem(BuildContext context, AssetHistory e) {
//   return [
//     Styled.text(
//             "${_getCommissionFrom(e.meta["from"] as String? ?? "", e.meta["times"] as int? ?? 0)}")
//         .fontSize(14)
//         .bold()
//         .textColor(EColor.main)
//         .alignment(Alignment.centerLeft)
//         .padding(vertical: 8),
//     [
//       Styled.text("数量(${e.name == 'voucher' ? '点卡' : e.name.toUpperCase()})",
//               style: style1)
//           .expanded(flex: 1),
//       Styled.text("状态", style: style1)
//           .alignment(Alignment.center)
//           .expanded(flex: 1),
//       Styled.text("时间", style: style1)
//           .alignment(Alignment.centerRight)
//           .expanded(flex: 2)
//     ].toRow().padding(top: pad1),
//     [
//       Styled.text("${e.amount.startsWith("-") ? e.amount : "+" + e.amount}",
//               style: style2)
//           .expanded(flex: 1),
//       Styled.text("已完成", style: style2)
//           // .textColor(Colors.green)
//           .alignment(Alignment.center)
//           .expanded(flex: 1),
//       Styled.text(
//               // datefor
//               // datefor
//               dfmt.formatDate(
//                   DateTime.fromMillisecondsSinceEpoch(e.createdAt), [
//                 dfmt.yyyy,
//                 "年",
//                 dfmt.mm,
//                 "月",
//                 dfmt.dd,
//                 " ",
//                 dfmt.HH,
//                 ":",
//                 dfmt.nn
//               ]),
//               style: style2)
//           .alignment(Alignment.centerRight)
//           .expanded(flex: 2)
//     ].toRow().padding(top: pad2),
//   ].toColumn();
// }

// Widget _getBuyGiftItem(BuildContext context, AssetHistory e) {
//   return <Widget>[
//     Styled.text("${getResonString(e.reson)}")
//         .fontSize(14)
//         .bold()
//         .textColor(EColor.main)
//         .alignment(Alignment.centerLeft)
//         .padding(vertical: 8),
//     [
//       Styled.text("数量(${e.name == 'voucher' ? '点卡' : e.name.toUpperCase()})",
//               style: style1)
//           .expanded(flex: 1),
//       Styled.text("状态", style: style1)
//           .alignment(Alignment.center)
//           .expanded(flex: 1),
//       Styled.text("时间", style: style1)
//           .alignment(Alignment.centerRight)
//           .expanded(flex: 2)
//     ].toRow(),
//     [
//       Styled.text(
//         "${e.amount.startsWith("-") ? e.amount : "+" + e.amount}",
//         style: style2,
//         overflow: TextOverflow.clip,
//         maxLines: 1,
//       ).expanded(flex: 1),
//       Styled.text(
//         e.name == 'voucher' ? '已到账' : '已扣除',
//         style: style2,
//         overflow: TextOverflow.clip,
//         maxLines: 1,
//       ).alignment(Alignment.center).expanded(flex: 1),
//       Styled.text(
//         // datefor
//         // datefor
//         dfmt.formatDate(DateTime.fromMillisecondsSinceEpoch(e.createdAt), [
//           dfmt.yyyy,
//           "年",
//           dfmt.mm,
//           "月",
//           dfmt.dd,
//           " ",
//           dfmt.HH,
//           ":",
//           dfmt.nn
//         ]),
//         style: style2, overflow: TextOverflow.clip,
//         maxLines: 1,
//       ).alignment(Alignment.centerRight).expanded(flex: 2)
//     ].toRow().padding(top: 3)
//   ].toColumn().gestures(
//         behavior: HitTestBehavior.opaque,
//         onTap: () {
//           var j = e.meta;
//           showGeneralDialog(
//             context: context,
//             barrierLabel: "购买详情",
//             barrierDismissible: true,
//             transitionDuration: Duration(milliseconds: 300),
//             pageBuilder: (BuildContext context, Animation animation,
//                 Animation secondaryAnimation) {
//               return Material(
//                 child: Container(
//                   width: double.infinity,
//                   color: Colors.black.withOpacity(animation.value),
//                   child: [
//                     Styled.text("点卡购买 - 明细")
//                         .fontSize(16)
//                         .bold()
//                         .padding(vertical: 10),
//                     ...(j['title'] as String? ?? '').isEmpty
//                         ? <Widget>[]
//                         : [
//                             Styled.text("套餐名称", style: style1)
//                                 .padding(top: pad1),
//                             Styled.text(j['title'] as String? ?? '',
//                                     style: style2)
//                                 .padding(top: pad2)
//                           ],
//                   ]
//                       .toColumn(
//                           mainAxisSize: MainAxisSize.min,
//                           crossAxisAlignment: CrossAxisAlignment.start)
//                       .padding(all: 16),
//                 ),
//               ).safeArea().alignment(Alignment.bottomCenter);
//             },
//           );
//         },
//       );
// }

// Widget _getWithDrawItem(BuildContext context, AssetHistory e) {
//   Map<int, String> _steps = {
//     0: "待处理",
//     1: "审核中",
//     2: "转账中",
//     10: "成功",
//     11: "失败",
//   };
//   Map<int, Color> _colors = {
//     0: Colors.yellow.shade900,
//     1: Colors.yellow.shade900,
//     2: Colors.yellow.shade900,
//     10: EColor.main,
//     11: Colors.red,
//   };
//   return <Widget>[
//     Styled.text("${getResonString(e.reson)}")
//         .fontSize(14)
//         .bold()
//         .textColor(EColor.main)
//         .alignment(Alignment.centerLeft)
//         .padding(vertical: 8),
//     [
//       Styled.text("数量(${e.name == 'voucher' ? '点卡' : e.name.toUpperCase()})",
//               style: style1)
//           .expanded(flex: 1),
//       Styled.text("状态", style: style1)
//           .alignment(Alignment.center)
//           .expanded(flex: 1),
//       Styled.text("时间", style: style1)
//           .alignment(Alignment.centerRight)
//           .expanded(flex: 2)
//     ].toRow(),
//     [
//       Styled.text("${e.amount.startsWith("-") ? e.amount : "+" + e.amount}",
//               style: style2)
//           .expanded(flex: 1),
//       Styled.text(_steps[e.step] ?? "未知", style: style2)
//           .textColor(_colors[e.step] ?? EColor.main)
//           .alignment(Alignment.center)
//           .expanded(flex: 1),
//       Styled.text(
//               // datefor
//               // datefor
//               dfmt.formatDate(
//                   DateTime.fromMillisecondsSinceEpoch(e.createdAt), [
//                 dfmt.yyyy,
//                 "年",
//                 dfmt.mm,
//                 "月",
//                 dfmt.dd,
//                 " ",
//                 dfmt.HH,
//                 ":",
//                 dfmt.nn
//               ]),
//               style: style2)
//           .alignment(Alignment.centerRight)
//           .expanded(flex: 2)
//     ].toRow().padding(top: 3)
//   ].toColumn().gestures(
//         behavior: HitTestBehavior.opaque,
//         onTap: () {
//           var j = e.meta;
//           // print("tx: ${}");
//           showGeneralDialog(
//             context: context,
//             barrierLabel: "提现详情",
//             barrierDismissible: true,
//             transitionDuration: Duration(milliseconds: 300),
//             pageBuilder: (BuildContext context, Animation animation,
//                 Animation secondaryAnimation) {
//               return Material(
//                 child: Container(
//                   width: double.infinity,
//                   color: Colors.black.withOpacity(animation.value),
//                   child: [
//                     [
//                       Styled.text("提现 - ${_steps[e.step] ?? "未知"}")
//                           .fontSize(16)
//                           .bold(),
//                       e.step == 10
//                           ? Container()
//                           : IconButton(
//                               icon: Icon(Icons.refresh_outlined),
//                               onPressed: () {
//                                 Navigator.of(context).pop();
//                                 _refreshController.requestRefresh();
//                               })
//                     ]
//                         .toRow(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween)
//                         .padding(vertical: 10),
//                     ...[
//                       Styled.text("币种")
//                           .fontSize(10)
//                           .textColor(EColor.placehilder)
//                           .padding(top: pad1),
//                       Styled.text(e.name.toUpperCase())
//                           .textColor(EColor.main)
//                           .fontSize(13)
//                           .padding(top: pad2)
//                     ],
//                     ...(j['addr'] as String? ?? '').isEmpty
//                         ? <Widget>[]
//                         : [
//                             Styled.text("目标地址", style: style1)
//                                 .padding(top: pad1),
//                             Styled.text(j['addr'] as String? ?? '',
//                                     style: style2)
//                                 .padding(top: pad2)
//                           ],
//                     ...(j['errtip'] as String? ?? '').isEmpty
//                         ? <Widget>[]
//                         : [
//                             Styled.text("失败提示", style: style1)
//                                 .padding(top: pad1),
//                             Styled.text(j['errtip'] as String? ?? '')
//                                 .textColor(Colors.red)
//                                 .fontSize(13)
//                                 .padding(top: pad2)
//                           ],
//                     ...(j['txid'] as String? ?? '').isEmpty
//                         ? <Widget>[]
//                         : [
//                             Styled.text("区块id", style: style1)
//                                 .padding(top: pad1),
//                             Styled.text(j['txid'] as String? ?? '',
//                                     style: style2)
//                                 .padding(top: pad2)
//                           ],
//                     ...((j['txid'] as String? ?? '').isEmpty ||
//                             (j['txurl'] as String? ?? '').isEmpty)
//                         ? <Widget>[]
//                         : [
//                             OutlinedButton(
//                                     onPressed: () {
//                                       WiseLaunchAdapter.go(context,
//                                           j['txurl'] as String? ?? '', "转账查询",
//                                           openInBrowser: false);
//                                     },
//                                     child: Styled.text("查看转账区块详情").fontSize(10)
//                                     // .textColor(EColor.placehilder),
//                                     )
//                                 .padding(vertical: 12)
//                           ],
//                   ]
//                       .toColumn(
//                           mainAxisSize: MainAxisSize.min,
//                           crossAxisAlignment: CrossAxisAlignment.start)
//                       .padding(all: 16),
//                 ),
//               ).safeArea().alignment(Alignment.bottomCenter);
//             },
//           );
//         },
//       );
// }

Widget getRechargeUserAssetHistoryDefaultItem(
    BuildContext context, String filter, String cn, AssetHistory e) {
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
    Styled.text("$cn")
        .fontSize(14)
        .bold()
        .textColor(EColor.main)
        .alignment(Alignment.centerLeft)
        .padding(vertical: 8),
    [
      Styled.text("数量(${e.asset.toUpperCase()})", style: style1)
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
                  DateTime.fromMillisecondsSinceEpoch(e.createdAt).toLocal(), [
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
                      // e.step == 10
                      //     ? Container()
                      //     : IconButton(
                      //         icon: Icon(Icons.refresh_outlined),
                      //         onPressed: () {
                      //           Navigator.of(context).pop();
                      //           _refreshController.requestRefresh();
                      //         })
                    ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween),
                    ...[
                      Styled.text("币种")
                          .fontSize(10)
                          .textColor(EColor.placehilder)
                          .padding(top: pad1),
                      Styled.text(e.asset.toUpperCase())
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
                                    child: Styled.text("查看转账区块详情").fontSize(10)
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
