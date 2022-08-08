
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'components/map_pin_pill.dart';
import 'models/pin_pill_info.dart';

class UserGoogleMap extends StatefulWidget {
  String latitude;
  String Longitude;
  String Username;


  UserGoogleMap(this.latitude, this.Longitude, this.Username);

  @override
  _UserGoogleMapState createState() => _UserGoogleMapState();
}

class _UserGoogleMapState extends State<UserGoogleMap> {

  String address = '' ;
  LatLng SOURCE_LOCATION = LatLng(24.8607, 67.0011);
  String googleAPIKey = '<AIzaSyBcmMJkHgwOR6DUwpsjM8KiOqLeZGtgunI>';
  LatLng ORIGON_LOCATION = LatLng(24.8607, 67.0011);
  late LatLng DESTINATION_LOCATION ;
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


    await Geolocator.requestPermission().then((value) {

    }).onError((error, stackTrace){
      print(error.toString());
    });

    return await Geolocator.getCurrentPosition();

  }

  final List<Marker> _markers =  <Marker>[];

  static


  List<Marker> list = const [
    Marker(
        markerId: MarkerId('1'),
        position: LatLng(33.6844, 73.0479),
        infoWindow: InfoWindow(
            title: 'some Info '
        )
    ),

  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  //  _markers.addAll(list);

    //loadData();
  }

  loadData(){
    _getUserCurrentLocation().then((value) async {
      _markers.add(
          Marker(
              markerId: const MarkerId('SomeId'),
              position: LatLng(value.latitude ,value.longitude),
              infoWindow:  InfoWindow(
                  title: address
              )
          )
      );

      final GoogleMapController controller = await _controller.future;
      CameraPosition _kGooglePlex =  CameraPosition(
        target: LatLng(value.latitude ,value.longitude),
        zoom: 14,
      );
      controller.animateCamera(CameraUpdate.newCameraPosition(_kGooglePlex));
      setState(() {

      });
    });
  }
  @override
  Widget build(BuildContext context) {
    DESTINATION_LOCATION = LatLng(double.parse(widget.latitude), double.parse(widget.Longitude));
     CameraPosition _kGooglePlex =  CameraPosition(
      target: LatLng(double.parse(widget.latitude),double.parse(widget.Longitude)),
      zoom: 16,
    );
    return Scaffold(
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
              onMapCreated: (GoogleMapController controller){
                _controller.complete(controller);
              },
            ),
            MapPinPillComponent(
                pinPillPosition: pinPillPosition,
                currentlySelectedPin: currentlySelectedPin),
            Container(
              padding: EdgeInsets.only(right: 40),
              height: 80,
              // decoration: BoxDecoration(
              //     color: Colors.white,
              //     borderRadius: BorderRadius.circular(120)
              // ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () async{
                      _getUserCurrentLocation().then((value) async {
                        _markers.add(
                            Marker(
                                markerId: const MarkerId('CurrentId'),
                                position: LatLng( double.parse(widget.latitude),double.parse(widget.Longitude)),
                                infoWindow:  InfoWindow(
                                    title: address
                                ),
                                icon: await BitmapDescriptor.fromAssetImage(
                                    ImageConfiguration(devicePixelRatio: 2.0), 'assets/driving_pin.png'),
                                onTap: (){
                                  setState(() {
                                    sourcePinInfo = PinInformation(
                                        locationName: " ${widget.Username} Location",
                                        location: SOURCE_LOCATION,
                                        pinPath: "assets/driving_pin.png",
                                        avatarPath: "assets/1.jpg",
                                        labelColor: Colors.blueAccent);
                                    currentlySelectedPin = sourcePinInfo;
                                    pinPillPosition = 0;
                                  });


                                }

                            )
                        );

                        final GoogleMapController controller = await _controller.future;

                        CameraPosition _kGooglePlex =  CameraPosition(
                          target: LatLng(double.parse(widget.latitude),double.parse(widget.Longitude)),
                          zoom: 16,
                        );
                        controller.animateCamera(CameraUpdate.newCameraPosition(_kGooglePlex));

                        List<Placemark> placemarks = await placemarkFromCoordinates(value.latitude ,value.longitude);


                        final add = placemarks.first;
                        address = add.locality.toString() +" "+add.administrativeArea.toString()+" "+add.subAdministrativeArea.toString()+" "+add.country.toString();

                        setState(() {

                        });
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10 , horizontal: 30),
                      child: Container(
                        height: 40,

                        decoration: BoxDecoration(
                            color: Colors.deepOrange,
                            borderRadius: BorderRadius.circular(8)
                        ),
                        child: Center(child: Text('Locate User' , style: TextStyle(color: Colors.white),)),
                      ),
                    ),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 20),
                  //   child: Text(address),
                  // )
                ],
              ),
            )
          ],
        ),

      ),
    );
  }


}
