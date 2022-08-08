import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'HomePage/HomePage.dart';
import 'OnBoardingPage/OnBoardingPage.dart';
class SplashScreen extends StatefulWidget {
  static bool loggendIn = false;
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if(SplashScreen.loggendIn == false)
      {

        Timer(Duration(seconds: 3),
                ()=>Get.to(()=>OnboardingPage()
            )
        );
      }
    else if (SplashScreen.loggendIn == true){
      Timer(Duration(seconds: 3),
              ()=>Get.to(()=>HomePage()
          )
      );
    }


  }
  @override
  Widget build(BuildContext context) {
    return  Container(
      decoration:  BoxDecoration(
        image:  DecorationImage(image: new AssetImage("assets/1.jpg"), fit: BoxFit.cover,),
      ),
    );
  }
}
