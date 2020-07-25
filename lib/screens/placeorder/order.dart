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

  List<FocusNode> lfocusnode = [];

  List<TextEditingController> _controller = [];
  @override
  void initState() {
    super.initState();
    fetchCust();
    myFocusNode = FocusNode();
    for (int i = 1; i < 75; i++) lfocusnode.add(FocusNode());
    for (int i = 1; i < 75; i++) _controller.add(TextEditingController());
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    myFocusNode.dispose();
    lfocusnode.forEach((element) {
      element.dispose();
    });
    _controller.removeRange(0, _controller.length);
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    if (srchmode) {
      setState(() {
        srchmode = false;
      });
    } else {
      Navigator.of(context).pop(true);
      return true;
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
        margin: EdgeInsets.only(top: 20, left: 5, right: 5),
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.deepPurpleAccent[100],
        ),
        child: Row(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(5),
                  child: Text(
                    cust["custName"] == null ? "" : cust["custName"],
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(5),
                  child: Text(
                    cust["address"] == null ? "" : cust["address"],
                    style: TextStyle(fontSize: 15, color: Colors.white),
                  ),
                )
              ],
            ),
          ],
        ),
      );
    }
  }

  removeItem(i) {
    setState(() {
      if (int.parse(items[i]["qty"]) > 0) {
        int lqty = int.parse(items[i]["qty"]) - 1;
        items[i]["qty"] = lqty.toString();
        _controller[i].text = items[i]["qty"];
      }
    });
  }

  removeItemfrmlst(i) {
    setState(() {
      items.removeAt(i);
    });
  }

  addItem(i) {
    Map<dynamic, dynamic> item = items[i];
    setState(() {
      if (item["qty"] != "" && item["qty"] != null) {
        int lqty = int.parse(item["qty"]) + 1;
        print("qty" + lqty.toString());
        item["qty"] = lqty.toString();
      } else {
        item["qty"] = "1";
      }
      items[i] = item;
      _controller[i].text = item["qty"];
    });
  }

  showAddedItms() {
    if (srchmode) {
      return Container();
    } else if (items.length > 0) {
      return ListView.builder(
        padding: EdgeInsets.all(0),
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (ctx, i) {
          return Dismissible(
            key: Key(i.toString()),
            onDismissed: (direction) {
              setState(() {
                items.removeAt(i);
              });
            },
            child: GestureDetector(
                onTap: () {},
                child: Card(
                  margin: EdgeInsets.only(top: 1, bottom: 1, left: 5, right: 5),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                items[i]["itemname"] == null
                                    ? ""
                                    : items[i]["itemname"],
                                style: TextStyle(
                                    color: Colors.deepPurple,
                                    fontSize: 18,
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                items[i]["power"] == null
                                    ? ""
                                    : items[i]["power"],
                                style: Theme.of(context).textTheme.bodyText2,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: 50,
                        child: FlatButton(
                          onPressed: () {
                            removeItem(i);
                          },
                          child: Icon(
                            Icons.remove,
                            color: Colors.red,
                          ),
                        ),
                      ),
                      Container(
                        height: 40,
                        width: 40,
                        child: TextFormField(
                          controller: _controller[i],
                          focusNode: lfocusnode[i],
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          onChanged: (text) {
                            addQtty(text, i);
                          },
                        ),
                      ),
                      Container(
                        width: 50,
                        child: FlatButton(
                          onPressed: () {
                            addItem(i);
                          },
                          child: Icon(
                            Icons.add,
                            color: Colors.green,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(0),
                        margin: EdgeInsets.all(0),
                        width: 50,
                        child: GestureDetector(
                          onTap: () {
                            removeItemfrmlst(i);
                          },
                          child: Icon(
                            Icons.restore_from_trash,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
          );
        },
        itemCount: items.length,
      );
    } else {
      return Container(
        margin: EdgeInsets.all(5),
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.deepPurple),
        ),
        child: Center(
          child: Column(
            children: <Widget>[
              IconTheme(
                data: IconThemeData(
                  color: Colors.deepPurple,
                  size: 40,
                ),
                child: Icon(Icons.add_shopping_cart),
              ),
              Text(
                "Add Items to cart",
                style: TextStyle(fontSize: 18, color: Colors.deepPurple),
              ),
            ],
          ),
        ),
      );
    }
  }

  addQtty(txt, i) {
    items[i]["qty"] = txt;
  }

  continueconfirm() {
    this.widget.scrObj.misc["items"] = items;
    Navigator.of(context)
        .pushNamed('/confrimorder', arguments: this.widget.scrObj);
  }

  showsrchrslt() {
    if (!srchmode) {
      return Container();
    } else {
      return Container(
        child: Scrollbar(
          child: ListView.builder(
            padding: EdgeInsets.all(0),
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (ctx, i) {
              return GestureDetector(
                  onTap: () {
                    selectItem(i);
                  },
                  child: Card(
                    margin:
                        EdgeInsets.only(top: 1, bottom: 1, left: 1, right: 1),
                    child: Row(
                      children: <Widget>[
                        Container(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  srchitems[i]["itemname"],
                                  style: TextStyle(
                                      color: Colors.deepPurple,
                                      fontSize: 18,
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(srchitems[i]["power"])
                              ],
                            )),
                      ],
                    ),
                  ));
            },
            itemCount: srchitems.length,
          ),
        ),
      );
    }
  }

  selectItem(index) {
    Map<dynamic, dynamic> srchitm = srchitems[index];
    srchitm = {...srchitm, "qty": "1"};
    myFocusNode.unfocus();
    srch.clear();

    Timer(const Duration(milliseconds: 100), () {
      setState(() {
        items.insert(0, srchitm);
        srchmode = false;
      });
      int i = 0;
      items.forEach((element) {
        _controller[i].text = element['qty'];
        i++;
      });
    });
    lfocusnode[0].requestFocus();
  }

  continueBtn(context) {
    if (srchmode) {
      return Text("");
    } else {
      return Container(
        decoration: BoxDecoration(
          color: Colors.brown[100],
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                decoration: BoxDecoration(
                    border: Border.all(color: Theme.of(context).primaryColor),
                    color: Colors.brown[50]),
                child: FlatButton(
                  onPressed: () {},
                  child: Text(
                    "Back",
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                ),
                child: FlatButton(
                  onPressed: () {
                    continueconfirm();
                  },
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
          height: double.infinity,
          width: double.infinity,
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
                showRtlrData(),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blueGrey),
                    gradient: LinearGradient(
                      colors: [
                        Colors.deepPurpleAccent[100],
                        Colors.transparent,
                        Colors.transparent,
                        Colors.transparent,
                        Colors.deepPurpleAccent[100],
                      ],
                    ),
                  ),
                  padding:
                      EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
                  margin: EdgeInsets.only(
                    left: 5,
                    right: 5,
                    top: 25,
                  ),
                  child: TextField(
                    focusNode: myFocusNode,
                    decoration: new InputDecoration(
                      fillColor: Colors.transparent,
                      filled: true,
                      contentPadding: EdgeInsets.only(bottom: 10.0, left: 10.0),
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
                    : Container(
                        child: showAddedItms(),
                      ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: continueBtn(context),
      ),
    );
  }
}
