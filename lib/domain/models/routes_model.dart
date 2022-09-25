import 'package:track_it_app/domain/models/liveLocationModel.dart';

class RoutesModel {
   String shipmentID='';
  List<LiveLocationModel> locationsList=[];
  Set<String> ids={};

  RoutesModel.fromShipments(List<LiveLocationModel> liveLocationsList ){
    for(LiveLocationModel model in liveLocationsList){
     // Set<String>shipmentIdSet={};
      ids.add(model.shipmentId);

    }
  }
}
/*
{playstation , sssdsd555 , hhhssde}
 */