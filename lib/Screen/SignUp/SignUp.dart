
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';

import '../../EditField/Colors.dart';
import '../../Provider/SignInProvider.dart';
import '../../Provider/SignUpProvider.dart';
import '../../shared_components/async_button.dart';
import '../../shared_components/header_text.dart';
import '../Login/LoginScreen.dart';
import '../PhoneAuthentication/PhoneAuthentication.dart';
const kDefaultSpacing = 16.0;
const kBorderRadius = 16.0;
enum AddressTypes{
  Male,
  Female,
}
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  var myType = AddressTypes.Male;
  final isLoading = false;
  @override
  Widget build(BuildContext context) {
    SignUpProvider signUpProvider = Provider.of(context);
    return Scaffold(
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
                    height: 170,
                  ),
                  const SizedBox(height: kDefaultSpacing),
                  Align(
                    alignment: Alignment.topLeft,
                    child: HeaderText("Sign Up"),
                  ),
                  const SizedBox(height: kDefaultSpacing * 1),
                  TextField(
                    controller: signUpProvider.Username,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.person),
                      hintText: "Username",
                    ),
                  ),
                  const SizedBox(height: kDefaultSpacing * 1),
                  TextField(
                    controller: signUpProvider.email,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.alternate_email),
                      hintText: "Email",
                    ),
                  ),
                  const SizedBox(height: kDefaultSpacing),
                  TextField(
                    controller: signUpProvider.password,
                    obscureText: true,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.lock_outline_rounded),
                      hintText: "Password",
                    ),
                  ),
                  const SizedBox(height: kDefaultSpacing * 1),
                  TextField(
                    controller: signUpProvider.PhoneNo,
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.phone),
                      hintText: "PhoneNo",
                    ),
                  ),
                  const SizedBox(height: kDefaultSpacing * 1),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text('Gender:', style: TextStyle(fontSize: 18)),
                      Container(
                        child: Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 1,
                                  child: RadioListTile(
                                    value: AddressTypes.Male,
                                    groupValue: myType,
                                    title: Text("Male"),
                                      activeColor: Colors.red,
                                      selected: true,
                                    onChanged: ( value){
                                      setState(() {
                                        myType = value as AddressTypes;
                                      });
                                    }

                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: RadioListTile(
                                    value: AddressTypes.Female,
                                    groupValue: myType,
                                    activeColor: Colors.red,
                                      selected: false,
                                    title: Text("Female"),
                                    onChanged: ( value){
                                      setState(() {
                                        myType = value as AddressTypes;
                                      });
                                    }


                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

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
                      signUpProvider.getCurrentPositionf();
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=> PhoneAuthentication(
                        signUpProvider.PhoneNo,
                        signUpProvider,
                        myType.name.toString(),
                      )));

                    },
                    child: const Text("Sign Up"),
                  ),
                  const SizedBox(height: kDefaultSpacing * 1),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account?",
                        style: Theme.of(context).textTheme.caption?.copyWith(fontSize: 14),
                      ),
                      TextButton(
                        onPressed: (){
                          Get.to(()=>SignIn());
                        },
                        child: const Text("Sign In"),
                      )
                    ],
                  ),
                 // const SizedBox(height: kDefaultSpacing),
                ],
              ),

            ),
          ),
        ),
      ),

    );
  }
}
