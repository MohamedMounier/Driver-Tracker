import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:track_it_app/data/local/shared_pref.dart';
import 'package:track_it_app/data/repository/app_streams_rep.dart';
import 'package:track_it_app/data/repository/driver_repository.dart';
import 'package:track_it_app/data/repository/login_repository.dart';
import 'package:track_it_app/domain/models/Address.dart';
import 'package:track_it_app/domain/models/liveLocationModel.dart';
import 'package:track_it_app/domain/repository/rep_implementer/app_streams_rep_impl.dart';
import 'package:track_it_app/domain/repository/rep_implementer/driver_rep_impl.dart';
import 'package:track_it_app/domain/repository/rep_implementer/login_rep_imp.dart';
import 'package:track_it_app/presentation/auth_screens/login_screen.dart';
import 'package:track_it_app/presentation/widgets/toasts.dart';

import '../../../data/services/firebase_auth.dart';
import 'map_live_events.dart';
import 'map_states.dart';

class MapTrackerBloc extends Bloc<MapLiveEvents,MapTrackerStates>{
  MapTrackerBloc() : super(MapTrackerInitialState());
  Location location=Location();
  LoginRepository loginRepository=LoginRepositoryImpl();
  DriverRepository driverRepository=DriverRepImpl();
   Completer<GoogleMapController> mapChangeCtrl = Completer();
  Future<GoogleMapController>  get controller =>    mapChangeCtrl.future;
  static   blocTry(BuildContext context)=>BlocProvider.of<MapTrackerBloc>(context);
  late Address destinationAddress;
  FireMethods _fireMethods=FireMethods();
 late GeoPoint oldLocation;
 late GeoPoint newLocation;
  late StreamSubscription<LocationData> streamSubscription;
  late StreamSubscription<QuerySnapshot<Map<String,dynamic>>> streamy;
  bool isCancelFireStream=false;
  String? shipmentID;
  LiveLocationModel? liveModel;
  List <Marker>markers=[
    Marker(markerId: MarkerId('va'),
      position: LatLng(37.42796133580664, -122.085749655962),
    ),
    Marker(markerId: MarkerId('distination'),
      position: LatLng(30.0558686, 31.2042616),
    ),


  ];

    CameraPosition kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
    List<Polyline> myPolyLinePoints=[];



    StreamController<LocationData> streamController=StreamController<LocationData>();
    StreamController<QuerySnapshot<Map<String,dynamic>>> streamFireController=StreamController<QuerySnapshot<Map<String,dynamic>>>();

     Stream<LocationData> liveLocationStream()=>location.onLocationChanged;
     //Stream<QuerySnapshot<Map<String,dynamic>>> fireStream()=> FirebaseFirestore.instance.collection('users').snapshots();

   late StreamSubscription<LocationData>?  myStream;
   late StreamSubscription<QuerySnapshot<Map<String,dynamic>>>?  myFireBaseStream;


  final AppStreamsRep _appStreamsRep=AppStreamsRepImpl();

  initState()async{
    startCheckingAndStartStreams();
   // streamTrialFunction();
    // await checkGps();
    emit(MapTrackerInitialState());
  }
  // Future<void> resumeTracking()async{
  //   //mapChangeCtrl=Completer();
  //   GoogleMapController? googleMapController;
  //   mapChangeCtrl.complete(googleMapController);
  //
  //    myStream!.resume();
  //    myFireBaseStream!.resume();
  //
  //   //startCheckingAndStartStreams();
  //   AppToasts.errorToast('Stream is paused ${myStream!.isPaused}\n fireStream is paused ${myFireBaseStream!.isPaused}');
  // }

  Future pauseStreams()async{
     mapChangeCtrl=Completer();
     myStream!.pause();
     myFireBaseStream!.pause();
    controller.then((value) =>value.dispose());

     AppToasts.successToast('Live Tracking has been canceled !');
     //AppToasts.errorToast('Sis completer completed ${mapChangeCtrl.isCompleted}');
     emit(MapTrackerCancelStreams());
   }

   checkingGpsService({required Function permissionGrantedFunc})async{
     var permisionGranted=await location.hasPermission();
     if(permisionGranted==PermissionStatus.granted){
       permissionGrantedFunc();
     }else{
       var requestedPermision= location.requestPermission();
       requestedPermision.then((value) {
         if(permisionGranted==PermissionStatus.granted){
           permissionGrantedFunc();
         }else{
           AppToasts.errorToast('App will close now !');
           SystemNavigator.pop();
         }
       } );
     }
   }

   startCheckingAndStartStreams(){
     checkingGpsService(
       permissionGrantedFunc: (){
         startStreams();
       }
     );
   }
   startStreams(){
     myStream=_appStreamsRep.streamOfLiveLocationTrial(location).listen((event) {
       sendLiveLocationToDB(event).then((value) {
         myFireBaseStream=_appStreamsRep.fetchFireLiveLocationsStream().listen((data) {
           fireStreamGoogleMapChange(data);
         });
       });
       //AppToasts.successToast('stream is ${event.longitude}');
     });
   }
  Future<void> sendLiveLocationToDB(LocationData currentLocation)async{

    LiveLocationModel liveLocationModel=LiveLocationModel(
        currentLocation: GeoPoint(currentLocation.latitude!, currentLocation.longitude!),
        sentAt: Timestamp.now(),
        shipmentId: shipmentID!
    );
    liveModel=liveLocationModel;
    await driverRepository.sendDriverCurrentLiveLocation(liveLocationModel);
    await driverRepository.sendDriverRouteLocation(liveLocationModel,shipmentID??'ID');
    emit(MapTrackerSentLocationSuccState());
   // AppToasts.successToast('senttttttttttttttttttttttt');
    // getTheStream();

  }

  fireStreamGoogleMapChange(QuerySnapshot<Map<String,dynamic>> currentLiveLocation){


    currentLiveLocation.docChanges.forEach((change)async {
      var data=change.doc.data();
      // await animateCamera(change);

      await controller.then((value)  {
        value.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target:LatLng(change.doc.data()!['location'].latitude,change.doc.data()!['location'].longitude),
          zoom: 15.4746,
        ))).then((value) {
          markers.add(
            Marker(markerId: MarkerId('va'),
                infoWindow:InfoWindow(title:  change.doc.data()!['location'].longitude.toString()),
                position: LatLng(change.doc.data()!['location'].latitude,change.doc.data()!['location'].longitude)
            ),
          );
          markers.add(Marker(markerId: MarkerId('distination'),
              // position: LatLng(destinationAddress.placeLatitude!, destinationAddress.placeLongtitude!)
              position:  LatLng(30.0558686, 31.2042616)
          ));
          createPolys(change.doc.data()!['location']);
          // kGooglePlex= CameraPosition(
          //   target:LatLng(change.doc.data()!['location'].latitude,change.doc.data()!['location'].longitude),
          //   zoom: 14.4746,
          // );
          print('${change.doc.data()!['location'].latitude} ${ change.doc.data()!['location'].longitude}') ;
        //  AppToasts.errorToast('streaaaaaam working');
          emit(MapTrackerGetLatestLocationSuccState());
        }
        );
      });

    });


  }




  createPolys(GeoPoint newestLocation){

      myPolyLinePoints.add(
        Polyline(polylineId: PolylineId('1'),
        color: Colors.blue,
          points: [
            LatLng(newestLocation.latitude, newestLocation.longitude),
           // LatLng(destinationAddress.placeLatitude!, destinationAddress.placeLongtitude!)
            LatLng(30.0558686, 31.2042616)
          ]
        )
      );
      // AppToasts.successToast('Old point DB latitude ${newestLocation.latitude} longitude ${newestLocation.longitude} \n'
      //     'Newest point DB latitude ${30.0558686} longitude ${31.2042616} ');
    }

logOut(BuildContext context)async{
  await FireMethods().logout();
  CacheHelper.putData('savedLoggin', false).then((value) => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>LoginScreen())));
}


}


