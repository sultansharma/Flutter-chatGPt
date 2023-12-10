//Page For API requests

import 'dart:convert';
import 'package:flutter_chatgpt/helpers/constant.dart';
import 'package:flutter_chatgpt/helpers/openApiconfig.dart';
import 'package:http/http.dart' as http;

Future<dynamic> postRequest(String url, dynamic body) async {
  print(mainUrl + url);
  try {
    var headers = {
      'Accept': 'application/json',
      'Authorization':
          'Bearer ${openApiKey}',
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse(mainUrl + url));
    request.body = json.encode(body);
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      return await response.stream.bytesToString();
    } else {
      final res = await response.stream.bytesToString();
      final deres = json.decode(res);
      if (deres['error'].toString().isNotEmpty) {
        my_toast(deres["error"]["message"], "error");
      } else {
        print(deres.toString());
        return res;
      }
      //final res =
      print(json.encode(body));
    }
  } catch (err) {
    print("Error" + err.toString());
  }
}
