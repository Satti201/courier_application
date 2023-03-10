import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../EditField/Colors.dart';
import '../../Models/ParcelData.dart';
import '../../Provider/ParcelProvider.dart';
import '../../Widgets/DrawerSide.dart';
import '../../Widgets/SingleParcelItem.dart';

class Parcel extends StatefulWidget {
  const Parcel({Key? key}) : super(key: key);

  @override
  State<Parcel> createState() => _ParcelState();
}

class _ParcelState extends State<Parcel> {



  late String initialDist;
  List<String> disList=["1", "2", "10"];

  @override
  void initState() {
    super.initState();
    // TODO: implement initState
    initialDist=disList.first;
  }

  @override
  Widget build(BuildContext context) {
    ParcelProvider parcelProvider = Provider.of(context);
    parcelProvider.getParcelData();
    return Scaffold(
      drawer: DrawerSide(),
      appBar: AppBar(
        backgroundColor: scaffoldbackgroundColor,
        iconTheme: IconThemeData(color: textColor),
        title: const Text(
          "Parcels",
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
                    value: initialDist,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: disList.map(
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
                      initialDist = value!;
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
              itemCount: parcelProvider.getReviewCartData.length,
              itemBuilder: (context, index) {
              parcelProvider.disInMiles=initialDist;
                ParcelData parcelData = parcelProvider.getReviewCartData[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleParcelItem(
                    parcelData.ParcelName,
                    parcelData.PickUpAddress,
                    parcelData.RecieverAddress,
                    parcelData.orderid,
                    parcelData.ParcelPrice,
                    parcelData.Weight,
                    parcelData.Dimensions,
                    parcelData.username,
                  ),
                );
              }),
        ],
      ),
    );
  }
}
