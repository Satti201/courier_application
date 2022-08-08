
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../EditField/Colors.dart';
import '../Models/AllUserData.dart';
import '../Provider/SignInProvider.dart';
import '../Widgets/SingleParcelItem.dart';
import '../Widgets/SingleUserItem.dart';
class ShowUser extends StatefulWidget {
  const ShowUser({Key? key}) : super(key: key);

  @override
  State<ShowUser> createState() => _ShowUserState();
}

class _ShowUserState extends State<ShowUser> {
  @override
  Widget build(BuildContext context) {
    SignInProvider signInProvider = Provider.of(context);
    signInProvider.getAllUserDataEntry();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: scaffoldbackgroundColor,
        iconTheme: IconThemeData(color: textColor),
        title: Text("Show User", style: TextStyle(color: Colors.black),),
      ),
      body:   ListView.builder(
          itemCount: signInProvider.getuserlists.length,
          itemBuilder: (context,index) {
            AllUserData parcelData = signInProvider.getuserlists[index];
            return Column(
              children: [
                SizedBox(height: 10,),
                SingleUserItem(
                  parcelData.Username,
                  parcelData.Email,
                ),
              ],
            );
          }
      ),
    );
  }
}
