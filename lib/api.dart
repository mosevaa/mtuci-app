import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:mobile_device_identifier/mobile_device_identifier.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyApi {
  MyApi();

  Future<void> sendFile(File file) async {
    final prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? '';

    final identity = await MobileDeviceIdentifier().getDeviceId();

    final request = http.MultipartRequest(
      'POST',
      Uri.parse(
          'http://172.16.0.190:8004/api/ats/upload?identity=$identity&token=$token'),
    );

    final len = file.lengthSync();

    request.files.add(
      http.MultipartFile.fromBytes(
        'file',
        file.readAsBytesSync(),
        filename: 'file.mp3',
      ),
    );
    final res = await request.send();
    final respStr = await res.stream.bytesToString();
  }

  Future<http.Response> login(String token, String name) async {
    Map<String, String> userHeader = {
      "Content-type": "application/json",
      "Accept": "application/json"
    };
    final identity = await MobileDeviceIdentifier().getDeviceId();
    final url = Uri.parse('http://172.16.0.190:8004/api/ats/announce');
    final request = await http.post(url,
        body: json.encode(
            {"access_token": token, "identity": identity, "info": name}),
        headers: userHeader);
    return request;
  }
}
