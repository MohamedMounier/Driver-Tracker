import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:location/location.dart';

class LiveLocationModel extends Equatable{
 late GeoPoint currentLocation;
 late Timestamp sentAt;
 late String shipmentId;

LiveLocationModel({required this.shipmentId,required this.currentLocation,required this.sentAt});

 LiveLocationModel.fromFireBase(data){
   currentLocation=data['location'];
   sentAt=data['sent at'];
   shipmentId=data['shipment id'];
 }
 toMap()=>{
   'location':currentLocation,
   'sent at':sentAt,
   'shipment id':shipmentId
 };

  @override
  // TODO: implement props
  List<Object?> get props => [this.shipmentId,this.sentAt,this.currentLocation];
}

