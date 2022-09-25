import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:track_it_app/domain/models/liveLocationModel.dart';

class RouteScreen extends StatefulWidget {
  const RouteScreen({Key? key, this.shipmentLocations}) : super(key: key);
  final List<LiveLocationModel>? shipmentLocations;

  @override
  _RouteScreenState createState() => _RouteScreenState();
}

class _RouteScreenState extends State<RouteScreen> {
  Completer<GoogleMapController> _completer=Completer();


  @override
  Widget build(BuildContext context) {

    double screenHeight=MediaQuery.of(context).size.height;
    double screenWidth=MediaQuery.of(context).size.width;

    Set<Marker>markers= List<Marker>.generate(widget.shipmentLocations!.length, (index)  {
       var sendingTime=widget.shipmentLocations![index].sentAt.toDate();
       String pmOrAm=sendingTime.hour>11?'Pm':'Am';
       int hour=sendingTime.hour;
       int minute=sendingTime.minute;
       String hourFormatted=sendingTime.hour<10?'0$hour':'$hour';
       String minuteFormatted=sendingTime.minute<10?'0$minute':'$minute';
      return Marker(markerId: MarkerId('$index'),
          infoWindow: InfoWindow(title:'${hourFormatted} : ${minuteFormatted} ${pmOrAm}',
          snippet: ' ${sendingTime.day} -  ${sendingTime.month} -  ${sendingTime.year}  '
          ),
          position: LatLng( widget.shipmentLocations![index].currentLocation.latitude,  widget.shipmentLocations![index].currentLocation.longitude)
      );
    }).toSet();
    Set<Polyline>polyLines= List<Polyline>.generate(widget.shipmentLocations!.length-1, (index)  {
      var sendingTime=widget.shipmentLocations![index].sentAt.toDate();
      return Polyline(polylineId: PolylineId('$index'),
          color: Colors.blue,
          points: [
            LatLng( widget.shipmentLocations![index].currentLocation.latitude,  widget.shipmentLocations![index].currentLocation.longitude),
            LatLng( widget.shipmentLocations![index+1].currentLocation.latitude,  widget.shipmentLocations![index+1].currentLocation.longitude),
          ]
      );
    }).toSet();
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      appBar: AppBar(title: Text('Shipment Movements'),),
      body: SafeArea(

        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 50,),
              Text('Shipment id :  ${widget.shipmentLocations![0].shipmentId}',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(color: Colors.white),
              ),
              SizedBox(height: 50,),
              Container(
                height: screenHeight*.6,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white)
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    zoom: 15.0,
                      target:LatLng(widget.shipmentLocations![0].currentLocation.latitude,
                  widget.shipmentLocations![0].currentLocation.longitude)),
    markers:markers,
                    polylines: polyLines,
                    onMapCreated: (controller){
                      _completer.complete();
                    },
    ),
                ),
              ),
            ],
          ),
        )),
    );
  }

}

/*
Container(
          color: Colors.amberAccent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Shipment id : ${widget.shipmentLocations![index].shipmentId}'),
              Text('Latitude ${widget.shipmentLocations![index].currentLocation.latitude}'),
              Text('Longitude ${widget.shipmentLocations![index].currentLocation.longitude}'),
              Text('Sent At :  ${sendingTime.day} -  ${sendingTime.month} -  ${sendingTime.year} \n ${sendingTime.hour} -  ${sendingTime.minute}'),
            ],
          ),
        );
 */
