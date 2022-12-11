

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../RoughWork/GoogleMap/UserGoogleMap.dart';
class DetailMapShow extends StatefulWidget {
  String latitude;
  String Longitude;
  String Username;
  String Wieght;
  double reciverlat;
  double reclon;
  double picklat;
  double picklon;

  DetailMapShow(this.Wieght, this.latitude, this.Longitude, this.Username,
      this.reciverlat, this.reclon, this.picklat, this.picklon);


  @override
  _DetailMapShowState createState() => _DetailMapShowState();
}

class _DetailMapShowState extends State<DetailMapShow> {

  late  Duration countdownDuration=Duration();
  Duration duration = Duration();
  Timer? timer;

  bool countDown = true;
  bool timeEnd=false;
  void initState() {
    // TODO: implement initState
    super.initState();
    //_markers.addAll(list);
    setState(() {
      countdownDuration= Duration(minutes: 30);
    });
    startTimer();
    reset();
   // loadData();
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Confirm Cancellation"),
              content: const Text("Are you sure, you want to cancel this Parcel?"),
              actions: <Widget>[
                TextButton(
                  child: const Text("YES"),
                  onPressed: () {
                    setState(() {
                      reset();
                      timer!.cancel();
                    });
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text("NO"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
      return Future.value(true);
    },
      child: Scaffold(
        body: Column(
         children: [
           Padding(
             padding: const EdgeInsets.only(left: 120 , top: 90),
             child: Align(
               alignment: Alignment.topCenter,
               // add your floating action button
               child: Row(
                 children: [
                   buildTime(),
                 ],
               ),
             ),
           ),
           Padding(
             padding: const EdgeInsets.only( top: 490),
             child: InkWell(
               onTap: (){
                 Navigator.of(context).push(MaterialPageRoute(
                     builder: (context) => UserGoogleMap(
                         widget.Wieght.toString(),
                         widget.latitude.toString(),
                         widget.Longitude.toString(),
                         "Usama",
                         widget.picklat,
                         widget.picklon,
                         widget.reciverlat,
                         widget.reclon)));
               },
               child: Padding(
                 padding: const EdgeInsets.symmetric(vertical: 10 , horizontal: 30),
                 child: Container(
                   height: 40,

                   decoration: BoxDecoration(
                       color: Colors.deepOrange,
                       borderRadius: BorderRadius.circular(30)
                   ),
                   child: Center(child: Text('View Location' , style: TextStyle(color: Colors.white),)),
                 ),
               ),
             ),
           ),
         ],
        ),


      ),
    );
  }
  Widget buildTime() {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      buildTimeCard(time: hours, header: 'H'),
      SizedBox(
        width: 8,
      ),
      buildTimeCard(time: minutes, header: 'M'),
      SizedBox(
        width: 8,
      ),
      buildTimeCard(time: seconds, header: 'S'),
    ]);
  }
  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (_) => addTime());
  }
  void reset() {
    if (countDown) {
      setState(() => duration = countdownDuration);
    } else {
      setState(() => duration = Duration());
    }
  }


  void addTime() {
    final addSeconds = countDown ? -1 : 1;
    setState(() {
      final seconds = duration.inSeconds + addSeconds;
      if (seconds < 0) {
        timer?.cancel();
        timeEnd=true;
        Fluttertoast.showToast(msg: "You were not arrived in time!");
        Navigator.of(context).pop();
      } else {
        duration = Duration(seconds: seconds);
      }
    });
  }
  Widget buildTimeCard({required String time, required String header}) =>
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20)),
            child: Text(
              time,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 18),
            ),
          ),
          //SizedBox(height: 24,),
          Text(header, style: TextStyle(color: Colors.black45)),
        ],
      );
}
