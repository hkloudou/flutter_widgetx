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
part 'AssetHistoryPageSlot.dart';

class AssetsHistoryPageSlot extends Object {
  final String filter;
  final String cn;
  final Widget Function(
          BuildContext context, String filter, String cn, AssetHistory his)?
      callBack;
  AssetsHistoryPageSlot({this.filter = "", this.cn = "全部", this.callBack});

  String toString() {
    return "$filter:$cn";
  }
}

class AssetsHistoryPage extends StatefulWidget {
  AssetsHistoryPage({this.defaultReson, Key? key, this.status = const []})
      : super(key: key) {
    if (this.status.length == 0) {
      this.status = defaultSlot;
    }
  }
  @override
  State<StatefulWidget> createState() {
    return new _AssetsHistoryPageState();
  }

  final String? defaultReson;
  List<AssetsHistoryPageSlot> status;
}

class _AssetsHistoryPageState extends State<AssetsHistoryPage> {
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

  Widget _getItem(BuildContext context, AssetHistory item) {
    var obj = widget.status.singleWhere((e) => e.filter == item.reson,
        orElse: () => AssetsHistoryPageSlot(filter: "", cn: ""));
    return (obj.callBack ?? _getDefaultItem)
        .call(context, obj.filter, obj.cn, item);
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
                          actions: widget.status
                              .map((e) => CupertinoActionSheetAction(
                                    onPressed: () {
                                      setState(() {
                                        filter = e.filter;
                                        _infos = [];
                                      });
                                      Navigator.of(ctx).pop();
                                      _refreshController.resetNoData();
                                      _refreshController.requestRefresh();
                                    },
                                    child: Styled.text(e.cn).textColor(
                                        e.filter == filter
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
              Styled.text(widget.status
                      .firstWhere((e) => e.filter == filter, orElse: () {
                        return AssetsHistoryPageSlot();
                      })
                      .cn
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
        widget.status
                .where((e) => e.filter.contains("${widget.defaultReson!};"))
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
