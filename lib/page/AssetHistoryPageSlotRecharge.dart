part of './AssetHistoryPage.dart';

Widget getRechargeUserAssetHistoryDefaultItem(
    BuildContext context, String filter, String cn, AssetHistory e) {
  var style1 = TextStyle(
      color: EColor.second, fontSize: 12, fontWeight: FontWeight.w300);
  var style2 =
      TextStyle(color: EColor.main, fontSize: 13, fontWeight: FontWeight.w600);
  double pad1 = 8;
  double pad2 = 6;
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
      Styled.text("完成", style: style2)
          .textColor(EColor.main)
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
                      Styled.text("充值 - 完成")
                          .fontSize(16)
                          .bold()
                          .padding(vertical: 10),
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
