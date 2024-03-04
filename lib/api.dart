import 'dart:io';

import 'package:http/http.dart' as http;

class MyApi {
  MyApi();

  Future<void> sendFile(File file) async {
    String token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoidG9rZW4iLCJleHAiOm51bGwsInRva2VuIjoxMH0.IxRzmsUGcmtTyHcF7AUw_Wk5Wn0f6Fl9AqaEBgzu41g';
    String identity = '12345678';
    print('here');
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('http://172.16.0.190:8004/api/ats/upload?identity=$identity&token=$token'),
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
    print(res.statusCode);
  }
}
