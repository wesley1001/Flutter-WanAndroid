import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/components/disclaimer_msg.dart';
import 'package:flutter_wanandroid/components/list_view_item.dart';
import 'package:flutter_wanandroid/components/list_refresh.dart' as listComp;
import 'package:flutter_wanandroid/components/pagination.dart';
import 'package:flutter_wanandroid/components/search_input.dart';
import 'package:shared_preferences/shared_preferences.dart';



// ValueKey<String> key;

class HomePage extends StatefulWidget {
  @override
  FirstPageState createState() => new FirstPageState();
}

class FirstPageState extends State<HomePage> with AutomaticKeepAliveClientMixin{
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Future<bool> _unKnow;
  GlobalKey<DisclaimerMsgState> key;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    if (key == null) {
      key = GlobalKey<DisclaimerMsgState>();
      // key = const Key('__RIKEY1__');
      //获取sharePre
      _unKnow = _prefs.then((SharedPreferences prefs) {
        return (prefs.getBool('disclaimer::Boolean') ?? false);
      });

      /// 判断是否需要弹出免责声明,已经勾选过不在显示,就不会主动弹
      _unKnow.then((bool value) {
        new Future.delayed(const Duration(seconds: 1),(){
          if (!value) {
            key.currentState.showAlertDialog(context);
          }
        });
      });
    }
  }


  /// 列表中的卡片item
  Widget makeCard(index,item){

    var mId = item.id;
    var mTitle = '${item.title}';
    var mShareUserName = '${'👲'}: ${item.shareUser} ';

    if(item.shareUser == ""){
      mShareUserName = '${'👲'}: ${item.author} ';
    }
    var mLikeUrl = '${item.link}';
    var mNiceDate = '${'🔔'}: ${item.niceDate}';
    return new ListViewItem(itemId: mId, itemTitle: mTitle, itemUrl:mLikeUrl,itemShareUser: mShareUserName, itemNiceDate: mNiceDate);
  }

  /// banner
  headerView(){
    return
      Column(
        children: <Widget>[
          Stack(
            //alignment: const FractionalOffset(0.9, 0.1),//方法一
              children: <Widget>[
                // banner
                Pagination(),
                Positioned(//方法二
                    top: 10.0,
                    left: 0.0,
                    child: DisclaimerMsg(key:key,pWidget:this)
                ),
              ]),
          SizedBox(height: 1, child:Container(color: Theme.of(context).primaryColor)),
          SizedBox(height: 10),
        ],
      );

  }
  /// TODO 抽取出去 联想搜索，显示搜索结果列表
  Widget buildSearchInput(BuildContext context){
    return new SearchInput((value)  async{
      if (value != '') {
        // TODO 发起网络请求，搜索结果
        print("---------------->>>>>>>"+value);
        // List<WidgetPoint> list = await widgetControl.search(value);

        // return list
        //     .map((item) => new MaterialSearchResult<String>(
        //           value: item.name,
        //           icon: WidgetName2Icon.icons[item.name] ?? null,
        //           text: 'widget',
        //           onTap: () {
        //             // item 点击
        //             onWidgetTap(item, context);
        //           },
        //         ))
        //     .toList();
      } else {
        return null;
      }
    }, (value){},(){});
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: new AppBar(title: buildSearchInput(context),),
      body: new Column(
          children: <Widget>[
//          new Stack(
            //alignment: const FractionalOffset(0.9, 0.1),//方法一
//            children: <Widget>[
//            Pagination(),
//            Positioned(//方法二
//              top: 10.0,
//              left: 0.0,
//              child: DisclaimerMsg(key:key,pWidget:this)
//            ),
//          ]),
            SizedBox(height: 2, child:Container(color: Theme.of(context).primaryColor)),
            new Expanded(
              //child: new List(),
                child: listComp.ListRefresh(makeCard,headerView)
            )
          ]

      ),
    );
  }
}


