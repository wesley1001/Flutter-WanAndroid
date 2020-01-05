import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/api/common_service.dart';
import 'package:flutter_wanandroid/components/cate_card.dart';
import 'package:flutter_wanandroid/components/search_input.dart';
import 'package:flutter_wanandroid/model/cat.dart';
import 'package:flutter_wanandroid/model/navi_bean.dart';

/// 猫耳布局
/// 展示 体系、项目、导航 三大分类
/// 作者：龙衣

class CatPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new CatPageState();
  }
}

class CatPageState extends State<CatPage> with AutomaticKeepAliveClientMixin {
  TextEditingController controller;
  String active = 'test';
  String data = '无';

  List<Cat> categorieTrees = [];
  List<Cat> categorieProjects = [];
  List<NaviData> categorieNavs = [];

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _getCatPageData();
  }

  void _getCatPageData() {
    if (!mounted) {
      return;
    }
    /// 获取体系数据
    CommonService().getSystemTree((CatModel catModel) {
      categorieTrees.addAll(catModel.data);
      setState(() {
        categorieTrees = categorieTrees;
      });
    });
    /// 获取导航数据
    CommonService().getNaviList((NaviBeanModel naviBean) {
      print("获取导航列表数据========>>> ："+naviBean.datas.toString());
      categorieNavs.addAll(naviBean.datas);
      setState(() {
        categorieNavs = categorieNavs;
      });
    });
    /// 获取项目数据
    CommonService().getProjectTree((CatModel catModel) {
      categorieProjects.addAll(catModel.data);
      setState(() {
        categorieProjects = categorieProjects;
      });
    });
  }

  /// 构建网格布局
  Widget buildGrid() {
    // 存放最后的widget
    List<Widget> tiles = [];
    tiles.add(new CateCard(category: "体系", categorieLists: categorieTrees,naviLists: categorieNavs));
    tiles.add(new CateCard(category: "导航", categorieLists: categorieTrees,naviLists: categorieNavs));
    tiles.add(new CateCard(category: "项目", categorieLists: categorieProjects,naviLists:categorieNavs ));
    return new ListView(
      children: tiles,
    );
  }

  /// 联想搜索，显示搜索结果列表
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
      body:  Container(
        color: Theme.of(context).backgroundColor,
        child: this.buildGrid(),
      ),
    );
  }
}
