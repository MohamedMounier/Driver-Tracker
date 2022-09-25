// import 'dart:async';
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:location/location.dart';
//
// import '../../../data/repository/login_repository.dart';
// import '../../../data/services/firebase_auth.dart';
// import '../../../presentation/widgets/toasts.dart';
// import '../../models/Address.dart';
// import '../../repository/rep_implementer/login_rep_imp.dart';
// import 'map_bloc.dart';
//
// class LiveTrackinMethods {
//   Location location=Location();
//   LoginRepository loginRepository=LoginRepositoryImpl();
//   Completer<GoogleMapController> mapChangeCtrl = Completer();
//   static   blocTry(BuildContext context)=>BlocProvider.of<MapTrackerBloc>(context);
//   late Address destinationAddress;
//   FireMethods _fireMethods=FireMethods();
//   late GeoPoint oldLocation;
//   late GeoPoint newLocation;
//
//   List <Marker>markers=[
//     Marker(markerId: MarkerId('va'),
//       position: LatLng(37.42796133580664, -122.085749655962),
//     ),
//     // Marker(markerId: MarkerId('distnation'),
//     //   position: LatLng(30.0558686, 31.2042616),
//     //
//     // )
//
//   ];
//
//   CameraPosition kGooglePlex = CameraPosition(
//     target: LatLng(37.42796133580664, -122.085749655962),
//     zoom: 14.4746,
//   );
//   List<Polyline> myPolyLinePoints=[];
//
//   createPolys(GeoPoint newestLocation){
//     myPolyLinePoints.add(
//         Polyline(polylineId: PolylineId('1'),
//             color: Colors.blue,
//             points: [
//               LatLng(newestLocation.latitude, newestLocation.longitude),
//               LatLng(destinationAddress.placeLatitude!, destinationAddress.placeLongtitude!)
//               //LatLng(30.0558686, 31.2042616)
//             ]
//         )
//     );
//     AppToasts.successToast('Old point DB latitude ${newestLocation.latitude} longitude ${newestLocation.longitude} \n'
//         'Newest point DB latitude ${30.0558686} longitude ${31.2042616} ');
//   }
//
//   Future <void> checkGps(BuildContext context)async{
//     var checkGpsOpened=await location.serviceEnabled();
//     if(checkGpsOpened){
//
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('GPs is Enabled')));
//       //emit(MapTrackerJpsAllowed());
//       checkPermissionOfGettingLocation();
//     }else{
//      // emit(MapTrackerJpsDenied());
//       var requestService=await location.requestService();;
//       if(checkGpsOpened){
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Start Tracking')));
//         checkPermissionOfGettingLocation();
//       }else{
//
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Exit App')));
//         //SystemNavigator.pop();
//
//       }
//     }
//   }
//   storeUserLiveLocation()async{
//     //User? currentUser=FirebaseAuth.instance.currentUser;
//     location.onLocationChanged.listen((event)async {
//       await FirebaseFirestore.instance.collection('users').doc('rvwOmQyh8pORaiesdVkC').set({
//         'location':GeoPoint(event.latitude!, event.longitude!)
//       });
//       //  oldLocation=GeoPoint(event.latitude!, event.longitude!);
//       // Future.delayed(Duration(seconds: 10)).then((value)async {
//       //   await FirebaseFirestore.instance.collection('shipments').doc(currentUser?.uid).set({
//       //     'location':GeoPoint(event.latitude!, event.longitude!)
//       //   });
//       // });
//     });
//
//   }
//
//   Future <void>checkPermissionOfGettingLocation()async{
//     getCurrentLocation();
//     var permisionGranted=await location.hasPermission();
//     if(permisionGranted==PermissionStatus.granted){
//       //emit(MapTrackerRequestGrantedState());
//       sendLiveLocationToDB();
//       //  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Start Tracking permission granted')));
//     }else{
//
//       var requestedPermision=await location.requestPermission();
//       //emit(MapTrackerRequestedPermissionState());
//       if(requestedPermision==PermissionStatus.granted){
//        // emit(MapTrackerRequestGrantedState());
//         sendLiveLocationToDB();
//         //  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Start Tracking permission granted after reuest')));
//       }else{
//         //emit(MapTrackerRequestDeniedState());
//         //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Exit that app')));
//       }
//     }
//   }
//   Future getCurrentLocation()async{
//     var current=await location.getLocation();
//     kGooglePlex=CameraPosition(
//       target: LatLng(current.latitude!, current.longitude!),
//       zoom: 14.4746,
//     );
//   }
//   sendLiveLocationToDB()async{
//     try{
//       location.onLocationChanged.listen((liveLocation) async {
//         await FirebaseFirestore.instance.collection('users').doc('rvwOmQyh8pORaiesdVkC').set(
//             {'location':GeoPoint(liveLocation.latitude!, liveLocation.longitude!)}
//         );
//       //  emit(MapTrackerSentLocationSuccState());
//         getTheStream();
//       });
//     }on FirebaseException catch(error){
//       print('error is ${error.message}');
//       //emit(MapTrackerSentLocationErrorState());
//     }
//
//     // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:
//     // Text('Current Live Location is ${liveLocation.longitude.toString()} ${liveLocation.longitude.toString()}')));
//   }
//
//   getTheStream()async{
//
//     try{
//       await FirebaseFirestore.instance.collection('users').snapshots().listen((event) {
//         event.docChanges.forEach((change)async {
//           var data=change.doc.data();
//           GoogleMapController googleMapController= await mapChangeCtrl.future;
//           googleMapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
//             target:LatLng(change.doc.data()!['location'].latitude,change.doc.data()!['location'].longitude),
//             zoom: 15.4746,
//
//           )));
//
//
//           markers.add(
//             Marker(markerId: MarkerId(change.doc.id),
//                 infoWindow:InfoWindow(title:  change.doc.data()!['location'].longitude.toString()),
//                 position: LatLng(change.doc.data()!['location'].latitude,change.doc.data()!['location'].longitude)
//             ),
//           );
//           markers.add(Marker(markerId: MarkerId('distination'),
//               position: LatLng(destinationAddress.placeLatitude!, destinationAddress.placeLongtitude!)
//           ));
//           createPolys(change.doc.data()!['location']);
//           kGooglePlex= CameraPosition(
//             target:LatLng(change.doc.data()!['location'].latitude,change.doc.data()!['location'].longitude),
//             zoom: 14.4746,
//           );
//           print('${change.doc.data()!['location'].latitude} ${ change.doc.data()!['location'].longitude}') ;
//         //  emit(MapTrackerGetLatestLocationSuccState());
//
//         });
//
//       });
//     }on FirebaseException catch(error){
//       //emit(MapTrackerGetLatestLocationErrortate());
//     }
//   }
// }