import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location_platform_interface/location_platform_interface.dart';
import 'package:track_it_app/data/repository/driver_repository.dart';
import 'package:track_it_app/data/services/firestore_services.dart';
import 'package:track_it_app/domain/models/driver_model.dart';
import 'package:track_it_app/domain/models/liveLocationModel.dart';
import 'package:track_it_app/presentation/widgets/toasts.dart';

class DriverRepImpl extends DriverRepository{
  final FireStoreDataMethods fireStoreMethods=FireStoreDataMethods();
  @override
  Future<void> saveDriverData(DriverModel driverModel)async {
   try{
     await fireStoreMethods.saveDriverData(driverModel).then((value) =>
   //  AppToasts.successToast('saved driver data Successfully !')
       print('saved Driver Data successfully')
     );
   }on FirebaseException catch(error){
     AppToasts.errorToast('${error.message}');
   }
  }

  @override
  Future<DriverModel> fetchDriverData()async {
    late DriverModel driverModel;
    try{
      await fireStoreMethods.fetchDriverData().then((value) {
        driverModel=DriverModel.fromFireBase(value);
      //  AppToasts.successToast('retrieved Driver Data Successfully');
       // AppToasts.successToast('retrieved Driver Data ${driverModel.driverName}');
      }

      );
    }on FirebaseException catch(error){
      AppToasts.errorToast('${error.message}');
    }
    return  driverModel;
  }

  @override
  Future<void> sendDriverCurrentLiveLocation(LiveLocationModel liveLocationModel) async{
    try{
      await fireStoreMethods.sendCurrentLocation(liveLocationModel).then((value) =>
        //  AppToasts.successToast('saved driver data Successfully !')
        print('saved driver data Successfully !')
      );
    }on FirebaseException catch(error){
      AppToasts.errorToast('${error.message}');
    }
  }


  @override
  Future<void> sendDriverRouteLocation(LiveLocationModel liveLocationModel,String shipmentID)async {
    try{
      await fireStoreMethods.sendRouteCurrentLocation(liveLocationModel,shipmentID).then((value) =>
          AppToasts.successToast('saved driver data Successfully !')
      );
    }on FirebaseException catch(error){
      AppToasts.errorToast('${error.message}');
    }
  }

}