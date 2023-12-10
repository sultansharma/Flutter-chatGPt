import 'package:flutter/material.dart';
import 'package:flutter_chatgpt/helpers/constant.dart';
import 'package:flutter_chatgpt/helpers/openApiconfig.dart';
import 'package:flutter_chatgpt/generate_image.dart';
import 'package:flutter_chatgpt/message.dart';
import 'package:flutter_chatgpt/provider.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  ScrollController _controller = ScrollController();
  TextEditingController _text = TextEditingController();
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return Consumer<MainProvider>(
      builder: (_, data, __) => Scaffold(
          // drawer: AnimatedContainer(
          //   duration: Duration(milliseconds: 10),
          //   curve: Curves.easeIn,
          //   height: MediaQuery.of(context).size.height,
          //   width: MediaQuery.of(context).size.width * 0.70,
          //   decoration: BoxDecoration(color: Colors.white),
          //   child: Container(
          //     padding: EdgeInsets.only(top: 100),
          //     child: Text("Image Chat"),
          //   ),
          // ),
          appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.black),
            backgroundColor: Colors.white,
            title: Column(
              children: [
                Text(
                  appName,
                  style: TextStyle(color: Colors.black),
                ),
                Text("Text Chat",
                    style: TextStyle(
                        color: Colors.black.withOpacity(0.5), fontSize: 12))
              ],
            ),
            actions: [
              GestureDetector(
                onTap: () {
                  Get.to(ImageScreen());
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.black)),
                    child: Icon(Icons.photo_sharp, color: Colors.black),
                  ),
                ),
              )
            ],
          ),
          body: SafeArea(
              child: Column(
            children: [
              Expanded(
                child: data.messages.length == 0
                    ? Container(
                        height: MediaQuery.of(context).size.height,
                        child: Center(
                            child: Text(
                          appName,
                          style: TextStyle(
                              color: Colors.grey.shade500.withOpacity(0.5),
                              fontSize: 30,
                              fontWeight: FontWeight.bold),
                        )),
                      )
                    : ListView.builder(
                        reverse: true,
                        itemBuilder: (context, i) {
                          final reversedIndex = data.messages.length - 1 - i;
                          var d = data.messages[reversedIndex];

                          return MessageScreen(
                            by: d['role'],
                            index: reversedIndex,
                            message: d['content'],
                          );
                        },
                        itemCount: data.messages.length,
                      ),
              ),
              Row(
                children: [
                  Expanded(
                      child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade300)),
                    child: Row(
                      children: [
                        Flexible(
                            child: TextFormField(
                          controller: _text,
                          decoration: InputDecoration(
                              hintText: "Send a message",
                              border: InputBorder.none),
                          maxLines: null,
                        )),
                        InkWell(
                          onTap: () async {
                            setState(() {
                              loading = true;
                            });
                            await data.postMessage(_text.text);
                            setState(() {
                              _text.clear();
                              loading = false;
                            });
                          },
                          child: Center(
                            child: loading
                                ? SizedBox(
                                    height: 40,
                                    width: 40,
                                    child: Padding(
                                      padding: const EdgeInsets.all(3),
                                      child: CircularProgressIndicator(
                                        strokeWidth: 1.5,
                                        color: mainColor,
                                      ),
                                    ),
                                  )
                                : Icon(
                                    Icons.send,
                                    color: Colors.grey[400],
                                    size: 20,
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ))
                ],
              ),
            ],
          ))),

      //     CustomScrollView(
      //   controller: _controller,
      //   shrinkWrap: true,
      //   reverse: true,
      //   slivers: [
      //     SliverList(
      //         delegate: SliverChildBuilderDelegate((context, i) {
      // final reversedIndex = data.messages.length - 1 - i;
      // var d = data.messages[reversedIndex];

      //       //message(d['content'], d['role'], data)
      // return MessageScreen(
      //   by: d['role'],
      //   index: reversedIndex,
      //   message: d['content'],
      // );
      //     }, childCount: data.messages.length))
      //   ],
      // )

      // bottomNavigationBar: Container(
      //   margin: EdgeInsets.only(left: 20, bottom: 20, right: 20),
      //   decoration: BoxDecoration(
      //       border: Border.all(),
      //       borderRadius: BorderRadius.circular(10)),
      //   height: 50,
      //   width: MediaQuery.of(context).size.width,
      //   child: Row(
      //     children: [
      //       Expanded(
      //           child: Container(
      //         padding: EdgeInsets.symmetric(horizontal: 10),
      //         margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      //         decoration: BoxDecoration(
      //             borderRadius: BorderRadius.circular(10),
      //             border: Border.all(color: Colors.grey.shade300)),
      //         child: Row(
      //           children: [
      //             Flexible(
      //                 child: TextFormField(
      //               //controller: _msgController,
      //               decoration: InputDecoration(
      //                   hintText: "Write message",
      //                   border: InputBorder.none),
      //               maxLines: null,
      //             )),
      //             InkWell(
      //               onTap: () async {},
      //               child: Center(
      //                 child: Icon(
      //                   Icons.send,
      //                   color: Colors.grey[400],
      //                   size: 20,
      //                 ),
      //               ),
      //             ),
      //           ],
      //         ),
      //       ))
      //     ],
      //   ),
      // ),
    );
  }
}
