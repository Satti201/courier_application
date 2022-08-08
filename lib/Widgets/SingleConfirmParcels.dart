
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import '../shared_components/async_button.dart';


class SingleConfirmParcels extends StatefulWidget {

  String ParcelName;
  int orderid;
  String Address;
  String Dest_latitude;
  String Dest_longituge;
  String Current_Lat;
  String Current_Long;
  String Status;
  String UserId;


  SingleConfirmParcels(
      this.ParcelName,
      this.orderid,
      this.Address,
      this.Dest_latitude,
      this.Dest_longituge,
      this.Status,
      this.UserId,
      this.Current_Lat,
      this.Current_Long,);

  @override
  State<SingleConfirmParcels> createState() => _SingleConfirmParcelsState();
}

class _SingleConfirmParcelsState extends State<SingleConfirmParcels> {

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
                      height: 120,
                      child: Row(
                        mainAxisAlignment:MainAxisAlignment.spaceBetween ,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("User Id :${widget.UserId}",
                                style:  TextStyle(color: Colors.black , fontWeight: FontWeight.bold),),
                              SizedBox(height: 10,),
                              Text("Order Id :${widget.orderid}",
                                style:  TextStyle(color: Colors.black , fontWeight: FontWeight.bold),),
                              SizedBox(height: 10,),
                              Text("Parcel Name :${widget.ParcelName}",
                                style:  TextStyle(color: Colors.black , ),),
                              SizedBox(height: 10,),
                              Text("Address :${widget.Address}",
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

                            },
                            child: const Text("Track"),

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

