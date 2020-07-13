import 'package:flutter/material.dart';
import 'dart:async';

import '../../plugins/plugins.dart';
import '../../dao/screenobj.dart';
import '../../staticdata/langcontainer/langcontainer.dart';

class PlaceOrder extends StatefulWidget {
  final ScreenObj scrObj;

  PlaceOrder(this.scrObj);

  @override
  _PlaceOrderState createState() => _PlaceOrderState();
}

class _PlaceOrderState extends State<PlaceOrder> {
  final srch = TextEditingController();
  List<Map<dynamic, dynamic>> items = [];
  List<Map<dynamic, dynamic>> srchitems = [];
  Map<dynamic, dynamic> cust = {};

  bool srchmode = false;
  submitData(context) {}

  FocusNode myFocusNode;

  @override
  void initState() {
    super.initState();
    fetchCust();
    myFocusNode = FocusNode();
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    myFocusNode.dispose();
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    if (srchmode) {
      setState(() {
        srchmode = false;
      });
    } else {
      Navigator.of(context).pop(true);
    }
  }

  lauchSearchMode() {
    setState(() {
      srchmode = true;
    });
  }

  fetchCust() async {
    String custid = this.widget.scrObj.misc["custid"];
    Map<String, dynamic> rslt = await Plugins.instance.excecute({
      'reqId': 'SQL',
      'query': 'SELECT * FROM TB_CUST WHERE id like $custid'
    });
    if (rslt['status']) {
      print(rslt['resp']);
      setState(() {
        cust = rslt['resp'][0];
      });
    }
  }

  showRtlrData() {
    if (srchmode) {
      return Container();
    } else {
      return Container(
        margin: EdgeInsets.only(left:10,right:10),
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.white
        ),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[Text(cust["custName"]), Text(cust["address"])],
            ),
            Container(
              child: Text(cust["address"]),
            )
          ],
        ),
      );
    }
  }

  showAddedItms() {
    if (srchmode) {
      return Container();
    } else if (items.length > 0) {
      return ListView.builder(
        padding: EdgeInsets.all(0),
        shrinkWrap: true,
        itemBuilder: (ctx, i) {
          return GestureDetector(
              onTap: () {},
              child: Card(
                margin: EdgeInsets.only(top: 1, bottom: 1, left: 10, right: 10),
                child: Row(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(items[i]["itemname"],
                              style: Theme.of(context).textTheme.bodyText2),
                          Text(items[i]["power"])
                        ],
                      ),
                    ),
                  ],
                ),
              ));
        },
        itemCount: items.length,
      );
    } else {
      return Container(
        child: Text("Add Items"),
      );
    }
  }

  showsrchrslt() {
    if (!srchmode) {
      return Container();
    } else {
      return Expanded(
        child: ListView.builder(
          padding: EdgeInsets.all(0),
          shrinkWrap: true,
          itemBuilder: (ctx, i) {
            return GestureDetector(
                onTap: () {
                  selectItem(i);
                },
                child: Card(
                  margin: EdgeInsets.only(top: 1, bottom: 1, left: 1, right: 1),
                  child: Row(
                    children: <Widget>[
                      Container(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(srchitems[i]["itemname"],
                                  style: Theme.of(context).textTheme.bodyText2),
                              Text(srchitems[i]["power"])
                            ],
                          )),
                    ],
                  ),
                ));
          },
          itemCount: srchitems.length,
        ),
      );
    }
  }

  selectItem(index) {
    Map<dynamic, dynamic> srchitm = srchitems[index];
    myFocusNode.unfocus();
    srch.clear();
    Timer(const Duration(milliseconds: 200), () {
      setState(() {
        items.add(srchitm);
        srchmode = false;
      });
    });
  }

  continueBtn(context) {
    if (srchmode) {
      return Container();
    } else {
      return Container(
        height: 70,
        child: Column(
          children: <Widget>[
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.brown[100],
                  ),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(
                              left: 10, right: 10, top: 5, bottom: 5),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Theme.of(context).primaryColor),
                              color: Colors.brown[50]),
                          child: FlatButton(
                            onPressed: () {},
                            child: Text("Continue"),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(
                              left: 10, right: 10, top: 5, bottom: 5),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                          ),
                          child: FlatButton(
                            onPressed: () {},
                            child: Text(
                              "Continue",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  searchItem(val) async {
    String srchstr = srch.text;
    srchstr = srchstr.trim();
    if (srchstr != null) {
      Map<String, dynamic> rslt = await Plugins.instance.excecute({
        'reqId': 'SQL',
        'query': 'SELECT * FROM TB_ITEMS WHERE itemname like "%$srchstr%"'
      });
      if (rslt['status']) {
        print(rslt['resp']);
        setState(() {
          srchitems = rslt['resp'];
        });
      }
    }
  }

  getAppbar() {
    return AppBar(
      title: Text(
        langData["LN_LOGIN"][widget.scrObj.lang],
        style: TextStyle(fontFamily: "Catamaran"),
      ),
      actions: <Widget>[
        Container(
          padding: EdgeInsets.only(top: 15),
          child: Row(
            children: <Widget>[
              Column(
                children: <Widget>[],
              )
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: srchmode ? null : getAppbar(),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/shopfx.jpeg"),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                    Color.fromRGBO(255, 255, 255, 0.3), BlendMode.modulate)),
          ),
          child: Column(
            children: <Widget>[
              showRtlrData(),
              Container(
                margin:
                    EdgeInsets.only(top: 22, bottom: 1, left: 10, right: 10),
                padding: EdgeInsets.all(2),
                child: TextField(
                  focusNode: myFocusNode,
                  decoration: new InputDecoration(
                    fillColor: Theme.of(context).primaryColorLight,
                    border: InputBorder.none,
                    filled: true,
                    contentPadding:
                        EdgeInsets.only(bottom: 10.0, left: 10.0, right: 10.0),
                    labelText: "Search Item",
                  ),
                  controller: srch,
                  onTap: () {
                    lauchSearchMode();
                  },
                  onSubmitted: (_) => submitData(context),
                  onChanged: (val) {
                    searchItem(val);
                  },
                ),
              ),
              showsrchrslt(),
              srchmode
                  ? Text("")
                  : Expanded(
                      child: showAddedItms(),
                    ),
              continueBtn(context),
            ],
          ),
        ),
      ),
    );
  }
}
