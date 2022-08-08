import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Click extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Test(),
    );
  }
}

class Test extends StatefulWidget {
  @override
  _Test createState() => _Test();
}

class _Test extends State<Test> {

   File? imageFile;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: InkWell(
        onTap: (){
          getImage();
        },
        child: Icon(
            Icons.add
        ),
      ),
      body: Center(
        child: root(),
      ),
    );
  }

  Widget root() {
    return Container(
      child: imageFile != null
          ? Image.file(
        imageFile!,
        height: MediaQuery
            .of(context)
            .size
            .height / 5,
      )
          : Text("Pick up the  image"),
    );
  }

}