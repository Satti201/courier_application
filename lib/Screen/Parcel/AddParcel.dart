import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:courier_application/Models/AllCategory.dart';
import 'package:courier_application/Provider/CategoryProvider.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
  List<AllCategory> catlist;

  AddParcel(this.list, this.catlist);

  @override
  State<AddParcel> createState() => _AddParcelState();
}

class _AddParcelState extends State<AddParcel> {
  final _AddCategoryFormKey = GlobalKey<FormState>();
  final isLoading = false;
  AllUserData? value;
  AllCategory? value1;
  TimeOfDay selectedTime = TimeOfDay.now();
  late ParcelProvider parcelProvider1;
  late SignInProvider signInProvider;
  late CategoryProvider categoryProvider;
  List<AllUserData> allList = [];
  List<AllCategory> allCategoryList = [];
  late int count;
  String _updatedCategory = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  bool get hasFocus => false;

  bool isClicked = false;
  bool avialInsurence=false;

  @override
  Widget build(BuildContext context) {
    parcelProvider1 = Provider.of(context);
    categoryProvider=Provider.of(context);
    parcelProvider1.getParcelData();
    categoryProvider.getCategory();
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
                const SizedBox(height: kDefaultSpacing * 1.5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.category,
                        size: 28,
                        color: Colors.black54,
                      ),
                    ),
                    DropdownButtonHideUnderline(
                      child: DropdownButton<AllCategory>(
                        hint: const Text('Select Category'),
                        dropdownColor: Colors.white,
                        value: value1,
                        icon: const Icon(Icons.keyboard_arrow_down),
                        items: widget.catlist
                            .map(
                              (AllCategory item) => DropdownMenuItem(
                                value: item,
                                child: Text(
                                  item.categoryName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (value) => setState(() {
                          this.value1 = value!;
                        }),
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          setState(() {
                            isClicked = true;
                          });
                          if (isClicked == true) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) => Dialog(
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
                                elevation: 8,

                                child: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  margin: const EdgeInsets.fromLTRB(
                                      10, 20, 10, 20),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Text(
                                        'Add Category',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      TextField(
                                        controller: categoryProvider.categoryName,
                                        keyboardType: TextInputType.text,
                                        textInputAction: TextInputAction.next,
                                        decoration: const InputDecoration(
                                          //icon: Icon(Icons.alternate_email),
                                          hintText: "Category Name",
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Wrap(
                                        direction: Axis.horizontal,
                                        alignment: WrapAlignment.spaceEvenly,
                                        spacing: 10.0,
                                        runSpacing: 20.0,
                                        children: [
                                          ElevatedButton(
                                              onPressed: () async {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text('Cancel')),
                                          ElevatedButton(
                                            onPressed: () async {
                                              if (_updatedCategory == null) {
                                                Fluttertoast.showToast(
                                                    msg:
                                                    "Please Select User ID from dropdown menu");
                                              } else {
                                                categoryProvider
                                                    .AddCategory(context,
                                                    _updatedCategory);
                                              }
                                            },
                                            child: const Text('Add'),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }
                        },
                        icon: const Icon(
                          Icons.add,
                        ))
                  ],
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
                  controller: parcelProvider1.Weight,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.timelapse),
                    hintText: "Wieght",
                  ),
                ),
                const SizedBox(height: kDefaultSpacing * 1.5),
                TextField(
                  controller: parcelProvider1.Dimensions,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.timelapse),
                    hintText: "Dimensions",
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

                SwitchListTile( //switch at right side of label
                    value: avialInsurence,
                    onChanged: (bool value){
                      if(avialInsurence==false) {
                        setState(() {
                          avialInsurence = true;//update value when switch changed
                        });
                      }else{
                        setState(() {
                          avialInsurence = false; //update value when switch changed
                        });
                      }
                    },
                    title: const Text("Avail Insurance!"),
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
                    if (value == null || value1==null) {
                      Fluttertoast.showToast(
                          msg: "Please Select User ID from dropdown menu");
                    } else {
                      if(avialInsurence==true){
                        double insurance=3/100* double.parse(parcelProvider1.ParcelPrice.text.toString());
                        parcelProvider1.ParcelInsurance.text=insurance.toString();
                      }else{
                        parcelProvider1.ParcelInsurance.text="";
                      }
                      parcelProvider1.AddParcel(context,value1!.categoryName, value!.UserId, count);
                    }
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
