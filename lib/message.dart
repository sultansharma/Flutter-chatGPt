import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chatgpt/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class MessageScreen extends StatefulWidget {
  final String? message;
  final String? by;
  final int index;

  const MessageScreen(
      {Key? key, required this.message, required this.by, required this.index})
      : super(key: key);

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  String animation = "not_start";
  @override
  Widget build(BuildContext context) {
    return Consumer<MainProvider>(
        builder: (_, data, __) => message(widget.message, widget.by, data));
  }

  message(String? message, String? by, MainProvider data) {
    return Container(
        margin: EdgeInsets.only(
            left: by == "user" ? 70 : 5, right: by == "user" ? 5 : 40, top: 10),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(by == "user" ? 10 : 0),
                topRight: Radius.circular(10),
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10)),
            color: by == "user" ? Colors.amber : Colors.grey.shade300),
        child: data.animation == false
            ? oneMessage(message, data)
            : widget.index + 1 == data.messages.length
                ? AnimatedTextKit(
                    animatedTexts: [
                      TypewriterAnimatedText(message.toString(),
                          speed: Duration(milliseconds: 10)),
                    ],
                    repeatForever: false,
                    isRepeatingAnimation: false,
                    totalRepeatCount: 1,
                    onFinished: () {
                      data.setAnimation();
                      // print("completed");
                      // setState(() {
                      //   animation = "completed";
                      // });
                    },
                  )
                : oneMessage(message, data));
  }

  oneMessage(String? message, MainProvider data) {
    return message!.contains("```")
        ? codeMessage(
            data.makeTextAndCodeSeprate(message),
          )
        : Text(message);
  }

  codeMessage(List<Map<dynamic, dynamic>> message) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          //mainAxisSize: MainAxisSize.min,
          children: message
              .map<Widget>((e) => Column(
                    //crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      e['type'] == "code"
                          ? Stack(
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.9),
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Text(
                                      e["content"].toString().substring(3,
                                          e["content"].toString().length - 3),
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 13)),
                                ),
                                Positioned(
                                    top: 5,
                                    right: 5,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                          color: Colors.amberAccent,
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: Icon(
                                        Icons.copy,
                                        size: 10,
                                      ),
                                    ))
                              ],
                            )
                          : Container(
                              // try to change this.
                              //padding: EdgeInsets.all(10),
                              color: Colors.transparent,
                              // margin: EdgeInsets.only(right: 20, left: 4),
                              child: Text(e["content"].toString().substring(
                                  0, e["content"].toString().length - 3)),
                            ),
                    ],
                  ))
              .toList(),
        ),
      ),
    );
  }
}
