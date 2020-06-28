import 'package:flutter/material.dart';
import '../../plugins/plugins.dart';
import '../../dao/screenobj.dart';

import '../../themes/themechanger.dart';
import 'package:provider/provider.dart';

import '../../staticdata/langcontainer/langcontainer.dart';

class Settings extends StatefulWidget {
  final ScreenObj scrobj;
  Settings(this.scrobj);
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<Settings> {
  _SettingsPageState();
  Color authclr = Colors.black;
  String lang = "en_us";
  authenticateUser() async {
    Map<String, dynamic> rslt =
        await Plugins.instance.excecute({"reqId": "BIOAUTH"});

    if (rslt['status'] && rslt['resp']['status']) {
      Map<String, dynamic> rslt = await Plugins.instance.excecute({
        'reqId': "SQL",
        'query':
            'UPDATE TB_USERS SET BIO_AUTH = "true" WHERE USER_ID = "${widget.scrobj.userid}";',
        'entity': "Customer"
      });
      if (rslt['status'] != false &&
          rslt['resp'].length > 0 &&
          rslt['resp'][0]['BIO_AUTH'] == "true") {}

      setState(() {
        authclr = Colors.green;
      });
    } else {
      Map<String, dynamic> rslt = await Plugins.instance.excecute({
        'reqId': "SQL",
        'query':
            'UPDATE TB_USERS SET BIO_AUTH = "false" WHERE USER_ID = "${widget.scrobj.userid}";',
        'entity': "Customer"
      });

      setState(() {
        authclr = Colors.black;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchBioauth();
  }

  fetchBioauth() async {
    Map<String, dynamic> rslt = await Plugins.instance.excecute({
      'reqId': "SQL",
      'query': 'SELECT * FROM TB_USERS',
      'entity': "Customer"
    });
    if (rslt['status'] != false &&
        rslt['resp'].length > 0 &&
        rslt['resp'][0]['BIO_AUTH'] == "true") {
      setState(() {
        authclr = Colors.green;
      });
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          langData["LN_LOGIN"][widget.scrobj.lang],
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
          children: <Widget>[
            GestureDetector(
              onTap: () {
                authenticateUser();
              },
              child: Container(
                margin: EdgeInsets.all(10.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(
                          top: 10, bottom: 10, left: 5, right: 5),
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: Text(
                        "Finger Print",
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                          top: 10, bottom: 10, left: 5, right: 5),
                      width: MediaQuery.of(context).size.width * 0.2,
                      alignment: Alignment.bottomRight,
                      child: Container(
                        child: IconTheme(
                          data: IconThemeData(
                            opacity: 1,
                          ),
                          child: Icon(
                            Icons.fingerprint,
                            color: authclr,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                authenticateUser();
              },
              child: Container(
                child: Consumer<ThemeNotifier>(
                  builder: (context, notifier, child) => SwitchListTile(
                    title: Text(
                      "Dark Mode",
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                    onChanged: (val) {
                      notifier.toggleTheme();
                    },
                    value: notifier.darkTheme,
                  ),
                ),
              ),
            ),
          ],
        )),
      ),
    );
  }
}
