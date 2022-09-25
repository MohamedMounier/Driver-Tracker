import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:track_it_app/domain/bloc_usecases/map_bloc/map_states.dart';

import '../../domain/bloc_usecases/map_bloc/map_bloc.dart';


class LiveLocationWidget extends StatelessWidget {
  const LiveLocationWidget({
    Key? key,
    required this.screenHeight,
    required this.screenWidth,
  }) : super(key: key);

  final double screenHeight;
  final double screenWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: screenHeight*.6,
      width: screenWidth*.8,
      child: BlocBuilder<MapTrackerBloc,MapTrackerStates>(
        builder: (context,state) {
          return GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: BlocProvider.of<MapTrackerBloc>(context).kGooglePlex,
            onMapCreated: (GoogleMapController controller) {
              BlocProvider.of<MapTrackerBloc>(context).mapChangeCtrl.complete(controller);
             // BlocProvider.of<MapTrackerBloc>(context).mapChangeCtrl.complete(controller);
            },

            markers: BlocProvider.of<MapTrackerBloc>(context).markers.toSet(),
            polylines: BlocProvider.of<MapTrackerBloc>(context).myPolyLinePoints.toSet(),

          );
        }
      ),
    );
  }
}
