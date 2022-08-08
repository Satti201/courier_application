
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';

import '../../Provider/SignInProvider.dart';
import '../../Service/auth_service.dart';
import '../../shared_components/async_button.dart';
import '../../shared_components/header_text.dart';
import '../ForgotPassword/ForgotPassword.dart';
import '../OnBoardingPage/OnBoardingPage.dart';
import '../SignUp/SignUp.dart';

const kDefaultSpacing = 16.0;
const kBorderRadius = 16.0;
class SignIn extends StatefulWidget {


  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  AuthService authService = AuthService();
  @override
  Widget build(BuildContext context) {
    SignInProvider signInProvider = Provider.of(context);
    return WillPopScope(
      onWillPop: (){
        Navigator.of(context).push(MaterialPageRoute(builder: (context)=> OnboardingPage()));
        return Future.value(true);
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: SizedBox(
            height: Get.height,
            child: SafeArea(
              child: Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: kDefaultSpacing * 2),
                child: Column(
                  children: [
                    const SizedBox(height: kDefaultSpacing),
                    Image.asset(
                      "assets/relax.png",
                      height: 200,
                    ),
                    const SizedBox(height: kDefaultSpacing),
                    Align(
                      alignment: Alignment.topLeft,
                      child: HeaderText("Sign In"),
                    ),
                    const SizedBox(height: kDefaultSpacing * 1.5),
                    TextField(
                      controller: signInProvider.email,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.alternate_email),
                        hintText: "Email",
                      ),
                    ),
                    const SizedBox(height: kDefaultSpacing),
                    TextField(
                      controller: signInProvider.password,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.lock),
                        hintText: "Password",
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: TextButton(
                        onPressed: (){
                          Get.to(()=>ForgotPassword());
                        },
                        child: const Text("Forgot Password"),
                      ),
                    ),

                    const Spacer(),
                    AsyncButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.maxFinite, 50),
                        textStyle: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.1,
                        ),
                      ),
                      onPressed: (){
                        signInProvider.SignIn(context);

                     //   Navigator.of(context).push(MaterialPageRoute(builder: (context)=>CustomGoogleMap()));
                      },
                      child: const Text("Sign In"),

                    ),
                    const Spacer(flex: 2),
                    Row(
                      children: const [
                        Expanded(
                          child: Divider(
                            endIndent: kDefaultSpacing,
                            thickness: 1,
                          ),
                        ),
                        Text(
                          "Or continue with",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            indent: kDefaultSpacing,
                            thickness: 1,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: kDefaultSpacing),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CircleAvatar(
                          radius: 22,
                          backgroundColor: Colors.grey[200],
                          child: IconButton(
                            onPressed: (){},
                            icon: Image.asset("assets/google.png"),
                            tooltip: "Google",
                          ),
                        ),
                        CircleAvatar(
                          radius: 22,
                          backgroundColor: Colors.grey[200],
                          child: IconButton(
                            onPressed: (){
                          //    Get.to(()=>PhoneAuthentication(""));
                            },
                            icon: Icon(
                              Icons.phone,
                              color: Colors.grey[800],
                            ),
                            tooltip: "Phone",
                          ),
                        ),

                      ],
                    ),
                    const Spacer(flex: 2),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account?",
                          style: Theme.of(context).textTheme.caption?.copyWith(fontSize: 14),
                        ),
                        TextButton(
                          onPressed: (){
                            Get.to(()=>SignUpScreen());
                          },
                          child: const Text("Sign Up"),
                        )
                      ],
                    ),
                    const SizedBox(height: kDefaultSpacing),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
