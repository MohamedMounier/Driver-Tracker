import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:track_it_app/data/repository/shipments_rep.dart';
import 'package:track_it_app/domain/models/routes_model.dart';
import 'package:track_it_app/domain/models/shipments_model.dart';

import '../../../data/services/firestore_services.dart';
import '../../../presentation/widgets/toasts.dart';

class ShipmentsRepImpl extends ShipmentsRep{
  final FireStoreDataMethods fireStoreMethods=FireStoreDataMethods();

  @override

  @override
  Future<ShipmentsIDsModel> fetchDriverShipmentsStream()async {
    List<RoutesModel> listOfShipments=[];
    late ShipmentsIDsModel shipmentsIDsModel;
    try{
     await fireStoreMethods.fetchDriverShipmentsStream().then((locations) {
       shipmentsIDsModel=ShipmentsIDsModel.fromFireBase(locations);

     });
    }catch(error){
      AppToasts.errorToast(error.toString());
    }
    return await shipmentsIDsModel;
  }
}