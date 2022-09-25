 import 'package:equatable/equatable.dart';
import 'package:track_it_app/domain/models/driver_model.dart';

class HomeEvents extends Equatable{
const HomeEvents();

  @override
  // TODO: implement props
  List<Object?> get props =>[];
 }

class HomeGetDriverInfo extends HomeEvents{
// String? userUid;
//
// HomeGetDriverInfo(this.userUid);
// @override
// // TODO: implement props
// List<Object?> get props =>[userUid];
}
class HomeChangeCheckMark extends HomeEvents{
  bool? checkSearch;

  HomeChangeCheckMark(this.checkSearch);

// TODO: implement props
List<Object?> get props =>[checkSearch];
}
class HomeStartShipmentSearch extends HomeEvents{
  bool isShipmentIdValid;
  HomeStartShipmentSearch(this.isShipmentIdValid);
// TODO: implement props
  List<Object?> get props =>[isShipmentIdValid];
}