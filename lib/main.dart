import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chatgpt/chatscreen.dart';
import 'package:flutter_chatgpt/helpers/constant.dart';
import 'package:flutter_chatgpt/helpers/openApiconfig.dart';
import 'package:flutter_chatgpt/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const SplashScreen());
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<MainProvider>(
              lazy: false, create: (_) => MainProvider()),
        ],
        child: ScreenUtilInit(
            designSize: const Size(375, 667),
            minTextAdapt: true,
            splitScreenMode: true,
            builder: (context, child) {
              return GetMaterialApp(
                  debugShowCheckedModeBanner: false,
                  home: Scaffold(
                    body: Container(
                      // color: main_color,
                      // height: MediaQuery.of(context).size.height,
                      child: 
                      Center(
                        child: AnimatedTextKit(
                          animatedTexts: [
                            TypewriterAnimatedText(
                              appName.toString(),
                              speed: Duration(milliseconds: 100),
                              textStyle: TextStyle(
                                  color: Colors.grey.shade500.withOpacity(0.5),
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                          repeatForever: false,
                          isRepeatingAnimation: false,
                          totalRepeatCount: 1,
                          onFinished: () {
                            Get.to(ChatScreen());
                          },
                        ),
                      ),
                    ),
                  ));
            }));
  }
}
