import 'package:flutter/material.dart';

import '../../dao/screenobj.dart';
import '../../plugins/plugins.dart';

import '../itemdetails/itemdetails.dart';
import '../../staticdata/langcontainer/langcontainer.dart';

class ItemDetails extends StatefulWidget {
  final ScreenObj scrObj;

  ItemDetails(this.scrObj);
  @override
  _ItemDetailsdState createState() => _ItemDetailsdState();
}

class _ItemDetailsdState extends State<ItemDetails> {
  Map<dynamic, dynamic> item = {};
  List<Map<String, dynamic>> itemArr = [];

  final srchbyname = TextEditingController();

  final srchbymfg = TextEditingController();

  final srchbytyp = TextEditingController();

  FocusNode nameFocusNode;
  FocusNode typeFocusNode;
  FocusNode mfgFocusNode;

  @override
  void initState() {
    super.initState();
    nameFocusNode = FocusNode();
    typeFocusNode = FocusNode();
    mfgFocusNode = FocusNode();
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    nameFocusNode.dispose();
    typeFocusNode.dispose();
    mfgFocusNode.dispose();
    super.dispose();
  }

  getItemlist() async {
    String srchbynameval = srchbyname.text;
    Map<String, dynamic> rslt = await Plugins.instance.excecute({
      'reqId': 'SQL',
      'query': 'SELECT * FROM TB_ITEMS WHERE itemName like "%$srchbynameval%"'
    });
    if (rslt['status']) {
      print(rslt['resp']);
      setState(() {
        itemArr = rslt['resp'];
      });
    }
    nameFocusNode.unfocus();
    typeFocusNode.unfocus();
    mfgFocusNode.unfocus();
  }

  fetchItemDetails(ctx, index) {
    if (itemArr.length > 0) {
      Map<String, dynamic> itemdetails = itemArr[index];
      this.widget.scrObj.misc["custid"] = itemdetails["id"];
      Navigator.push(ctx, MaterialPageRoute(builder: (context) {
        return ItemDetails(this.widget.scrObj);
      }));
    }
  }

  renderItems() {
    if (itemArr.length > 0) {
      return SingleChildScrollView(
        child: ListView.builder(
          shrinkWrap: true,
          itemBuilder: (ctx, i) {
            return GestureDetector(
                onTap: () {},
                child: Card(
                  margin:
                      EdgeInsets.only(top: 1, bottom: 1, left: 10, right: 10),
                  child: Row(
                    children: <Widget>[
                      Container(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(itemArr[i]["itemname"],
                                  style: Theme.of(context).textTheme.bodyText2),
                              Text(itemArr[i]["power"])
                            ],
                          )),
                    ],
                  ),
                ));
          },
          itemCount: itemArr.length,
        ),
      );
    } else {
      return Container();
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
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/shopfx.jpeg"),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                  Color.fromRGBO(255, 255, 255, 0.3), BlendMode.modulate)),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Card(
                color: Colors.transparent,
                child: Container(
                  margin: EdgeInsets.only(left: 10, right: 10, bottom: 20),
                  child: Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 30),
                        padding: EdgeInsets.all(2),
                        child: TextField(
                          focusNode: nameFocusNode,
                          controller: srchbyname,
                          decoration:
                              InputDecoration(labelText: "Search by Item Name"),
                          onTap: () {},
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 30),
                        padding: EdgeInsets.all(2),
                        child: TextField(
                          focusNode: typeFocusNode,
                          controller: srchbytyp,
                          decoration:
                              InputDecoration(labelText: "Search by Type"),
                          onTap: () {},
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 30),
                        padding: EdgeInsets.all(2),
                        child: TextField(
                          focusNode: mfgFocusNode,
                          controller: srchbymfg,
                          decoration:
                              InputDecoration(labelText: "Search by Mfg"),
                          onTap: () {},
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          getItemlist();
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 20),
                          padding: EdgeInsets.only(
                              top: 10, bottom: 10, left: 100, right: 100),
                          color: Theme.of(context).primaryColor,
                          child: Text(
                            "Search",
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              renderItems(),
            ],
          ),
        ),
      ),
    );
  }
}
