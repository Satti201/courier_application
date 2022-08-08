
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import '../shared_components/async_button.dart';


class SingleUserItem extends StatefulWidget {

  String Username;
  String Email;


  SingleUserItem(this.Username, this.Email);

  @override
  State<SingleUserItem> createState() => _SingleUserItemState();
}

class _SingleUserItemState extends State<SingleUserItem> {

  Widget build(BuildContext context) {

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
                      height: 110,
                      child: Row(
                        mainAxisAlignment:MainAxisAlignment.spaceBetween ,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              Text("Username :${widget.Username}",
                                style:  TextStyle(color: Colors.black , ),),
                              SizedBox(height: 10,),
                              Text("Address :${widget.Email}",
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
                               // Navigator.of(context).push(MaterialPageRoute(builder: (context)=>UserGoogleMap(
                               //   widget.Username
                               // )));
                            },
                            child: const Text("Locate"),

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
}

