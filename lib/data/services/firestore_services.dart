import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:location/location.dart';
import 'package:track_it_app/domain/models/driver_model.dart';
import 'package:track_it_app/domain/models/liveLocationModel.dart';
import 'package:track_it_app/domain/models/shipments_model.dart';


import '../../presentation/widgets/toasts.dart';

class FireStoreDataMethods{
   FirebaseAuth _auth=FirebaseAuth.instance;
  final FirebaseFirestore _fireStore=FirebaseFirestore.instance;
   get userUid=>_auth.currentUser!.uid;


   Future<UserCredential> loginAnonymously(
       )async{
     return await _auth.signInAnonymously();

   }

  Future<DocumentSnapshot<Map<String, dynamic>>>fetchDriverData()async{
    var userId=FirebaseAuth.instance.currentUser!;
    return await _fireStore.collection('Drivers').doc(userId.uid).get();
  }
  Future<void>saveDriverData(DriverModel driverModel)async{
    var userId=FirebaseAuth.instance.currentUser!;
     await _fireStore.collection('Drivers').doc(userId.uid).set(driverModel.toMap());
  }

  sendCurrentLocation(LiveLocationModel liveLocationModel)async{
    await FirebaseFirestore.instance.collection('users').doc('rvwOmQyh8pORaiesdVkC').set(
      //  {'location':GeoPoint(currentLocation.latitude!, currentLocation.longitude!)}
      liveLocationModel.toMap()
    );
  }
  sendRouteCurrentLocation(LiveLocationModel liveLocationModel,String shipmentID)async{
    await FirebaseFirestore.instance.collection('routes').doc(userUid).collection('routes data').doc().set(
      //  {'location':GeoPoint(currentLocation.latitude!, currentLocation.longitude!)}
      liveLocationModel.toMap()
    );
  }
  Stream<QuerySnapshot<Map<String,dynamic>>> getLiveStream()async*{
    yield* FirebaseFirestore.instance.collection('users').snapshots();
  }
  Stream<dynamic> getLiveLocationStream(Function(QuerySnapshot<Map<String,dynamic>> evently) actionDuringStream)async*{
    yield  FirebaseFirestore.instance.collection('users').snapshots().listen((event)async {


      actionDuringStream(event);
    });

  }
  Future<QuerySnapshot<Map<String, dynamic>>>fetchDriverShipments()async{
   return await FirebaseFirestore.instance.collection('routes').doc(userUid).collection('routes data').get();
  }
  Future<List<LiveLocationModel>>fetchDriverShipmentsStream()async{
   late  List<LiveLocationModel> shipmentList=[];
  try{
    await FirebaseFirestore.instance.collection('routes').doc(userUid).collection('routes data').orderBy('sent at',descending: true).get().then((value)  {
      value.docs.forEach((element) {
        shipmentList.add(LiveLocationModel.fromFireBase(element.data()));

      });
    });
  }catch(error){
    AppToasts.successToast('error   ${error.toString()}');
  }
    return shipmentList;
  }


  Stream<QuerySnapshot<Map<String,dynamic>>>fetchFireLiveLocationsStream()async*{
    yield*  FirebaseFirestore.instance.collection('users').snapshots();
  }


}