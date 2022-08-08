
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

///Project Imports


class EntryPoint extends StatefulWidget {
  final String title, path, lottiePath;
  const EntryPoint({
    required this.title,
    required this.path,
    required this.lottiePath,
  }) ;
  @override
  _EntryState createState() => _EntryState();
}

class _EntryState extends State<EntryPoint> {
  @override
  Widget build(BuildContext context) {
    ///ScreenUtil for Responsive UI
    ScreenUtil.init(
      context,
      //For Redmi Note 9
      designSize: Size(
        376.72727272727275,
        800.9090909090909,
      ),
    );
    return InkWell(
      onTap: () {
        print("Entering to ${widget.title} Panel (through ${widget.path})");
        Navigator.of(context).pushNamed(
          widget.path,
          arguments: {"lottie": widget.lottiePath, "role": widget.title},
        );
      },
      child: Stack(
        clipBehavior: Clip.hardEdge,
        alignment: Alignment.center,
        children: [
          Container(
            height: 180,
            // decoration: BoxDecoration(
            //   border: Border.all(color: Colors.blueGrey, width: 3),
            //   shape: BoxShape.circle,
            // ),
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
              radius: 80,
              child: Lottie.asset(
                widget.lottiePath,
                repeat: true,
                reverse: true,
                animate: true,
                frameRate: FrameRate(30),
                fit: BoxFit.fill,
              ),
            ),
          ),
          Positioned(
            bottom: -3,
            child: Text(
              widget.title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black54,
                fontFamily: 'Roboto_Slab',
                fontSize: 20,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
