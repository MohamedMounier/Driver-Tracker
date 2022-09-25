import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart';

abstract class AppStreamsRep {
  Stream<QuerySnapshot<Map<String,dynamic>>>fetchFireLiveLocationsStream();
  Stream<LocationData> streamOfLiveLocationTrial(Location location);
}