/*
import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:track_it_app/data/repository/driver_repository.dart';
import 'package:track_it_app/data/repository/login_repository.dart';
import 'package:track_it_app/domain/models/Address.dart';
import 'package:track_it_app/domain/repository/rep_implementer/driver_rep_impl.dart';
import 'package:track_it_app/domain/repository/rep_implementer/login_rep_imp.dart';
import 'package:track_it_app/presentation/widgets/toasts.dart';

import '../../../data/services/firebase_auth.dart';
import 'map_states.dart';

class MapTrackerBloc extends Bloc<MapTrackerBloc,MapTrackerStates>{
  MapTrackerBloc() : super(MapTrackerInitialState());
  Location location=Location();
  LoginRepository loginRepository=LoginRepositoryImpl();
  DriverRepository driverRepository=DriverRepImpl();
  Completer<GoogleMapController> mapChangeCtrl = Completer();
  static   blocTry(BuildContext context)=>BlocProvider.of<MapTrackerBloc>(context);
  late Address destinationAddress;
  FireMethods _fireMethods=FireMethods();
 late GeoPoint oldLocation;
 late GeoPoint newLocation;
  late StreamSubscription<LocationData> streamSubscription;
  late StreamSubscription<QuerySnapshot<Map<String,dynamic>>> streamy;


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
     Stream<QuerySnapshot<Map<String,dynamic>>> fireStream()=> FirebaseFirestore.instance.collection('users').snapshots();
      Future<void> get cancellllll=>location.onLocationChanged.listen((event) { }).cancel();
     Future<void> cancelLiveStream()async=>await location.onLocationChanged.listen((event) { }).cancel();
     Future<void> get cancelLiveStreamFire async=>  await  FirebaseFirestore.instance.collection('users').snapshots().listen((event) { }).cancel();
     void pausLiveStream()=>location.onLocationChanged.listen((event) { }).pause();
     void resumeLiveStream()=>location.onLocationChanged.listen((event) { }).resume();


  // @override
  // // ignore: must_call_super
  // Future<Function> close()async {
  //   await location.onLocationChanged.asBroadcastStream().listen((event) { }).cancel();
  //
  // }

  initState()async{
    await startStreams();
   AppToasts.errorToast(' streamController.hasListener ${ streamController.hasListener}');
   AppToasts.errorToast(' streamFireController.hasListener ${ streamFireController.hasListener}');
    await checkGps();
    emit(MapTrackerInitialState());
  }
  cancelSub(Function functionNav)async{

    await streamController.close();
    await streamFireController.close().then((value) {
      functionNav();
    });
   //   streamSubscription= liveLocationStream().listen((event) {});
   //   streamy=fireStream().listen((event) { });
   // streamSubscription.pause();
   //   streamy.pause();
   AppToasts.successToast('is location closed ${streamController.isClosed}');

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
      AppToasts.successToast('Old point DB latitude ${newestLocation.latitude} longitude ${newestLocation.longitude} \n'
          'Newest point DB latitude ${30.0558686} longitude ${31.2042616} ');
    }
    startStreams()async{

     try{
       await streamController.addStream(liveLocationStream());
       await streamFireController.addStream(FirebaseFirestore.instance.collection('users').snapshots());
     }catch(error){
       AppToasts.errorToast('errorrrrrr ${error.toString()}');
     }

    }

  Future <void> checkGps()async{
   // liveLocationStream().listen((event) { }).resume();
   //   streamFireController.stream.asBroadcastStream().listen((event) { });
   //   streamController.stream.asBroadcastStream().listen((event) { });

    var checkGpsOpened=await location.serviceEnabled();
    if(checkGpsOpened){


      AppToasts.successToast('GPs is Enabled');
      emit(MapTrackerJpsAllowed());
     // startStreams();
      checkPermissionOfGettingLocation();
    }else{
      emit(MapTrackerJpsDenied());
      var requestService=await location.requestService();;
      if(checkGpsOpened){
        AppToasts.successToast('Start Tracking');
        checkPermissionOfGettingLocation();
      }else{

        AppToasts.successToast('Exit App');

        //SystemNavigator.pop();

      }
    }
  }
 Future<void> animateCamera(DocumentChange<Map<String,dynamic>>change)async{
    GoogleMapController controller= await mapChangeCtrl.future;
     await controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target:LatLng(change.doc.data()!['location'].latitude,change.doc.data()!['location'].longitude),
      zoom: 15.4746,
    )));


  }

  Future <void>checkPermissionOfGettingLocation()async{
    getCurrentLocation();
    var permisionGranted=await location.hasPermission();
    if(permisionGranted==PermissionStatus.granted){
      emit(MapTrackerRequestGrantedState());
      sendLiveLocationToDB();
    //  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Start Tracking permission granted')));
    }else{

      var requestedPermision=await location.requestPermission();
      emit(MapTrackerRequestedPermissionState());
      if(requestedPermision==PermissionStatus.granted){
        emit(MapTrackerRequestGrantedState());
        sendLiveLocationToDB();
      //  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Start Tracking permission granted after reuest')));
      }else{
        emit(MapTrackerRequestDeniedState());
        //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Exit that app')));
      }
    }
  }
  Future getCurrentLocation()async{
    var current=await location.getLocation();
    kGooglePlex=CameraPosition(
      target: LatLng(current.latitude!, current.longitude!),
      zoom: 14.4746,
    );
  }
  sendLiveLocationToDB()async{
   // streamController.stream.listen((event) { });
    streamController.stream.asBroadcastStream.call();
    streamFireController.stream.asBroadcastStream.call();;

   try{
     streamController.stream.asBroadcastStream.call().asBroadcastStream(
     onListen:(currentLocation) async {
  currentLocation.onData((data)async {
  await driverRepository.sendDriverCurrentLiveLocation(data);
  emit(MapTrackerSentLocationSuccState());
  AppToasts.successToast('senttttttttttttttttttttttt');
  Future.delayed(Duration(seconds: 5),() => getTheStream());
  });
     },
     onCancel: (ss){
       ss.cancel().then((value) => AppToasts.errorToast('Canceeeeeeeeeled Location stream'));
     }
     );

   }on FirebaseException catch(error){
     print('error is ${error.message}');
     emit(MapTrackerSentLocationErrorState());
   }

      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:
      // Text('Current Live Location is ${liveLocation.longitude.toString()} ${liveLocation.longitude.toString()}')));
    }

    disposeMethod()async{
      await FirebaseFirestore.instance.collection('users').snapshots().listen((event) { }).cancel();
      await location.onLocationChanged.listen((event) {}).cancel();
    }
    cancelTHAT(){
      FirebaseFirestore.instance.collection('users').snapshots().asBroadcastStream(
          onCancel: (stttreeam){
        stttreeam.cancel();
        AppToasts.errorToast('CAAANNNCEL');
      });
    }

  getTheStream()async{

   try{


    // streamFireController.stream.asBroadcastStream<StreamSubscription<dynamic>>();

    // streamFireController.stream.listen((event) {});
     streamFireController.stream.asBroadcastStream.call().asBroadcastStream(
         onCancel: (ss){
           ss.cancel().then((value) => AppToasts.errorToast('Canceeeeeeeeeled Location stream'));
         },
        onListen:  (currentLiveLocation){
          currentLiveLocation.onData((data) {

            data.docChanges.forEach((change)async {
              var data=change.doc.data();
              // await animateCamera(change);
              GoogleMapController controller= await mapChangeCtrl.future;
              await controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
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
                AppToasts.errorToast('streaaaaaam working');
                emit(MapTrackerGetLatestLocationSuccState());
              });
              //markers.clear();
              //myPolyLinePoints.clear();



              // streamFireController.add( FirebaseFirestore.instance.collection('users').snapshots());


            });
          });

         }

     );

   }on FirebaseException catch(error){
     emit(MapTrackerGetLatestLocationErrortate());
   }
  }
logOut()async{
  await FireMethods().logout();
}


allWorkingPreviousLocationLiveTrackingMethods(){

}
}



 */




// lates Working with bloc

/*

  Future <void> checkGps()async{
   // liveLocationStream().listen((event) { }).resume();
   //   streamFireController.stream.asBroadcastStream().listen((event) { });
   //   streamController.stream.asBroadcastStream().listen((event) { });

    var checkGpsOpened=await location.serviceEnabled();
    if(checkGpsOpened){


      AppToasts.successToast('GPs is Enabled');
      emit(MapTrackerJpsAllowed());

      checkPermissionOfGettingLocation();
    }else{
      emit(MapTrackerJpsDenied());
      var requestService=await location.requestService();;
      if(checkGpsOpened){
        AppToasts.successToast('Start Tracking');
        checkPermissionOfGettingLocation();
      }else{

        AppToasts.successToast('Exit App');

        //SystemNavigator.pop();

      }
    }
  }
 Future<void> animateCamera(DocumentChange<Map<String,dynamic>>change)async{
    GoogleMapController controller= await mapChangeCtrl.future;
     await controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target:LatLng(change.doc.data()!['location'].latitude,change.doc.data()!['location'].longitude),
      zoom: 15.4746,
    )));


  }

  Future <void>checkPermissionOfGettingLocation()async{
    getCurrentLocation();
    var permisionGranted=await location.hasPermission();
    if(permisionGranted==PermissionStatus.granted){
      emit(MapTrackerRequestGrantedState());
      sendLiveLocationToDB();
    //  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Start Tracking permission granted')));
    }else{

      var requestedPermision=await location.requestPermission();
      emit(MapTrackerRequestedPermissionState());
      if(requestedPermision==PermissionStatus.granted){
        emit(MapTrackerRequestGrantedState());
        sendLiveLocationToDB();
      //  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Start Tracking permission granted after reuest')));
      }else{
        emit(MapTrackerRequestDeniedState());
        //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Exit that app')));
      }
    }
  }
  Future getCurrentLocation()async{
    var current=await location.getLocation();
    kGooglePlex=CameraPosition(
      target: LatLng(current.latitude!, current.longitude!),
      zoom: 14.4746,
    );
  }


  sendLiveLocationToDB()async{
   try{
    // streamController.addStream(liveLocationStream());
      liveLocationStream().listen(
            (currentLocation) async {
              LiveLocationModel liveLocationModel=LiveLocationModel(
                currentLocation: GeoPoint(currentLocation.latitude!, currentLocation.longitude!),
                sentAt: Timestamp.now(),
                shipmentId: shipmentID!
              );
              liveModel=liveLocationModel;
          await driverRepository.sendDriverCurrentLiveLocation(liveLocationModel);
          await driverRepository.sendDriverRouteLocation(liveLocationModel,shipmentID??'ID');
          emit(MapTrackerSentLocationSuccState());
          AppToasts.successToast('senttttttttttttttttttttttt');
         getTheStream();

        },
      );
   }on FirebaseException catch(error){
     print('error is ${error.message}');
     emit(MapTrackerSentLocationErrorState());
   }
   // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:
      // Text('Current Live Location is ${liveLocation.longitude.toString()} ${liveLocation.longitude.toString()}')));
    }





  getTheStream()async{

   try{

     //streamFireController.addStream(FirebaseFirestore.instance.collection('users').snapshots());

    // streamFireController.stream.asBroadcastStream<StreamSubscription<dynamic>>();



      FirebaseFirestore.instance.collection('users').snapshots().listen(

              (currentLiveLocation){

            currentLiveLocation.docChanges.forEach((change)async {
              var data=change.doc.data();
              // await animateCamera(change);
              GoogleMapController controller= await mapChangeCtrl.future;
              await controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
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
                AppToasts.errorToast('streaaaaaam working');
                emit(MapTrackerGetLatestLocationSuccState());
              });

            });

          }

      );


   }on FirebaseException catch(error){
     emit(MapTrackerGetLatestLocationErrortate());
   }
  }
 */