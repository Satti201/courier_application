import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';
import 'package:courier_application/Provider/UploadIdProvider.dart';

import '../../EditField/Colors.dart';

class NotificationScreen extends StatefulWidget {
  final String userId;
  const NotificationScreen(this.userId, {Key? key}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {

  String nTime='2022-09-09 22:04:12.000';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    feTime();
  }
  Future feTime()async{

    var collection = FirebaseFirestore.instance
        .collection('UserUploadId');
    var querySnapshot = await collection.get();
    for (var queryDocumentSnapshot
    in querySnapshot.docs) {
      Map<String, dynamic> data =
      queryDocumentSnapshot.data();
      if (widget.userId == data['UserId']) {
        setState(() {
          nTime = data["ExpDate"];
        });
      }
    }

  }
  @override
  Widget build(BuildContext context) {
    UploadIdProvider uploadIdProvider = Provider.of(context);
    uploadIdProvider.getStatusOfId(widget.userId);/*
    nTime=uploadIdProvider.fetchExpTime(widget.userId) as String;
    DateTime date = DateTime.parse(nTime);*/

    return Scaffold(
      appBar: AppBar(
        backgroundColor: scaffoldbackgroundColor,
        iconTheme: IconThemeData(color: textColor),
        title: const Text(
          "Notification ",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            (uploadIdProvider.status == 0)
                ? Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: ListTile(
                      title: Text(Jiffy(nTime).fromNow(),
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      subtitle: const Text(
                        'You Id will be Reviewed in given time',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                  )
                : Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: const ListTile(
                      title: Text(
                        'Accepted',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      subtitle: Text(
                        'Your Image ID application has been approved!',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
            const Divider(
              height: 1,
              color: Colors.grey,
              thickness: 1,
            ),
          ],
        ),
      ),
    );
  }
}
