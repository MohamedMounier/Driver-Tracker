import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:track_it_app/consts.dart';
import 'package:track_it_app/data/repository/places_rep.dart';
import 'package:track_it_app/data/services/network_requests.dart';
import 'package:track_it_app/domain/bloc_usecases/places_bloc/places_events.dart';
import 'package:track_it_app/domain/bloc_usecases/places_bloc/places_states.dart';
import 'package:track_it_app/domain/models/places_model.dart';
import 'package:track_it_app/domain/repository/rep_implementer/places_rep_impl.dart';
import 'package:track_it_app/presentation/widgets/toasts.dart';

import '../../../presentation/map_tracker_screen.dart';
import '../../models/Address.dart';
import '../../models/AddressPrediction.dart';
import '../map_bloc/map_bloc.dart';

class PlacesBloc extends Bloc<PlacesEvents,PlacesStates>{
  PlacesBloc() : super(PlacesInitialState());
  Address? pickUpLocation,dropOffLocation;
  List<PlacesPredictions> placesPredicted=[];
  PlacesRepository placesRepository=PlacesRepImpl();


  void updateAddress(Address address){
    pickUpLocation=address;
   emit(PlaceUpdatePickUpAddressState());
  }
  void updateDropOffAddress(Address address){
    dropOffLocation=address;
    emit(PlaceUpdateDropAddressState());

  }
  Future<PlacesModel> getRequestPlaces(String url)async{
    late PlacesModel placesModel;
    placesModel  = await placesRepository.getPredictedPlaces(url);
  try{
    AppToasts.successToast('places method ${placesRepository.getPredictedPlaces(url)}');
    placesModel  =await  placesRepository.getPredictedPlaces(url);
    AppToasts.successToast('places model $placesModel');
   if(placesModel!=null){
     emit(PlaceGetSearchedSuccState());
     return  await placesModel;
   }
  }catch(error){
    AppToasts.errorToast(error.toString());
    emit(PlaceGetSearchedFailState());
  }
  return await placesModel;
  }
  Future<Address> getRequestAddressDetails(String url)async{
    late Address address;
    address  = await placesRepository.getPredictedAddressDetails(url);
  try{
    AppToasts.successToast('places method ${placesRepository.getPredictedAddressDetails(url)}');
    address  =await  placesRepository.getPredictedAddressDetails(url);
    AppToasts.successToast('places address $address');
   if(address!=null){
     emit(PlaceGetSearchedSuccState());
     return  address;
   }
  }catch(error){
    AppToasts.errorToast(error.toString());
    emit(PlaceGetSearchedFailState());
  }
  return await address;
  }

  getPlacesPrediction(String placeName)async
  {
    //ToDo put this after input (placeName) to get country&components=country:eg
    if(placeName.trim().length>1){
      String urlPlaces='https://maps.googleapis.com/maps/api/place/autocomplete/json'
          '?input=$placeName'
          '&types=geocode&key=$apiKey';
     // var result2=await Dio().get(urlPlaces);
      var result=await getRequestPlaces(urlPlaces);
      //await getRequest(urlPlaces);
      if(result.status=='failed'){
        print('getting places predicted failed as request');
        return;
      }
      print('predicted places are $result');
      if(result.status=='OK'){
       // var placesPred=result['predictions'];
        var placesPred=result.predictions;
        var predictionsList=(placesPred as List).map((e) => PlacesPredictions.fromJson(e)).toList();

          placesPredicted=predictionsList;
        emit(PlaceGetListOfPredictionPlaces());
      }
    }

  }
  void getPlaceDetails(String? placeId,context)async{
    AppToasts.successToast('Retrieving your drop off location , please wait ...');
    String placeDetailsUrl='https://maps.googleapis.com/maps/api/place/details/json?&place_id=$placeId&key=$apiKey';
    var res=await getRequestAddressDetails(placeDetailsUrl);
    if(res=='failed'){
      return;
    }


    if(res.status=='OK'){
      Address address=Address(
          placeName: res.placeName,
          placeLongtitude:res.placeLongtitude ,
          placeLatitude: res.placeLatitude,
          placeID: placeId
      );
      address.placeID=placeId;
      address.placeName=res.placeName;
      address.placeLatitude=res.placeLatitude;
      address.placeLongtitude=res.placeLongtitude;
      updateDropOffAddress(address);
      print('Drop off address name is ${address.placeName}');
      AppToasts.successToast('${address.placeName} lat ${address.placeLatitude} long ${address.placeLongtitude}');
      // Navigator.pop(context,'ObtainedDirection');
      BlocProvider.of<MapTrackerBloc>(context,listen: false).destinationAddress=address;
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>MapTrackerScreen()));
    }
  }


}