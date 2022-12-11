
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import '../../EditField/Colors.dart';
import '../Parcel/Parcel.dart';
import '../Parcel/AddParcel.dart';
import '../../RoughWork/ShowUser.dart';
enum Page { dashboard, manage }
class Admin extends StatefulWidget {
  @override
  AdminState createState() => AdminState();
}

class AdminState extends State<Admin> {
  MaterialColor active = Colors.red;
  MaterialColor notActive = Colors.grey;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: scaffoldbackgroundColor,
          iconTheme: IconThemeData(color: textColor),
          title: Text("Admin", style: TextStyle(color: Colors.black),),
        ),
        body: _loadScreen()
    );
  }

  Widget _loadScreen() {
    return Container(
      child: Column(
        children: <Widget>[
          Expanded(
            child: GridView(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 10,top: 22,bottom: 22,left: 12),
                  child: GestureDetector(
                    onTap: (){
                   //   Navigator.of(context).push(MaterialPageRoute(builder: (context)=> AddParcel()));
                    },
                    child: Card(
                      child: ListTile(
                          title: Center(
                            child: Center(
                              child: TextButton.icon(
                                  onPressed: null,
                                  icon: Icon(Icons.add),
                                  label: Text("Parcel" , style: TextStyle(fontSize: 20 , fontWeight: FontWeight.bold , color: Colors.redAccent),)),
                            ),
                          ),
                        ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 12,top: 22,bottom: 22),
                  child: GestureDetector(
                    onTap: (){
                  //    Navigator.of(context).push(MaterialPageRoute(builder: (context)=> ShowUser()));
                    },
                    child: Card(
                      child: ListTile(
                          title: Center(
                            child: TextButton.icon(
                                onPressed: null,
                                icon: Icon(Icons.category),
                                label: Text("Drivers",style: TextStyle(fontSize: 20 , fontWeight: FontWeight.bold , color: Colors.redAccent),)),
                          ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 12,top: 22,bottom: 22,left: 11),
                  child: GestureDetector(
                    onTap: (){
                    //  Navigator.of(context).push(MaterialPageRoute(builder: (context) => TrackParcel()));
                    },
                    child: Card(
                      child: ListTile(
                          title: Center(
                            child: TextButton.icon(
                                onPressed: null,
                                icon: Icon(Icons.track_changes),
                                label: Text("Track ",style: TextStyle(fontSize: 20 , fontWeight: FontWeight.bold , color: Colors.redAccent),)),
                          ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 12,top: 22,bottom: 22),
                  child: Card(
                    child: ListTile(
                        title: Center(
                          child: TextButton.icon(
                              onPressed: null,
                              icon: Icon(Icons.tag_faces),
                              label: Text("Sold",style: TextStyle(fontSize: 20 , fontWeight: FontWeight.bold , color: Colors.redAccent),)),
                        ),
                        ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 9,top: 22,bottom: 22,left: 11),
                  child: Card(
                    child: ListTile(
                        title: Center(
                          child: TextButton.icon(
                              onPressed: null,
                              icon: Icon(Icons.shopping_cart),
                              label: Text("Orders",style: TextStyle(fontSize: 20 , fontWeight: FontWeight.bold , color: Colors.redAccent),)),
                        ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 10,top: 22,bottom: 22),
                  child: Card(
                    child: ListTile(
                        title: Center(
                          child: TextButton.icon(
                              onPressed: null,
                              icon: Icon(Icons.close),
                              label: Text("Return",style: TextStyle(fontSize: 20 , fontWeight: FontWeight.bold , color: Colors.redAccent),)),
                        ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


}