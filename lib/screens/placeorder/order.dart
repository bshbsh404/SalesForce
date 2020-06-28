import 'package:flutter/material.dart';

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
  bool srchmode = false;
  submitData(context) {}

  FocusNode myFocusNode;

  @override
  void initState() {
    super.initState();
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

  showRtlrData() {
    if (srchmode) {
      return Container();
    } else {
      return Container(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[Text("Name"), Text("Addr")],
            ),
            Container(
              child: Text("Route"),
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
                        )),
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
      return ListView.builder(
        shrinkWrap: true,
        itemBuilder: (ctx, i) {
          return GestureDetector(
              onTap: () {
                selectItem(i);
              },
              child: Card(
                margin: EdgeInsets.only(top: 1, bottom: 1, left: 10, right: 10),
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
      );
    }
  }

  selectItem(index) {
    Map<dynamic, dynamic> srchitm = srchitems[index];
    setState(() {
      items.add(srchitm);
      srchmode = false;
    });
    srch.clear();
    myFocusNode.unfocus();
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
  getAppbar(){
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                child: Column(
                  children: <Widget>[
                    showRtlrData(),
                    Container(
                      margin: EdgeInsets.only(top: 30),
                      padding: EdgeInsets.all(2),
                      child: TextField(
                        focusNode: myFocusNode,
                        decoration: InputDecoration(
                          labelText: "Search Item"
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
                    Container(
                      child: showAddedItms(),
                    )
                  ],
                ),
              ),
            ],
          )),
        ),
      ),
    );
  }
}
