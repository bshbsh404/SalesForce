import 'package:flutter/material.dart';

import '../../dao/screenobj.dart';

class OrderStatus extends StatefulWidget {
  final ScreenObj scrObj;

  OrderStatus(this.scrObj);

  @override
  _OrderStatusState createState() => _OrderStatusState();
}

class _OrderStatusState extends State<OrderStatus> {
  bool img = false;

  setImg() {
    setState(() {
      img = true;
    });
  }

  getImg() {
    if (mounted) {
      return Image.asset(
        "assets/images/scss.gif",
      );
    } else {
      return Text("");
    }
  }

  @override
  void initState() {
    //WidgetsBinding.instance.addPostFrameCallback((_) => setImg());

    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: Container(
            child: Icon(Icons.check),
          ),
          title: Text(
            "",
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
        body: Center(
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/shopfx.jpeg"),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                      Color.fromRGBO(255, 255, 255, 0.3), BlendMode.modulate)),
            ),
            child: Column(
              children: <Widget>[
                Container(
                  child: getImg(),
                ),
                Container(
                  margin:
                      EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                  ),
                  child: FlatButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed("/dashboard",
                          arguments: this.widget.scrObj);
                    },
                    child: Text(
                      "Home",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
