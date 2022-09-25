import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:track_it_app/data/repository/driver_repository.dart';
import 'package:track_it_app/domain/bloc_usecases/home_bloc/home_events.dart';
import 'package:track_it_app/domain/bloc_usecases/home_bloc/home_states.dart';
import 'package:track_it_app/domain/bloc_usecases/map_bloc/map_bloc.dart';
import 'package:track_it_app/domain/models/driver_model.dart';
import 'package:track_it_app/domain/repository/rep_implementer/driver_rep_impl.dart';
import 'package:track_it_app/presentation/map_tracker_screen.dart';
import 'package:track_it_app/presentation/widgets/toasts.dart';

import '../../../data/local/shared_pref.dart';
import '../../../data/services/firebase_auth.dart';
import '../../../presentation/SearchLocationScreen.dart';
import '../../../presentation/auth_screens/login_screen.dart';





class HomeBloc extends Bloc<HomeEvents,HomeStates>{
  HomeBloc() : super(HomeStates().initialState());


  final DriverRepository _driverRepository=DriverRepImpl();
  late DriverModel driverModel;
  final TextEditingController shiCtrl=TextEditingController();




    @override
    Stream<HomeStates> mapEventToState(HomeEvents event)async* {
      if(event is HomeGetDriverInfo){
        yield* getDriverData();
      }
      if(event is HomeChangeCheckMark)
        yield* changeAddressCheckMark(check: event.checkSearch);

      if(event is HomeStartShipmentSearch)
        yield* startNewShipment();
    }

  Stream<HomeStates>getDriverData()async*{

    try{
      yield state.copyWith(
          blocStateStatus: state.initialBlocStateStatus!.copyWith(
              inProccess: true,
              success: false,
              failure: false
          ),

      ) ;
      final driverData= await _driverRepository.fetchDriverData();
      yield state.copyWith(
        blocStateStatus: state.initialBlocStateStatus!.copyWith(
          inProccess: false,
          success: true,
          failure: false
        ),
        driverModel:  driverData
      ) ;
      // emit(HomeGetDriverSuccState(driverData));
    }on FirebaseException catch(error){
      yield state.copyWith(
          blocStateStatus: state.initialBlocStateStatus!.copyWith(
              inProccess: false,
              success: false,
            failure: true,
            errorMessage: error.message??'Error Occured'
          ),

      ) ;
      //  emit(HomeGetDriverFailState(errorMessage: error.message??'error occurred !'));
    }
  }
  Stream<HomeStates>changeAddressCheckMark({bool? check})async*{
     // AppToasts.successToast('Changing check data now');
      yield state.copyWith(

        checkMark: check
      );
  }
  Stream<HomeStates>startNewShipment({bool? isStartShipmentValid})async*{
     // AppToasts.successToast('Changing check data now');
      yield state.copyWith(

        isStartShipmentValid: true
      );
  }


  logOut(BuildContext context)async{
     // FirebaseAuth.instance.signOut();
    await  FirebaseAuth.instance.signOut().then((value) {
      //FirebaseAuth.instance.currentUser!.delete();
      AppToasts.errorToast('Logged out successfully');
      CacheHelper.putData('savedLoggin', false);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginScreen()));

  });

  }

  checkControllerAndStartShipment(BuildContext context){
  if(shiCtrl.text.trim().isNotEmpty){
    BlocProvider.of<MapTrackerBloc>(context).shipmentID=shiCtrl.text.trim();
    Navigator.push(context, MaterialPageRoute(builder: (ctx)=>MapTrackerScreen()));
  }else{
    AppToasts.errorToast('Shipment id can not be empty');
  }
  }


  }




  //static HomeBloc homeBloc(BuildContext context,{bool listen=false})=>BlocProvider.of<HomeBloc>(context,listen: listen);



