import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

import '../../EditField/Colors.dart';
import '../../Models/AllUserData.dart';
import '../../Provider/ParcelProvider.dart';
import '../../Provider/SignInProvider.dart';
import '../../Widgets/DrawerSide.dart';
import '../../shared_components/async_button.dart';
import '../../shared_components/header_text.dart';
import '../Login/LoginScreen.dart';

const kDefaultSpacing = 16.0;
const kBorderRadius = 16.0;

class AddParcel extends StatefulWidget {
  List<AllUserData> list;

  AddParcel(this.list);

  @override
  State<AddParcel> createState() => _AddParcelState();
}

class _AddParcelState extends State<AddParcel> {
  final isLoading = false;
  AllUserData? value;
  TimeOfDay selectedTime = TimeOfDay.now();
  late ParcelProvider parcelProvider1;
  late SignInProvider signInProvider;
  List<AllUserData> allList = [];
  late int count;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  bool get hasFocus => false;

  @override
  Widget build(BuildContext context) {
    parcelProvider1 = Provider.of(context);
    parcelProvider1.getParcelData();
    count = parcelProvider1.getReviewCartData.length;
    count = count + 1;

    return Scaffold(
      drawer: DrawerSide(),
      appBar: AppBar(
        backgroundColor: scaffoldbackgroundColor,
        iconTheme: IconThemeData(color: textColor),
        title: const Text(
          " Add Parcel",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: kDefaultSpacing * 2),
            child: Column(
              children: [
                const SizedBox(height: kDefaultSpacing),
                Image.asset(
                  "assets/relax.png",
                  height: 150,
                ),
                const SizedBox(height: kDefaultSpacing),
                const Align(
                  alignment: Alignment.topLeft,
                  child: HeaderText("Add Parcel"),
                ),
                /*const SizedBox(height: kDefaultSpacing * 1.5),
                TextFormField(
                  key: Key(count.toString()),
                  enableInteractiveSelection: false,
                  onTap: () {
                    setState(() {
                      TextEditingController().text = count.toString();
                    });
                  },
                  initialValue: count.toString(),
                  readOnly: true,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.person),
                    hintText: "Order Id",
                  ),
                ),*/
                const SizedBox(height: kDefaultSpacing * 1.5),
                TextField(
                  controller: parcelProvider1.ParcelName,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.alternate_email),
                    hintText: "Parcel Name",
                  ),
                ),
                const SizedBox(height: kDefaultSpacing),
                TextField(
                  controller: parcelProvider1.PickUpAddress,
                  keyboardType: TextInputType.streetAddress,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.streetview),
                    hintText: "PickUp Address",
                  ),
                ),
                const SizedBox(height: kDefaultSpacing),
                TextField(
                  controller: parcelProvider1.ReciverAddress,
                  keyboardType: TextInputType.streetAddress,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.streetview),
                    hintText: "Reciever Address",
                  ),
                ),
                const SizedBox(height: kDefaultSpacing * 1.5),
                TextField(
                  controller: parcelProvider1.Time,
                  keyboardType: TextInputType.datetime,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.timelapse),
                    hintText: "Time Hour:Minutes",
                  ),
                ),
                const SizedBox(height: kDefaultSpacing * 1.5),
                TextField(
                  controller: parcelProvider1.ParcelPrice,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.price_check),
                    hintText: "\$ Parcel Price",
                  ),
                ),
                const SizedBox(height: kDefaultSpacing * 1.5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      child: IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.person_outlined,
                            size: 28,
                            color: Colors.black54,
                          )),
                    ),
                    DropdownButtonHideUnderline(
                      child: DropdownButton<AllUserData>(
                        hint: const Text('Select User ID'),
                        dropdownColor: Colors.white,
                        value: value,
                        icon: const Icon(Icons.keyboard_arrow_down),
                        items: widget.list
                            .map(
                              (AllUserData item) => DropdownMenuItem(
                                value: item,
                                child: Text(
                                  item.UserId,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (value) => setState(() {
                          this.value = value!;
                        }),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: kDefaultSpacing * 1.5),
                AsyncButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.maxFinite, 50),
                    textStyle: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.1,
                    ),
                  ),
                  onPressed: () {
                    parcelProvider1.AddParcel(context, value!.UserId, count);
                  },
                  child: const Text("Add Parcel"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _selectTime(BuildContext context) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      initialEntryMode: TimePickerEntryMode.dial,
    );
    if (timeOfDay != null && timeOfDay != selectedTime) {
      setState(() {
        selectedTime = timeOfDay;
      });
    }
  }
}
