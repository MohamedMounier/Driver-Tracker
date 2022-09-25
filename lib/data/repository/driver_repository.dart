import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart';
import 'package:track_it_app/domain/models/driver_model.dart';
import 'package:track_it_app/domain/models/liveLocationModel.dart';

abstract class DriverRepository{
  Future<void> saveDriverData(DriverModel driverModel);
  Future<DriverModel> fetchDriverData();
  Future<void> sendDriverCurrentLiveLocation(LiveLocationModel currentLocation);
  Future<void> sendDriverRouteLocation(LiveLocationModel currentLocation,String shipmentID);
}