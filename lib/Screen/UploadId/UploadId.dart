

import 'dart:io';

import 'package:courier_application/Provider/UploadIdProvider.dart';
import 'package:courier_application/Widgets/DrawerSide.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../EditField/Colors.dart';
class UploadId extends StatefulWidget {
  const UploadId({Key? key}) : super(key: key);

  @override
  State<UploadId> createState() => _UploadIdState();
}

class _UploadIdState extends State<UploadId> {
   File? imageFile ;
  @override
  Widget build(BuildContext context) {
    UploadIdProvider uploadIdProvider = Provider.of(context);
    return Scaffold(
      drawer: DrawerSide(),
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(bottom: 20),

        child: Padding(
          padding: const EdgeInsets.only(left: 20,right: 20),
          child: MaterialButton(
            height: 45,
            onPressed: (){
                   if(imageFile!.path == null){
                     Fluttertoast.showToast(msg: "Please Add The Id");
                   }
                   else{
                     uploadIdProvider.UserUploadId(context, imageFile!, 0);
                   }
            },
            child: Text("UPLOAD ID" , style: TextStyle(fontWeight: FontWeight.bold, color:  textColor , fontSize: 18),),
            color: primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: scaffoldbackgroundColor,
        iconTheme: IconThemeData(color: textColor),
        title: Text("Upload ID", style: TextStyle(color: Colors.black),),
      ),
      body:
      Center(
        child: Column(
          children: [
            SizedBox(height: 20,),
            InkWell(
              onTap: (){
                getImage();
              },
              child: CircleAvatar(
                radius: 150.0,
                backgroundColor: Colors.white54,
                child: ClipRRect(
                  child:imageFile != null
                      ? Image.file(
                    imageFile!,
                    height: MediaQuery
                        .of(context)
                        .size
                        .height * 25,
                  )
                      : Text("Pick up the  image"),
                  borderRadius: BorderRadius.circular(50.0),
                ),
              ),
            ),
            SizedBox(height: 20,),
            Center(
              child: Row(
                children: const [
                  Expanded(
                    child: Text("Note : The User Document ID Approved By Admin WithIn 3 Days Limits Wait For The Admin Response"),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
  Future getImage() async {
    final pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        imageFile = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }
}
