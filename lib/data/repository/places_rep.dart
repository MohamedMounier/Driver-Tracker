import 'package:dio/dio.dart';
import 'package:track_it_app/domain/models/Address.dart';

import '../../domain/models/places_model.dart';

abstract class PlacesRepository{
  Future<PlacesModel> getPredictedPlaces(String path);
  Future<Address> getPredictedAddressDetails(String path);
}