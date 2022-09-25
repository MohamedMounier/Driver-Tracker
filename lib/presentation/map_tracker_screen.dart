import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:track_it_app/presentation/home_screen.dart';

import 'package:track_it_app/presentation/widgets/live_location_widget.dart';
import 'package:track_it_app/presentation/widgets/toasts.dart';

import '../domain/bloc_usecases/map_bloc/map_bloc.dart';
import '../domain/bloc_usecases/map_bloc/map_states.dart';

class MapTrackerScreen extends StatefulWidget {
  const MapTrackerScreen({Key? key}) : super(key: key);

  @override
  State<MapTrackerScreen> createState() => _MapTrackerScreenState();
}

class _MapTrackerScreenState extends State<MapTrackerScreen> {
  //late GlobalKey<ScaffoldState> _key=GlobalKey<ScaffoldState>();
  @override
  void initState() {
    // TODO: implement initState
     BlocProvider.of<MapTrackerBloc>(context,listen: false).initState();
    super.initState();


  }
  @override
  void dispose() {
    // TODO: implement dispose


    super.dispose();
    // BlocProvider.of<MapTrackerBloc>(context,listen: false).myStream!.pause();
    // BlocProvider.of<MapTrackerBloc>(context,listen: false).myFireBaseStream!.pause();
    // BlocProvider.of<MapTrackerBloc>(context,listen: false).controller.then((value) =>value.dispose());
    // AppToasts.errorToast('Stream is paused ${BlocProvider.of<MapTrackerBloc>(context,listen: false).myStream!.isPaused}'
    //     '\n fireStream is paused ${BlocProvider.of<MapTrackerBloc>(context,listen: false).myFireBaseStream!.isPaused}');


  }
  @override
  Widget build(BuildContext context) {

    double screenHeight=MediaQuery.of(context).size.height;
    double screenWidth=MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(title: Text('Live Location'),
      centerTitle: true,

      ),
      body: SafeArea(
        child: BlocConsumer<MapTrackerBloc,MapTrackerStates>(
            listener: (context,state){

              print('state issssss ${state}');
              if(state is MapTrackerCancelStreams){
              //  Navigator.pop(context);
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomeScreen()));

             //  BlocProvider.of<MapTrackerBloc>(context).getTheStream();
              }
           //   return;
            },
          builder: (context,states){

              return  SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 20,),
                    Center(child: LiveLocationWidget(screenHeight: screenHeight, screenWidth: screenWidth)),
                    SizedBox(height: 15,),
                    ElevatedButton(onPressed: (){

                      BlocProvider.of<MapTrackerBloc>(context).pauseStreams();
                    }, child: Text('Cancel tracking')),

                  ],
                ),
              );
          },
        ),
      ),
    );
  }
}

