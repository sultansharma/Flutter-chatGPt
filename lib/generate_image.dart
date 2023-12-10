import 'package:flutter/material.dart';
import 'package:flutter_chatgpt/helpers/constant.dart';
import 'package:flutter_chatgpt/helpers/openApiconfig.dart';
import 'package:flutter_chatgpt/message.dart';
import 'package:flutter_chatgpt/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ImageScreen extends StatefulWidget {
  const ImageScreen({Key? key}) : super(key: key);

  @override
  State<ImageScreen> createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen> {
  TextEditingController _text = TextEditingController();
  bool loading = false;
  String selectedSize = "";
  void sizeSheet() {
    showModalBottomSheet<void>(
        isScrollControlled: true,
        //  barrierColor: Colors.white.withOpacity(0.10),
        context: context,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0)),
        ),
        builder: (BuildContext context) {
          return Container(
            height: 150,
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                nText("Select Size", w: FontWeight.bold),
                Container(
                  height: 80,
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      sizeBox("256x256"),
                      sizeBox("512x512"),
                      sizeBox("1024x1024"),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  sizeBox(String size) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedSize = size;
          Navigator.pop(context);
        });
      },
      child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: selectedSize == size ? mainColor : Colors.white,
              border: Border.all(
                  color:
                      selectedSize == size ? mainColor : Colors.grey.shade300)),
          child: Center(
              child: nText(size,
                  clr: selectedSize == size ? Colors.white : Colors.black,
                  w: selectedSize == size ? FontWeight.bold : null))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MainProvider>(
      builder: (_, data, __) => Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: Column(
              children: [
                Text(
                  appName,
                  style: TextStyle(color: Colors.black),
                ),
                Text("Generate Images",
                    style: TextStyle(
                        color: Colors.black.withOpacity(0.5), fontSize: 12))
              ],
            ),
          ),
          body: SafeArea(
              child: Column(
            children: [
              Expanded(
                child: data.imagesChat.isEmpty
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
                          final reversedIndex = data.imagesChat.length - 1 - i;
                          var d = data.imagesChat[reversedIndex];

                          return message(d['content'], d['role'], data);
                        },
                        itemCount: data.imagesChat.length,
                      ),
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      sizeSheet();
                    },
                    child: Container(
                        margin: EdgeInsets.only(left: 20),
                        child: Icon(Icons.height)),
                  ),
                  Expanded(
                      child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade300)),
                    child: Row(
                      children: [
                        Flexible(
                            child: TextFormField(
                          controller: _text,
                          decoration: InputDecoration(
                              hintText: "Write a prompt",
                              border: InputBorder.none),
                          maxLines: null,
                        )),
                        InkWell(
                          onTap: () async {
                            if (selectedSize.isEmpty) {
                              my_toast("Please Select a Size", "error");
                              return;
                            }
                            setState(() {
                              loading = true;
                            });
                            await data.generateImage(_text.text, selectedSize);
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
    );
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
        child: by == "user"
            ? nText(message.toString())
            : Stack(
                children: [
                  Container(
                    // height: 300,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: Image.network(
                          message.toString(),
                          fit: BoxFit.contain,
                        )),
                  ),
                  Positioned(
                      top: 5,
                      right: 5,
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                            color: Colors.amberAccent,
                            borderRadius: BorderRadius.circular(5)),
                        child: Row(
                          children: [
                            // nText(text),
                            Icon(
                              Icons.download,
                              size: 15,
                            ),
                          ],
                        ),
                      ))
                ],
              ));
  }
}
