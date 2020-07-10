import '../staticdata/environments/hostport.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<String> fetchItems() async {
  print("fech");
  var endpoints = envVars["endpoints"];
  String url = endpoints["server"];
  var body = jsonEncode({
    "datahdr": {"userid": "vignesh", "appid": "test", "sessionid": ""},
    "requestDetails": {"requestId": "FETCH_ITEMS"},
    "requestData": {"userid": "vignesh", "pin": "1234"}
  });
  var client = http.Client();
  print("client created");
  try {
    var uriResponse = await client.post(url,
        headers: {"Content-Type": "application/json"}, body: body);
    if(uriResponse.statusCode == 200){
      print(uriResponse.body);
    }
  } finally {
    client.close();
  }
}
