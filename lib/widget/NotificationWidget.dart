import 'package:corex/corex.dart';
import 'package:flutter_vertical_marquee/flutter_vertical_marquee.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';
import 'package:styled_widget/styled_widget.dart';
import '../page/SimpleNotificationCenterPage.dart';
// ignore: implementation_imports
import 'package:corex/src/entrys/cfg_simple_notification.dart';

class NotificationWidget extends StatelessWidget {
  const NotificationWidget({
    Key? key,
    this.iconColor = Colors.grey,
    this.textColor = Colors.black,
    this.iconSize = 18,
    this.fontSize = 12,
    this.items,
  }) : super(key: key);
  final Color iconColor;
  final Color textColor;
  final double iconSize;
  final double fontSize;
  final List<CfgSimpleNotificationItem>? items;
  @override
  Widget build(BuildContext context) {
    return Consumer<CfgSimpleNotificationStatus>(builder: (_, a, child) {
      if (!a.ready || a.items.length == 0) {
        return Styled.widget();
      }
      var notices = a.items;
      if (items != null) {
        notices = items ?? [];
      }
      var controller = MarqueeController();
      List<String> str = notices.map((e) => e.title).toList();
      return [
        Styled.icon(
          Icons.campaign,
          size: iconSize,
          color: iconColor,
        ).padding(all: 3),
        Marquee(
          textList:
              str, // List<Text>, textList and textSpanList can only have one of code.
          fontSize: fontSize, // text size
          scrollDuration: Duration(seconds: 1), // every scroll duration
          stopDuration: Duration(seconds: 3), //every stop duration
          tapToNext: false, // tap to next
          textColor: textColor, // text color
          controller: controller, // the controller can get the position
        )
            .gestures(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  var pos = controller.position;
                  if (pos >= notices.length || pos < 0) {
                    return;
                  }
                  WiseLaunchAdapter.go(
                      context, notices[pos].href, notices[pos].title,
                      replace: false, openInBrowser: false);
                })
            .height(36)
            .expanded(),
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: Styled.icon(
            Icons.menu,
            size: iconSize,
            color: iconColor,
          ).padding(left: 10).gestures(
              behavior: HitTestBehavior.opaque,
              onTap: () =>
                  showAnimatePage(context, SimpleNotificationCenterPage())),
        ),
      ].toRow();
    });
  }
}
