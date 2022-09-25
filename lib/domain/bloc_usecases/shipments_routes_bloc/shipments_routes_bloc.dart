import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:track_it_app/data/repository/shipments_rep.dart';
import 'package:track_it_app/domain/bloc_usecases/shipments_routes_bloc/shipments_routes_states.dart';
import 'package:track_it_app/domain/bloc_usecases/shipments_routes_bloc/shpments_routes_events.dart';
import 'package:track_it_app/domain/models/liveLocationModel.dart';
import 'package:track_it_app/domain/models/routes_model.dart';
import 'package:track_it_app/domain/repository/rep_implementer/shipments_rep_impl.dart';
import 'package:track_it_app/presentation/route_screen.dart';

import '../../models/shipments_model.dart';

class ShipmentsBloc extends Bloc<ShipmentRoutesEvents,ShipmentsStates>{
  ShipmentsBloc() : super(ShipmentsInitialState());
  ShipmentsRep shipmentsRep=ShipmentsRepImpl();
  late ShipmentsIDsModel shipmentsIds;
  late List<LiveLocationModel> shipmentRoutes;



  Future<ShipmentsIDsModel> fetchDriverShipments()async{
    await shipmentsRep.fetchDriverShipmentsStream().then((value)  {
      shipmentsIds= value;

      emit(ShipmentsGetLocationSuccState(value));
    }).onError((error, stackTrace) {
      emit(ShipmentsGetLocationFailState());
    });
    return await shipmentsIds;
  }
  sendLocationsOfShipment(String shipmentID,BuildContext context){
   shipmentRoutes= shipmentsIds.locationsGroup.where((element) => element.shipmentId==shipmentID).toList();
   Navigator.push(context, MaterialPageRoute(builder: (ctx)=>RouteScreen(shipmentLocations: shipmentRoutes),));
  }

}