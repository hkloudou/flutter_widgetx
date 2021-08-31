part of './AssetHistoryPage.dart';

List<AssetsHistoryPageSlot> defaultUaserAssetHistorySlots = [
  AssetsHistoryPageSlot(),
  AssetsHistoryPageSlot(filter: "recharge", cn: "充值"),
  AssetsHistoryPageSlot(filter: "withdraw", cn: "提现"),
  // AssetsHistoryPageSlot(filter: "commission", cn: "推广收益"),
  // AssetsHistoryPageSlot(filter: "safetybond", cn: "保障金"),
  AssetsHistoryPageSlot(filter: "system", cn: "系统"),
];

Widget _getDefaultItem(
    BuildContext context, String filter, String cn, AssetHistory e) {
  var style1 = TextStyle(
      color: EColor.second, fontSize: 12, fontWeight: FontWeight.w300);
  var style2 =
      TextStyle(color: EColor.main, fontSize: 13, fontWeight: FontWeight.w600);
  double pad1 = 8;
  double pad2 = 6;
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
