import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../EditField/Colors.dart';
import '../../Models/ParcelData.dart';
import '../../Provider/ParcelProvider.dart';
import '../../Widgets/DrawerSide.dart';
import '../../Widgets/SingleParcelItem.dart';

class MyParcel extends StatefulWidget {
  const MyParcel({Key? key}) : super(key: key);

  @override
  State<MyParcel> createState() => _MyParcelState();
}

class _MyParcelState extends State<MyParcel> {




 late ParcelProvider parcelProvider;

  late String initialParcelStatus;
  List<String> myParcelList=["0", "1", "2", "3"];

  @override
  void initState() {
    super.initState();
    // TODO: implement initState
    initialParcelStatus=myParcelList.first;
    parcelProvider.myParcelStatus=initialParcelStatus;
    parcelProvider.getMyParcelData();
  }

  @override
  Widget build(BuildContext context) {
     parcelProvider = Provider.of(context);
    parcelProvider.getMyParcelData();
    return Scaffold(
      drawer: DrawerSide(),
      appBar: AppBar(
        backgroundColor: scaffoldbackgroundColor,
        iconTheme: IconThemeData(color: textColor),
        title: const Text(
          "My Parcels",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: Icon(
                    Icons.social_distance_outlined,
                    size: 28,
                    color: Colors.black54,
                  ),
                ),

                DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    hint: const Text('Select Category'),
                    dropdownColor: Colors.white,
                    value: initialParcelStatus,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: myParcelList.map(
                          (String item) => DropdownMenuItem(
                        value: item,
                        child: Text(
                          item,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    )
                        .toList(),
                    onChanged: (value) => setState(() {
                      initialParcelStatus = value!;
                    }),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),

          ListView.builder(
              shrinkWrap: true,
              itemCount: parcelProvider.getReviewMyParcelData.length,
              itemBuilder: (context, index) {
                parcelProvider.myParcelStatus=initialParcelStatus;
                ParcelData parcelData = parcelProvider.getReviewMyParcelData[index];
                return ListTile(
                  title: Text(
                    parcelData.ParcelName,
                    textScaleFactor: 1.5,
                  ),
                  subtitle: Row(
                    children: [
                      Text("Insurance: "+parcelData.Insurance),
                      Text("Parcel Price: "+parcelData.ParcelPrice),
                      Text("PickUp Address: "+parcelData.PickUpAddress, maxLines: 3,),
                      Text("Receiver Address: "+parcelData.RecieverAddress, maxLines: 3,),
                    ],
                  ),
                );
              }),
        ],
      ),
    );
  }
}
