import 'package:track_it_app/domain/models/routes_model.dart';
import 'package:track_it_app/domain/models/shipments_model.dart';

import '../../domain/models/liveLocationModel.dart';

abstract class  ShipmentsRep{
  Future<ShipmentsIDsModel>  fetchDriverShipmentsStream();
}