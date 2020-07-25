import 'package:flutter/material.dart';

import '../../dao/screenobj.dart';

import '../../plugins/plugins.dart';
import '../../staticdata/langcontainer/langcontainer.dart';

class ConfirmOrder extends StatefulWidget {
  final ScreenObj scrObj;

  ConfirmOrder(this.scrObj);

  @override
  _ConfirmOrderState createState() => _ConfirmOrderState();
}

class _ConfirmOrderState extends State<ConfirmOrder> {
  List<Map<dynamic, dynamic>> items = [];
  Map<dynamic, dynamic> cust = {};

  getitems() async {
    setState(() {
      items = this.widget.scrObj.misc["items"];
    });
    fetchCust();
    return true;
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

  doOrder() async {
    String custid = this.widget.scrObj.misc["custid"];
    String userId = this.widget.scrObj.userid;
    var now = new DateTime.now();
    var resp = await Plugins.instance.excecute(
        {'reqId': "FORMATDATE", 'date': now, 'frmt': "dd-mm-yy hh:mm"});
    String tym = resp['resp']['frmtStr'];
    print(
        'INSERT INTO TB_ORDER(userid,custid,payload,ordertime,pushstatus,orderhash)values("$userId","$custid","${items.toString()},"$tym","U","");');
    Map<String, dynamic> rslt = await Plugins.instance.excecute({
      'reqId': 'SQL',
      'query':
          'INSERT INTO TB_ORDER(userid,custid,payload,ordertime,pushstatus,orderhash)values("$userId","$custid","${items.toString()}","$tym","U","");'
    });
    this.widget.scrObj.misc["ordrstatus"] = rslt['status'];
    if (rslt['status']) {
      Navigator.of(context)
          .pushNamed('/orderstatus', arguments: this.widget.scrObj);
    } else {}
  }

  continueBtn(context) {
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
                  doOrder();
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

  showRtlrData() {
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

  @override
  void initState() {
    getitems();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            showRtlrData(),
            Card(
              child: Container(
                width: double.infinity,
                height: 30,
                child: Padding(
                  padding: EdgeInsets.only(left: 10, top: 5),
                  child: Text(
                    "Items",
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              itemBuilder: (ctx, i) {
                return GestureDetector(
                    onTap: () {},
                    child: Card(
                      margin: EdgeInsets.only(
                          top: 1, bottom: 1, left: 10, right: 10),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    items[i]["itemname"],
                                    style: TextStyle(
                                        color: Colors.deepPurple,
                                        fontSize: 18,
                                        fontStyle: FontStyle.italic,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(left: 10),
                            width: 40,
                            child: Text(
                              items[i]["qty"].substring(0, 1).toUpperCase(),
                              style: TextStyle(
                                  color: Colors.deepPurple,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ));
              },
              itemCount: items.length,
            )
          ],
        )),
      ),
      bottomNavigationBar: continueBtn(context),
    );
  }
}
