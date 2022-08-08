
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../EditField/Colors.dart';
import '../Provider/ParcelProvider.dart';
import '../Widgets/SingleConfirmParcels.dart';
import '../Widgets/SingleParcelItem.dart';
import 'ConfirmParcel.dart';
class TrackParcel extends StatefulWidget {
  const TrackParcel({Key? key}) : super(key: key);

  @override
  State<TrackParcel> createState() => _TrackParcelState();
}

class _TrackParcelState extends State<TrackParcel> {
  @override
  Widget build(BuildContext context) {
    ParcelProvider parcelProvider = Provider.of(context);
    parcelProvider.getallconfirmedParcelDetails();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: scaffoldbackgroundColor,
        iconTheme: IconThemeData(color: textColor),
        title: Text("Track Parcel", style: TextStyle(color: Colors.black),),
      ),
      body:   ListView.builder(
          itemCount: parcelProvider.getConfirmedParcelData.length,
          itemBuilder: (context,index) {
            ConfirmParcelData parcelData = parcelProvider.getConfirmedParcelData[index];
            return Column(
              children: [
                SizedBox(height: 10,),
                SingleConfirmParcels(
                    parcelData.ParcelName,
                    parcelData.orderid,
                    parcelData.Address,
                    parcelData.Dest_latitude,
                    parcelData.Dest_longituge,
                    parcelData.Status,
                    parcelData.Userid,
                    parcelData.Currtent_Location_Lat,
                   parcelData.Currtent_Location_Long,

                ),
              ],
            );
          }
      ),
    );
  }
}
