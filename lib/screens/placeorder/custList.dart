import 'package:flutter/material.dart';

import '../../dao/screenobj.dart';
import '../../staticdata/langcontainer/langcontainer.dart';
import '../../plugins/plugins.dart';
import './order.dart';

class CustomerListor extends StatefulWidget {
  final ScreenObj scrObj;

  CustomerListor(this.scrObj);

  @override
  _CustomerListorState createState() => _CustomerListorState();
}

class _CustomerListorState extends State<CustomerListor> {
  List<Map<String, dynamic>> custArr = [];

  getCustlist() async {
    Map<String, dynamic> rslt = await Plugins.instance
        .excecute({'reqId': 'SQL', 'query': 'SELECT * FROM TB_CUST'});
    if (rslt['status']) {
      print(rslt['resp']);
      setState(() {
        custArr = rslt['resp'];
      });
    }
  }

  fetchcustDetails(ctx, index) {
    if (custArr.length > 0) {
      Map<String, dynamic> custdetails = custArr[index];
      this.widget.scrObj.misc["custid"] = custdetails["id"];
      Navigator.of(context).pushNamed('/order', arguments: this.widget.scrObj);
    }
  }

  @override
  void initState() {
    getCustlist();
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
            Card(
              child: Container(
                width: double.infinity,
                height: 30,
                child: Padding(
                  padding: EdgeInsets.only(left: 10, top: 5),
                  child: Text(
                    "Retailers",
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              itemBuilder: (ctx, i) {
                return GestureDetector(
                    onTap: () {
                      fetchcustDetails(ctx, i);
                    },
                    child: Card(
                      margin: EdgeInsets.only(
                          top: 1, bottom: 1, left: 10, right: 10),
                      child: Row(
                        children: <Widget>[
                          Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(left: 10),
                            child: Text(
                              custArr[i]["custName"]
                                  .substring(0, 1)
                                  .toUpperCase(),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            padding: EdgeInsets.all(10),
                            width: 40,
                            decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: new BorderRadius.all(
                                    new Radius.circular(50.0)),
                                border: Border.all(
                                    color: Theme.of(context).primaryColor)),
                          ),
                          Container(
                              padding: EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(custArr[i]["custName"],
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText2),
                                  Text(custArr[i]["address"])
                                ],
                              )),
                        ],
                      ),
                    ));
              },
              itemCount: custArr.length,
            )
          ],
        )),
      ),
    );
  }
}
