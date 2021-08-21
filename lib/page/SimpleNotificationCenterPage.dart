import 'package:corex/corex.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:date_format/date_format.dart' as dfmt;

// import '../status/CfgSimpleNotificationStatus.dart';

//SimpleNotificationCenterPage 简单用户通知中心模块
class SimpleNotificationCenterPage extends StatelessWidget {
  SimpleNotificationCenterPage();
  //
  // CfgSimpleNotificationStatus
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Styled.text("公告中心"),
      ),
      body: Consumer<CfgSimpleNotificationStatus>(
        builder: (_, a, child) {
          return [
            ...a.items
                .map((e) => [
                      [
                        Styled.text(
                            dfmt.formatDate(
                                DateTime.fromMillisecondsSinceEpoch(
                                    e.updatedAt),
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
                            style: TextStyle(fontSize: 12)),
                        e.href.isEmpty
                            ? Container()
                            : Styled.text("详情").fontSize(12),
                      ]
                          .toRow(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween)
                          .padding(all: 12, bottom: 0),
                      Styled.text(e.title, overflow: TextOverflow.ellipsis)
                          .fontSize(13)
                          .bold()
                          .alignment(Alignment.centerLeft)
                          .padding(all: 12),
                    ]
                        .toColumn()
                        .ripple()
                        .backgroundColor(Colors.white)
                        .clipRRect(all: 5) // clip ripple
                        .borderRadius(all: 5)
                        .elevation(
                          20,
                          borderRadius: BorderRadius.circular(25),
                          shadowColor: Color(0x30000000),
                        )
                        .gestures(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              WiseLaunchAdapter.go(
                                context,
                                e.href,
                                e.title,
                                openInBrowser: false,
                              );
                            })
                        .padding(top: 16)
                        .animate(Duration(milliseconds: 150), Curves.easeOut))
                .toList()
          ].toColumn();
        },
      ).scrollable(),
    );
  }
}
