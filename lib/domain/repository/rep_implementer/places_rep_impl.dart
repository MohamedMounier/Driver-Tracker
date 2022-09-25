import 'package:dio/src/response.dart';
import 'package:track_it_app/data/repository/places_rep.dart';
import 'package:track_it_app/data/services/network_requests.dart';
import 'package:track_it_app/domain/models/Address.dart';
import 'package:track_it_app/presentation/widgets/toasts.dart';

import '../../models/places_model.dart';

class PlacesRepImpl extends PlacesRepository{
  @override
  Future<PlacesModel> getPredictedPlaces(String path)async {
    late Address result;
    late PlacesModel placesModel;
     late Response response;
  try{
    response= await DioMethods.getData(path: path);
    placesModel=PlacesModel.FromJson(response.data);
  }catch(error){
    AppToasts.errorToast('in implementation ${error.toString()}');
  }
  return await placesModel;
  }

  @override
  Future<Address> getPredictedAddressDetails(String path) async{
    late Address result;
    late Address address;
    late Response response;
    try{
      response= await DioMethods.getData(path: path);
      address=Address.FromJson(response.data);
    }catch(error){
      AppToasts.errorToast('in implementation ${error.toString()}');
    }
    return await address;
  }

}