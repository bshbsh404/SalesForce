import 'package:flutter/material.dart';

import '../../dao/screenobj.dart';

import '../../plugins/plugins.dart';
import '../../staticdata/langcontainer/langcontainer.dart';

class ItemDetails extends StatefulWidget {
  final ScreenObj scrObj;

  ItemDetails(this.scrObj);
  @override
  _ItemDetailsdState createState() => _ItemDetailsdState();
}

class _ItemDetailsdState extends State<ItemDetails> {

  Map<dynamic,dynamic> itemData = {};
  @override
  void initState() {
    fetchItemData();
    super.initState();
  }
  fetchItemData() async{
    String item = this.widget.scrObj.misc["itemid"];
     Map<String, dynamic> rslt = await Plugins.instance
        .excecute({'reqId': 'SQL', 'query': 'SELECT * FROM TB_ITEMS WHERE id like $item'});
    if (rslt['status']) {
      print(rslt['resp']);
      setState(() {
        itemData = rslt['resp'][0];
      });
    }
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          langData["LN_DASH"][this.widget.scrObj.lang],
          style: TextStyle(
            fontFamily: "Catamaran",
            color: Colors.white,
          ),
        ),
        actions: <Widget>[],
      ),
      body: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/shopfx.jpeg"),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                    Color.fromRGBO(255, 255, 255, 0.3), BlendMode.modulate)),
          ),
          child: Container(
            child: Column(
              children: <Widget>[
                Text(itemData["itemname"] == null ? "" : itemData["itemname"]),
                Text(itemData["power"] == null ? "" : itemData["power"])
              ],
            ),
          )),
    );
  }
}
