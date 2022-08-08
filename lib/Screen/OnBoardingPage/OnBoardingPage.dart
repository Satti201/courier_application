
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../Widgets/entry_point.dart';
import '../../routes/app_pages.dart';

///Project Imports


class OnboardingPage extends StatefulWidget {
  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  @override
  Widget build(BuildContext context) {
    ///ScreenUtil for Responsive UI
    ScreenUtil.init(
      context,
      //For Redmi Note 9
      designSize: Size(
        392.72727272727275,
        850.9090909090909,
      ),
    );
    return WillPopScope(
      onWillPop: (){
         showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Confirm Exit App"),
                content: Text("Are you sure you want to exit app?"),
                actions: <Widget>[
                  FlatButton(
                    child: Text("YES"),
                    onPressed: () {
                      SystemNavigator.pop();
                    },
                  ),
                  FlatButton(
                    child: Text("NO"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              );
            }
        );
        return Future.value(true);
      },
      child: SafeArea(
        child: Scaffold(
            body: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              padding: EdgeInsets.all(20.h),
              // color: Colors.teal[50],
              child: Center(
                child: Column(
                  children: [
                    SizedBox(
                      height: 40.h,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: EntryPoint(
                        title: "Customer",
                        lottiePath: "assets/lottieFiles/delivery_truck.json",
                        path: Routes.LOGIN,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),

                    SizedBox(
                      height: 30,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: EntryPoint(
                        title: "Admin",
                        lottiePath: "assets/lottieFiles/home-delivery.json",
                        path: Routes.Admin1,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          "SendNow",
                          style: TextStyle(
                            fontSize: 35,
                            fontFamily: 'Raleway',
                            color: Colors.black,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    Text(
                      "Select your role to continue...",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 15,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            )),
      ),
    );
  }
}
