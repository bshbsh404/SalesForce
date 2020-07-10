import '../staticdata/environments/hostport.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Server {
  Server._privateConstructor();
  static final Server instance = Server._privateConstructor();
  Future<Map<String, dynamic>> callserver(data) async {
    print("fech");
    Map<String, dynamic> resp = {"status": true, "finalresp": {}};
    var endpoints = envVars["endpoints"];
    String url = endpoints["server"];
    var body = jsonEncode(data);
    var client = http.Client();
    print("client created");
    try {
      var uriResponse = await client.post(url,
          headers: {"Content-Type": "application/json"}, body: body);
      if (uriResponse.statusCode == 200) {
        resp["finalresp"] = json.decode(uriResponse.body);
      } else {
        resp = {"status": false, "finalresp": {}};
      }
    } finally {
      client.close();
    }
    return resp;
  }
}
