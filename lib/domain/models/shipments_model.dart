import 'package:equatable/equatable.dart';

import 'liveLocationModel.dart';

class ShipmentsIDsModel extends Equatable{
  late List<String> shipmentIDsGroup;
  late List<LiveLocationModel>locationsGroup=[];
  ShipmentsIDsModel({required this.shipmentIDsGroup});

  ShipmentsIDsModel.fromFireBase(List<LiveLocationModel>locations){
    Set<String> idsGroup={};
    for(var location in locations){
      locationsGroup.add(location);
     // if(location.sentAt.)
      idsGroup.add(location.shipmentId);
    }
    shipmentIDsGroup=idsGroup.toList();
  }

  @override
  // TODO: implement props
  List<Object?> get props => [this.shipmentIDsGroup,this.locationsGroup];

}