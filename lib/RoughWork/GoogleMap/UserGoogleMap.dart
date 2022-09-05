import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoder/geocoder.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'components/map_pin_pill.dart';
import 'models/pin_pill_info.dart';

class UserGoogleMap extends StatefulWidget {
  String latitude;
  String Longitude;
  String Username;
  String time;
  double reciverlat;
  double reclon;
  double picklat;
  double picklon;

  UserGoogleMap(this.time, this.latitude, this.Longitude, this.Username,
      this.reciverlat, this.reclon, this.picklat, this.picklon);

  @override
  _UserGoogleMapState createState() => _UserGoogleMapState();
}

class _UserGoogleMapState extends State<UserGoogleMap> {
  static const countdownDuration = Duration(minutes: 60);
  Duration duration = Duration();
  Timer? timer;

  bool countDown = true;

  String address = '';
  LatLng SOURCE_LOCATION = LatLng(24.8607, 67.0011);
  String googleAPIKey = '<AIzaSyCWtYrdhwYhlaV_T5oaUl-iKLRzVEJPXvc>';
  LatLng ORIGON_LOCATION = LatLng(24.8607, 67.0011);
  late LatLng DESTINATION_LOCATION;
  final Completer<GoogleMapController> _controller = Completer();
  PinInformation currentlySelectedPin = PinInformation(
      pinPath: '',
      avatarPath: '',
      location: LatLng(0, 0),
      locationName: '',
      labelColor: Colors.grey);
  late PinInformation sourcePinInfo;
  late PinInformation destinationPinInfo;
  late PinInformation OriginPinInfo;
  double pinPillPosition = -100;
  late BitmapDescriptor sourceIcon;
  late BitmapDescriptor destinationIcon;
  late BitmapDescriptor origonIcon;
  Set<Polygon> _polygons = Set<Polygon>();
  List<LatLng> _polygonLatLngs = <LatLng>[];
  Set<Polyline> _polylines = Set<Polyline>();
  int _polygonIdCounter = 1;
  int _polylineIdCounter = 1;

  Future<Position> _getUserCurrentLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) {
      print(error.toString());
    });

    return await Geolocator.getCurrentPosition();
  }

  final List<Marker> _markers = <Marker>[];

  /*static List<Marker> list = const [
    Marker(
        markerId: MarkerId('1'),
        position: LatLng(33.6844, 73.0479),
        infoWindow: InfoWindow(title: 'some Info ')),
  ];*/

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //_markers.addAll(list);
    startTimer();
    reset();
    loadData();
  }

  void stopTimer({bool resets = true}) {
    if (resets) {
      reset();
    }
    setState(() => timer?.cancel());
  }

  void addTime() {
    final addSeconds = countDown ? -1 : 1;
    setState(() {
      final seconds = duration.inSeconds + addSeconds;
      if (seconds < 0) {
        timer?.cancel();
      } else {
        duration = Duration(seconds: seconds);
      }
    });
  }

  void reset() {
    if (countDown) {
      setState(() => duration = countdownDuration);
    } else {
      setState(() => duration = Duration());
    }
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (_) => addTime());
  }

  loadData() {
    // _getUserCurrentLocation().then((value) async {
    //   _markers.add(Marker(
    //       markerId: const MarkerId('SomeId'),
    //       position: LatLng(value.latitude, value.longitude),
    //       infoWindow: InfoWindow(title: address)));
    //
    //   final GoogleMapController controller = await _controller.future;
    //   CameraPosition _kGooglePlex = CameraPosition(
    //     target: LatLng(value.latitude, value.longitude),
    //     zoom: 14,
    //   );
    //   controller.animateCamera(CameraUpdate.newCameraPosition(_kGooglePlex));
    //   setState(() {});
    // });

    _getUserCurrentLocation().then((value) async {
      _markers.add(Marker(
          markerId: const MarkerId('CurrentId'),
          position: LatLng(double.parse(widget.latitude),
              double.parse(widget.Longitude)),
          infoWindow: InfoWindow(title: address),
          icon: await BitmapDescriptor.fromAssetImage(
              const ImageConfiguration(
                  devicePixelRatio: 2.0),
              'assets/driving_pin.png'),
          onTap: () {
            setState(() {
              sourcePinInfo = PinInformation(
                  locationName:
                  " ${widget.Username} Location",
                  location: SOURCE_LOCATION,
                  pinPath: "assets/driving_pin.png",
                  avatarPath: "assets/1.jpg",
                  labelColor: Colors.blueAccent);
              currentlySelectedPin = sourcePinInfo;
              pinPillPosition = 0;
            });
          }));
      _markers.add(Marker(
          markerId: const MarkerId('PickId'),
          position: LatLng(widget.picklat, widget.picklon),
          icon: await BitmapDescriptor.fromAssetImage(
              const ImageConfiguration(
                  devicePixelRatio: 2.0),
              'assets/destination_map_marker.png'),
          infoWindow: InfoWindow(title: address),
          onTap: () {
            setState(() {
              OriginPinInfo = PinInformation(
                  locationName: "PICK UP LOCATION",
                  location: ORIGON_LOCATION,
                  pinPath: "assets/driving_pin.png",
                  avatarPath: "assets/1.jpg",
                  labelColor: Colors.blueAccent);
              currentlySelectedPin = OriginPinInfo;
              pinPillPosition = 0;
            });
          }));

      _markers.add(Marker(
        markerId: const MarkerId('DestId'),
        position: LatLng(widget.reciverlat, widget.reclon),
        infoWindow: InfoWindow(title: address),
        onTap: () {
          setState(() {
            destinationPinInfo = PinInformation(
                locationName: "DROP OFF LOCATION",
                location: DESTINATION_LOCATION,
                pinPath:
                "assets/destination_map_marker.png",
                avatarPath: "assets/1.jpg",
                labelColor: Colors.blueAccent);
            currentlySelectedPin = destinationPinInfo;
            pinPillPosition = 0;
          });
        },
        icon: await BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(devicePixelRatio: 2.0),
            'assets/destination_map_marker.png'),
      ));

      final GoogleMapController controller =
      await _controller.future;

      CameraPosition _kGooglePlex = CameraPosition(
        target: LatLng(double.parse(widget.latitude),
            double.parse(widget.Longitude)),
        zoom: 16,
      );
      controller.animateCamera(
          CameraUpdate.newCameraPosition(_kGooglePlex));

      List<Placemark> placeMarks =
      await placemarkFromCoordinates(
          value.latitude, value.longitude);

      final add = placeMarks.first;
      address = add.locality.toString() +
          " " +
          add.administrativeArea.toString() +
          " " +
          add.subAdministrativeArea.toString() +
          " " +
          add.country.toString();

      setState(() {});
    });

  }

  @override
  Widget build(BuildContext context) {
    DESTINATION_LOCATION =
        LatLng(double.parse(widget.latitude), double.parse(widget.Longitude));
    CameraPosition _kGooglePlex = CameraPosition(
      target:
          LatLng(double.parse(widget.latitude), double.parse(widget.Longitude)),
      zoom: 16,
    );
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
                  FlatButton(
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
                  FlatButton(
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
        body: SafeArea(
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              GoogleMap(
                initialCameraPosition: _kGooglePlex,
                myLocationEnabled: true,
                compassEnabled: true,
                tiltGesturesEnabled: false,
                mapType: MapType.normal,
                myLocationButtonEnabled: true,
                markers: Set<Marker>.of(_markers),
                onTap: (LatLng loc) {
                  pinPillPosition = -100;
                },
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
              ),
              MapPinPillComponent(
                  pinPillPosition: pinPillPosition,
                  currentlySelectedPin: currentlySelectedPin),
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
                padding: const EdgeInsets.only(top: 60,right: 10),
                child: Align(
                  alignment: Alignment.topRight,
                  // add your floating action button
                  child: SizedBox(
                    width: 40.0,
                    height: 40.0,
                    child: FloatingActionButton(

                      onPressed: () {},
                      child: Icon(Icons.add , size: 20,),
                    ),
                  ),
                ),
              ),
            ],
          ),
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
                  color: Colors.black,
                  fontSize: 18),
            ),
          ),
          //SizedBox(height: 24,),
          Text(header, style: TextStyle(color: Colors.black45)),
        ],
      );
}
