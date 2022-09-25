import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:track_it_app/data/services/network_requests.dart';
import 'package:track_it_app/domain/bloc_usecases/home_bloc/home_bloc.dart';
import 'package:track_it_app/domain/bloc_usecases/home_bloc/home_events.dart';
import 'package:track_it_app/domain/bloc_usecases/login_bloc/login_bloc.dart';
import 'package:track_it_app/domain/bloc_usecases/my_observer.dart';
import 'package:track_it_app/domain/bloc_usecases/places_bloc/places_bloc.dart';
import 'package:track_it_app/domain/bloc_usecases/shipments_routes_bloc/shipments_routes_bloc.dart';
import 'package:track_it_app/presentation/SearchLocationScreen.dart';
import 'package:track_it_app/presentation/auth_screens/login_screen.dart';
import 'package:track_it_app/presentation/home_screen.dart';
import 'package:track_it_app/presentation/map_tracker_screen.dart';
import 'package:track_it_app/presentation/shipments_screen.dart';
import 'package:track_it_app/resources/theme_manager.dart';

import 'data/local/shared_pref.dart';
import 'domain/bloc_usecases/map_bloc/map_bloc.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  await CacheHelper.init();
  await DioMethods.init();
  Bloc.observer = MyBlocObserver();

  runApp( MyApp());
}

class MyApp extends StatelessWidget {
   MyApp({Key? key}) : super(key: key);
  bool isLoginSaved=CacheHelper.getData('savedLoggin')??false;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(

      providers: [
        BlocProvider(
          create: (_)=>MapTrackerBloc(),
          child:MapTrackerScreen() ,

        ),
        BlocProvider(
          create: (_)=>LoginBloc(),
          child:LoginScreen() ,

        ),
        BlocProvider(
          create: (_)=>HomeBloc(),
          child:HomeScreen() ,

        ),
        BlocProvider(
          create: (_)=>PlacesBloc(),
          child:SearchScreen() ,

        ),
        BlocProvider(
          create: (_)=>ShipmentsBloc(),
          child:ShipmentsScreen() ,

        ),
      ],
      child: MaterialApp(
        //onGenerateRoute: Routes.generateRoute,
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme:getAppTheme(context),
        home:  isLoginSaved?HomeScreen():LoginScreen()
      ),
    );
  }
}

