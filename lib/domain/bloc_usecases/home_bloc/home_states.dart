import 'package:equatable/equatable.dart';
import 'package:track_it_app/domain/bloc_usecases/home_bloc/bloc_state_status.dart';
import 'package:track_it_app/domain/models/driver_model.dart';

 class HomeStates extends Equatable{
   HomeBlocStateStatus? initialBlocStateStatus;
  bool? checkMark;
   DriverModel? driverModel;
   bool? isStartShipmentValid;
   HomeStates({this.initialBlocStateStatus,this.checkMark,this.driverModel,this.isStartShipmentValid=false});
   HomeStates copyWith(
       {
         HomeBlocStateStatus? blocStateStatus,
         bool? checkMark,
         DriverModel? driverModel,
         bool? isStartShipmentValid,

       }
       ){
    return HomeStates(
        initialBlocStateStatus:blocStateStatus??this.initialBlocStateStatus,
      checkMark: checkMark??this.checkMark,
      driverModel:driverModel??this.driverModel,
      isStartShipmentValid: isStartShipmentValid??this.isStartShipmentValid
    );
   }
   HomeStates initialState(
       {
         HomeBlocStateStatus? blocStateStatus,
         bool? checkMark,
         DriverModel? driverModel
       }
       ){
     return HomeStates(
         initialBlocStateStatus:HomeBlocStateStatus().initial(),
         checkMark: false,

     );
   }

  @override
  // TODO: implement props
  List<Object?> get props => [initialBlocStateStatus,checkMark,driverModel];
}
//
// class HomeInitialState extends HomeStates{}
// class HomeLoadingState extends HomeStates{}
// class HomeGetDriverSuccState extends HomeStates{
//   bool checkMarkValue;
//
//   DriverModel driverModel;
//
//   HomeGetDriverSuccState(this.driverModel,{this.checkMarkValue=false});
// }
// class HomeGetDriverFailState extends HomeStates{
//
//   HomeGetDriverFailState({required this.errorMessage});
//   String errorMessage;
// }
//
// class HomeNoSearchState extends HomeStates{}
// class HomeAddressSearchState extends HomeStates{}
//
// class HomeCheckShipmentIdSuccState extends HomeStates{}
// class HomeCheckShipmentIdFailState extends HomeStates{}