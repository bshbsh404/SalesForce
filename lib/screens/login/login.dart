import 'package:flutter/material.dart';
import '../../staticdata/langcontainer/langcontainer.dart';
import '../dashboard/dashboard.dart';
import '../../plugins/plugins.dart';
import '../../dao/screenobj.dart';

class Login extends StatefulWidget {
  final ScreenObj scrObj;
  Login(this.scrObj);
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  Map<String, dynamic> usrrslt;
  bool isBioauthEnabled = false;
  String userId;
  String password;
  String checkUserId;
  String checkpassword;
  bool isLoggedin = false;
  final userCntrllr = TextEditingController();
  final pwdcntrllr = TextEditingController();
  submitData(context) {}

  validateUser() async {
    bool validuser = false;
    password = pwdcntrllr.text;
    password = password.trim();
    if (isLoggedin) {
      if (checkUserId == userId && password == checkpassword) {
        validuser = true;
        usrrslt = await Plugins.instance.excecute({
          'reqId': "SQL",
          'query':
              'UPDATE TB_USERS SET LAST_LOGIN = "Madhu" WHERE USER_ID = "${userId}";',
          'entity': "Customer"
        });
      } else {}
    } else {
      validuser = true;
      userId = userCntrllr.text;
      userId = userId.trim();
      usrrslt = await Plugins.instance.excecute({
        'reqId': "SQL",
        'query':
            'INSERT INTO TB_USERS("USER_ID","PASS","BIO_AUTH")values("${userId}","${password}","false")',
        'entity': "Customer"
      });
    }

    if (validuser && usrrslt['status'] != false) {
      final scrObj = ScreenObj(userCntrllr.text.trim(), widget.scrObj.lang, {});
      Navigator.of(context)
          .pushNamed('/dashboard', arguments: this.widget.scrObj);
    } else {}
  }

  checkbioAuth() async {
    Map<String, dynamic> rslt =
        await Plugins.instance.excecute({"reqId": "BIOAUTH"});

    if (rslt['status'] && rslt['resp']['status']) {
      final scrObj = ScreenObj(userCntrllr.text.trim(), widget.scrObj.lang, {});
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return Dashboard(scrObj);
      }));
    }
  }

  Widget getnwuserContent() {
    return TextField(
      decoration: InputDecoration(
        labelText: langData["LN_USER_NM"][widget.scrObj.lang],
      ),
      controller: userCntrllr,
      onSubmitted: (_) => submitData(context),
      // onChanged: (val) {
      //   titleInput = val;
      // },
    );
  }

  Widget getreguserContent() {
    return Container(
      alignment: Alignment.center,
      child: Text(
        "Hi " + userId,
        style: Theme.of(context).textTheme.bodyText2,
      ),
    );
  }

  Widget getBioAUthenabled() {
    return GestureDetector(
        onTap: () {
          checkbioAuth();
        },
        child: Container(
            decoration: BoxDecoration(
                border: Border.all(color: Theme.of(context).primaryColor)),
            child: Row(
              children: <Widget>[Icon(Icons.fingerprint), Text("Finger Print")],
            )));
  }

  checkUserPresent() async {
    usrrslt = await Plugins.instance.excecute({
      'reqId': "SQL",
      'query': 'SELECT * FROM TB_USERS',
      'entity': "Customer"
    });
    if (usrrslt['status'] != false && usrrslt['resp'].length > 0) {
      userId = usrrslt['resp'][0]['USER_ID'];
      checkUserId = usrrslt['resp'][0]['USER_ID'];
      checkpassword = usrrslt['resp'][0]['PASS'];

      userId = userId.trim();
      checkUserId = checkUserId.trim();
      checkpassword = checkpassword.trim();
      setState(() {
        isLoggedin = true;
        isBioauthEnabled =
            usrrslt['resp'][0]['BIO_AUTH'] == "true" ? true : false;
      });
    } else {}
  }

  @override
  void initState() {
    super.initState();
    checkUserPresent();
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
          child: Container(
            child: Column(
              children: <Widget>[
                Card(
                  elevation: 5,
                  color: Colors.transparent,
                  margin: EdgeInsets.only(top: 200),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.deepPurpleAccent[100],
                          Colors.transparent,
                          Colors.transparent,
                          Colors.transparent,
                          Colors.transparent,
                        ],
                      ),
                    ),
                    padding: EdgeInsets.all(10),
                    width: 350,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        isLoggedin ? getreguserContent() : getnwuserContent(),
                        SizedBox(
                          height: 20,
                        ),
                        TextField(
                          decoration: InputDecoration(
                            labelText: langData["LN_PASS"][widget.scrObj.lang],
                          ),
                          controller: pwdcntrllr,
                          onSubmitted: (_) => submitData(context),
                          // onChanged: (val) => amountInput = val,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          child: RaisedButton(
                            color: Theme.of(context).primaryColor,
                            onPressed: () {
                              validateUser();
                            },
                            child: Text(
                                langData["LN_LOGIN"][widget.scrObj.lang],
                                style: Theme.of(context).textTheme.bodyText1),
                          ),
                        ),
                        isBioauthEnabled ? getBioAUthenabled() : Text(""),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
