import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart';
import 'package:track_it_app/data/repository/app_streams_rep.dart';
import 'package:track_it_app/data/services/firestore_services.dart';

class AppStreamsRepImpl extends AppStreamsRep{
  FireStoreDataMethods _fireStoreDataMethods=FireStoreDataMethods();
  @override
  Stream<QuerySnapshot<Map<String, dynamic>>> fetchFireLiveLocationsStream()async* {
   yield* _fireStoreDataMethods.fetchFireLiveLocationsStream();
  }
  @override
  Stream<LocationData> streamOfLiveLocationTrial(Location location)async*{
    yield* location.onLocationChanged;

  }

}