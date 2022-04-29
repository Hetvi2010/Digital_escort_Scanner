import 'dart:convert';

import 'package:http/http.dart' as http;
import 'data.dart';

class Db {
  static Future<String> getKey() async {
    var response = await http.get(
      Uri.parse('https://digitalescort.000webhostapp.com/Keys'),
    );
    return response.body.substring(28, 38);
  }

  static Future<String> validateRollNo(String rollNo) async {
    var response = await http.post(
        Uri.parse('https://digitalescort.000webhostapp.com/Validateuser'),
        body: {
          "rollno": rollNo,
        });
    return response.body;
  }

  static Future<String> verificationRequest(String rollNo, String url) async {
    var response = await http.post(
        Uri.parse('https://digitalescort.000webhostapp.com/ImgVerification'),
        body: {
          "rollno": rollNo,
          "img_url": url,
        });
    print(url);
    print(response.body);
    return response.body;
  }

  static Future<List<dynamic>> viewlist() async {
    var response = await http
        .post(Uri.parse('https://digitalescort.000webhostapp.com/List'), body: {
      "username": LoginData.userName,
    });
    LoginData.mp[jsonDecode(response.body)[0]["RollNo"]] =
        jsonDecode(response.body)[0];
    return (jsonDecode(response.body));
  }
}
