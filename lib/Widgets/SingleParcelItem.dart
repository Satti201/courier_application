import 'dart:io';


import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

import '../Provider/SignUpProvider.dart';
import '../RoughWork/Roughs.dart';
import '../shared_components/async_button.dart';


class SingleParcelItem extends StatefulWidget {

  String ParcelName;

  String PickupAddress;
  String RecieverAddress;
  int orderid;
  String ParcelPrice;


  SingleParcelItem(this.ParcelName, this.PickupAddress, this.RecieverAddress,
      this.orderid, this.ParcelPrice);

  @override
  State<SingleParcelItem> createState() => _SingleParcelItemState();
}

class _SingleParcelItemState extends State<SingleParcelItem> {

  var _storedImage;

    File? imageFile ;
    PickedFile?  pickedFile;
    bool val = false;
  Widget build(BuildContext context) {
    SignUpProvider passportId = Provider.of(context);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 10 ,top: 10),
                    child: Container(
                      height: 150,
                      child: Row(
                        mainAxisAlignment:MainAxisAlignment.spaceBetween ,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Order Id :${widget.orderid}",
                                style:  TextStyle(color: Colors.black , fontWeight: FontWeight.bold),),
                              SizedBox(height: 10,),
                              Text(widget.ParcelName,
                                style:  TextStyle(color: Colors.black , ),),
                              SizedBox(height: 10,),
                              Text("PickUp Address :${widget.PickupAddress}",
                                maxLines: 4,
                                overflow: TextOverflow.ellipsis,
                                style:  TextStyle(color: Colors.black , fontSize: 14),),
                              SizedBox(height: 10,),
                              Text("RecieverAddress :${widget.RecieverAddress}",
                                maxLines: 4,
                                overflow: TextOverflow.ellipsis,
                                style:  TextStyle(color: Colors.black , fontSize: 14),),
                              SizedBox(height: 10,),
                              Text("Doller Price: ${widget.ParcelPrice} \$",
                                style:  TextStyle(color: Colors.black , fontSize: 14),),

                            ],
                          ),
                          AsyncButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(20, 30),
                              textStyle: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.1,
                              ),
                            ),
                            onPressed: (){
                              showDialog(
                                     context: context,
                                      barrierDismissible: false,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text("Add ID"),
                                          actions: <Widget>[

                                            Row(
                                              mainAxisAlignment:MainAxisAlignment.spaceBetween ,
                                             children: [
                                               FlatButton(
                                                 child: Text("Add"),
                                                 onPressed: () {
                                                   Navigator.of(context).push(MaterialPageRoute(builder: (context)=> Click()));
                                                 },
                                               ),
                                               FlatButton(
                                                 child: Text("NO"),
                                                 onPressed: () {
                                                   Navigator.of(context).pop();
                                                   passportId.Username.text="";
                                                 },
                                               ),
                                             ],
                                           )



                                          ],
                                        );
                                      }
                                  );




                            },
                            child: const Text("Accept"),
                          ),


                        ],
                      ),
                    ),
                  )
              ),



            ],
          ),
        ),
       Divider(
          height: 1,
          color: Colors.black54,
        )
      ],
    );
  }

  _getFromGallery() async {
     pickedFile = (await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    ))!;
    if (pickedFile != null) {
       imageFile = File(pickedFile!.path);
       val = true;
      print(imageFile!.path);
    }
  }
  _getFromCamera() async {
  pickedFile = (await ImagePicker().getImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    ))!;
    if (pickedFile != null) {
       imageFile = File(pickedFile!.path);
       val = true;
      print(imageFile!.path);
    }
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

