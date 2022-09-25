import 'package:track_it_app/domain/models/routes_model.dart';
import 'package:track_it_app/domain/models/shipments_model.dart';

abstract class ShipmentsStates{}
class ShipmentsInitialState extends ShipmentsStates{}
class ShipmentsGetLocationLoadingState extends ShipmentsStates{}
class ShipmentsGetLocationSuccState extends ShipmentsStates{
  final ShipmentsIDsModel shipmentsIDsModel;

  ShipmentsGetLocationSuccState(this.shipmentsIDsModel);
}
class ShipmentsGetLocationFailState extends ShipmentsStates{}
class ShipmentsGetListSucc extends ShipmentsStates{

}