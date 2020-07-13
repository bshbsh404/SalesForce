import 'package:flutter/material.dart';

import '../../dao/screenobj.dart';
import '../../plugins/plugins.dart';

import '../../staticdata/langcontainer/langcontainer.dart';

class Dashboard extends StatefulWidget {
  final ScreenObj scrObj;

  Dashboard(this.scrObj);
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  String lang = "en_us";
  var time = "unKnown";

  final options = [
    {"icon": Icons.person_outline, "option": "Cust Details", "disabled": false},
    {
      "icon": Icons.add_shopping_cart,
      "option": "Place Order",
      "disabled": false
    },
    //{"icon": Icons.assessment, "option": "Outstanding", "disabled": false},
    //{"icon": Icons.compare_arrows, "option": "Order list", "disabled": false},
    {"icon": Icons.category, "option": "Item Details", "disabled": false},
    //{"icon": Icons.report, "option": "Reports", "disabled": false},
    {"icon": Icons.build, "option": "Settings", "disabled": false},
  ];
  listclicked(index) {
    //Plugins.instance.excecute({"reqId":"TOAST","msg":options[index]['option']});
    String scrrScreen = options[index]['option'];
    String screen = '/dashboard';
    if (scrrScreen == "Settings") {
      screen = '/settings';
    } else if (scrrScreen == "Cust Details") {
      screen = '/custmstr';
    } else if (scrrScreen == "Place Order") {
      screen = '/custorder';
    } else if (scrrScreen == "Item Details") {
      screen = '/itemmstr';
    }
    if (!options[index]['disabled']) {
      Navigator.of(context).pushNamed(screen, arguments: this.widget.scrObj);
    }
  }

  getCardClr(context, index) {
    if (!options[index]['disabled']) {
      return Theme.of(context).primaryColor;
    } else {
      return Theme.of(context).primaryColorLight;
    }
  }

  fetchItems() async {
    var data = {
      "datahdr": {"userid": "vignesh", "appid": "test", "sessionid": ""},
      "requestDetails": {"requestId": "FETCH_ITEMS"},
      "requestData": {"userid": "vignesh", "pin": "1234"}
    };
    await Plugins.instance.excecute({'reqId': "CALLSERVER", 'data': data});
  }

  runScheduler() async {
    var now = new DateTime.now();
    var resp = await Plugins.instance
        .excecute({'reqId': "FORMATDATE", 'date': now, 'frmt': "hh:mm"});
    setState(() {
      //time = "Last Updated :" + resp['resp']['frmtStr'];
    });
  }

  startBackgroundPrcss() async {
    var resp = await Plugins.instance.excecute(
        {'reqId': "SCHEDULER", 'cron': "*/3 * * * *", 'fn': runScheduler});
  }

  @override
  void initState() {
    startBackgroundPrcss();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        appBar: AppBar(
          leading: Container(
            child: Icon(Icons.dashboard),
          ),
          title: Text(
            langData["LN_DASH"][lang],
            style: TextStyle(
              fontFamily: "Catamaran",
              color: Colors.white,
            ),
          ),
          actions: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 15),
              child: Row(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      //Text(time),
                    ],
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
            child: Container(
              child: GridView.count(
                // Create a grid with 2 columns. If you change the scrollDirection to
                // horizontal, this produces 2 rows.
                crossAxisCount: 3,
                // Generate 100 widgets that display their index in the List.
                children: List.generate(options.length, (index) {
                  return Container(
                    padding: EdgeInsets.all(2),
                    height: 10,
                    width: 10,
                    child: GestureDetector(
                      onTap: () {
                        listclicked(index);
                      },
                      child: Card(
                        color: getCardClr(context, index),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            IconTheme(
                              data: IconThemeData(
                                  color: Theme.of(context).iconTheme.color),
                              child: Icon(
                                options[index]["icon"],
                              ),
                            ),
                            Text(
                              options[index]["option"],
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            )),
      ),
    );
  }
}
