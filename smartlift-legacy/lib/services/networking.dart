import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:smartlift/global.dart' as globals;

class NetworkHelper {
  NetworkHelper(this.urlPath, this.params);
  final String prefixUrl = globals.serverIP;
  final String urlPath;
  final Map<String, dynamic> params;

  Future getData() async {
    try {
      var url = Uri.http(prefixUrl, "/smartlift/" + urlPath, params);
      http.Response response =
          await http.get(url).timeout(const Duration(seconds: 60));
      if (response.statusCode == 200) {
        String data = response.body;

        return jsonDecode(data);
      } else {
        String data = response.body;

        return jsonDecode(data);
      }
    } catch (e) {
      //print(e);
    }
  }

  Future postData(String jsonData) async {
    try {
      var url = Uri.http(prefixUrl, urlPath);
      http.Response response = await http
          .post(
            url,
            body: jsonData,
          )
          .timeout(const Duration(seconds: 60));
      if (response.statusCode == 200) {
        String data = response.body;

        return jsonDecode(data);
      } else {
        String data = response.body;

        return jsonDecode(data);
      }
    } catch (e) {
      //print(e);
    }
  }
}
