import 'package:equatable/equatable.dart';
import 'package:track_it_app/domain/bloc_usecases/shipments_routes_bloc/shipments_routes_states_status.dart';

class ShipmentRoutesEvents extends Equatable{
  ShipmentRoutesStateStatus? routesStateStatus;
   ShipmentRoutesEvents({this.routesStateStatus});
  @override
  // TODO: implement props
  List<Object?> get props =>[routesStateStatus];

}
class ShipmentRoutesFetch extends ShipmentRoutesEvents{
  @override
  // TODO: implement props
  List<Object?> get props =>[];
}