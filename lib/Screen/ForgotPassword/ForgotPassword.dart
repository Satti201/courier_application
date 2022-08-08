
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../EditField/app_snackbar.dart';
import '../../Service/auth_service.dart';
import '../../shared_components/async_button.dart';
import '../../shared_components/header_text.dart';

const kDefaultSpacing = 16.0;
const kBorderRadius = 16.0;

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final isLoading = false;
  final email = TextEditingController();
  AuthService auth = AuthService();


  String? isValidEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Email is required ";
    } else if (!value.isEmail) {
      return "Invalid Email";
    }
    return null;
  }

  String? isValidPassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Password is required";
    } else if (value.length > 10 || value.length < 5) {
      return "Password at least 5-10 character";
    } else if (value.split(" ").length > 1) {
      return "Invalid Password";
    }

    return null;
  }

  void submit() async {
    String? emailError = isValidEmail(email.text);

    if (emailError != null) {
      AppSnackbar.showMessage(emailError);
      return;
    }

    try {
      await auth.sendPasswordResetEmail(email.text);

      Get.back();
      AppSnackbar.showNotification(
        icon: const Icon(
          Icons.email,
          color: Colors.orange,
        ),
        title: "Check your email",
        message: "We already send a link to reset your password",
      );
    } on FirebaseAuthException catch (error) {
      switch (error.code) {
        case 'invalid-email':
          AppSnackbar.showMessage('Your email address is not valid.');
          break;

        case 'user-not-found':
          AppSnackbar.showMessage('User not found.');
          break;

        default:
          AppSnackbar.showMessage("Something Error!");
      }
    } catch (err) {
      AppSnackbar.showMessage("Something Error!");
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: SizedBox(
              height: Get.height,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: kDefaultSpacing * 2),
                  child: Column(
                    children: [
                      const Spacer(),
                      Image.asset(
                        "assets/email.png",
                        height: 200,
                      ),
                      const SizedBox(height: kDefaultSpacing),
                      Align(
                        alignment: Alignment.topLeft,
                        child: HeaderText("Forgot\nPassword ?"),
                      ),
                      const SizedBox(height: kDefaultSpacing * 1.5),
                      Text(
                        "Don't worry! Please enter the email address associated with your account.",
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey[700],
                        ),
                      ),
                      const Spacer(),
                      TextField(
                        controller: email,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.done,
                        decoration: const InputDecoration(
                          icon: Icon(Icons.alternate_email),
                          hintText: "Your Email",
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
                        onPressed: (){},
                        child: const Text("Submit"),
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SafeArea(
            child: Padding(
              padding: EdgeInsets.all(kDefaultSpacing / 2),
              child: BackButton(),
            ),
          ),
        ],
      ),
    );
  }
}
