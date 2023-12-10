import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_chatgpt/api_service.dart';
import 'package:flutter_chatgpt/helpers/constant.dart';
import 'package:flutter_chatgpt/models/images.dart';

class MainProvider with ChangeNotifier {
  MainProvider() {
    makeTextAndCodeSeprate(
        "Sure! Here's the updated code with the `fontSize` set to 30.0:\n\n```dart\nimport 'package:flutter/material.dart';\n\nvoid main() => runApp(MyApp());\n\nclass MyApp extends StatelessWidget {\n  @override\n  Widget build(BuildContext context) {\n    return MaterialApp(\n      title: 'Flutter Container Example here is that on the',\n      theme: ThemeData(\n        primarySwatch: Colors.blue,\n      ),\n      home: Scaffold(\n        appBar: AppBar(\n          title: Text('Flutter Container Example'),\n        ),\n        body: Center(\n          child: Container(\n            width: 200.0,\n            height: 200.0,\n            color: Colors.green,\n            child: Text(\n              'Hello, Flutter!',\n              style: TextStyle(\n                fontSize: 30.0,\n                color: Colors.white,\n              ),\n            ),\n          ),\n        ),\n      ),\n    );\n  }\n}\n```\n\nNow the `Text` widget inside the `Container` has a font size of 30.0.");
  }

  //Generate Image
  List<Map<String, dynamic>> imagesChat = [];
  ImagesModel images = ImagesModel();

  generateImage(String prompt, String size) async {
    imagesChat.add({"role": "user", "content": prompt.toString()});
    notifyListeners();

    Map<String, dynamic> body = {"prompt": prompt, "n": 1, "size": size};
    print(body);
    try {
      final res = await postRequest("images/generations", body);
      var response = json.decode(res);
      ImagesModel data = ImagesModel.fromJson(response);
      if (data.data!.isEmpty) {
        my_toast("Sorry ! Try again", "error");
      } else {
        imagesChat.add({"role": "openai", "content": data.data![0].url});
      }
    } catch (e) {
      print(e.toString());
    }
  }

  bool animation = false;
  List<Map<String, dynamic>> messages = [];

  //Send Message With chat Completion("TO CHAT WITH Rember history")
  postMessage(String message) async {
    //We add message to old conversa
    messages.add({"role": "user", "content": message.toString()});
    notifyListeners();
    Map<String, dynamic> body = {
      "model": "gpt-3.5-turbo",
      "messages": messages
    };

    final res = await postRequest("chat/completions", body);
    var response = json.decode(res);
    setAnimation();
    messages.add(response["choices"][0]["message"]);
    notifyListeners();
    print(response["choices"][0]["message"].toString());
  }

  setAnimation() {
    animation = !animation;
    notifyListeners();
  }

  List<Map<String, dynamic>> textCodeResponse = [];
  makeTextAndCodeSeprate(String? text) {
    //to extract if response have codes
    //to create a list with all content
    List<Map<String, dynamic>> finalData = [];
    List<Map<String, dynamic>> finalData2 = [];
    String response = text!.trim();
    dynamic matches = "```".allMatches(text);
    List<int> lists = [];
    for (final Match m in matches) {
      if (lists.length.isOdd) {
        finalData.add({"start": lists[0], "end": m.start});
        lists.clear();
      } else {
        lists.add(m.start);
      }
    }
    print(finalData);

    for (int i = 0; i < finalData.length; i++) {
      if (finalData[i]['start'] != 0 && finalData2.length == 0) {
        finalData2.add({
          "start": 0,
          "end": finalData[i]['start'],
          "type": "text",
          "content": response.substring(0, finalData[i]['start'])
        });
      }
      if (finalData2.isNotEmpty &&
          finalData2.last['end'] != finalData[i]['start']) {
        finalData2.add({
          "start": finalData2.last['end'],
          "end": finalData[i]['start'],
          "type": "text",
          "content":
              response.substring(finalData2.last['end'], finalData[i]['start'])
        });
      }
      finalData2.add({
        "start": finalData[i]['start'],
        "end": finalData[i]['end'] + 3,
        "type": "code",
        "content":
            response.substring(finalData[i]['start'], finalData[i]['end'] + 3)
      });
      if (response
                  .substring(finalData2.last['end'], response.length)
                  .contains("```") ==
              false &&
          finalData2.last['end'] < response.length) {
        finalData2.add({
          "start": finalData2.last['end'],
          "end": response.length,
          "type": "text",
          "content": response.substring(finalData2.last['end'], response.length)
        });
      }
    }
    return finalData2;
  }
}
