import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'package:track_it_app/consts.dart';
import 'package:track_it_app/domain/bloc_usecases/map_bloc/map_bloc.dart';
import 'package:track_it_app/domain/bloc_usecases/places_bloc/places_bloc.dart';
import 'package:track_it_app/presentation/map_tracker_screen.dart';
import 'package:track_it_app/presentation/widgets/toasts.dart';

import '../domain/models/Address.dart';
import '../domain/models/AddressPrediction.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController pickUpLocationCtrl=TextEditingController();
  TextEditingController dropOffLocationCtrl=TextEditingController();
  //String placeAddress='';


  @override
  Widget build(BuildContext context) {
    String placeAddress=Provider.of<PlacesBloc>(context).pickUpLocation?.placeName??'';
    pickUpLocationCtrl.text=placeAddress;
    return Scaffold(
      body:
      SafeArea(
        child: Column(

          children: [
            ElevatedButton(onPressed: (){
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>MapTrackerScreen()));
      }, child: Text('see live map')),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0,vertical: 20),
              child: Container(
                height: 240,
                decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          spreadRadius: 0,
                          blurRadius: 6.0,
                          offset: Offset(0, .7)
                      ),
                    ]
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0,vertical: 20),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.arrow_back),
                            onPressed: (){
                              Navigator.pop(context);
                            },
                          ),
                          Text('Set Drop Off',
                            style:TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold
                            ) ,)
                        ],
                      ),
                      SizedBox(height: 15.0,),
                      TextFormField(
                        controller: pickUpLocationCtrl,
                        decoration:InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(20))
                            )
                        ) ,
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      TextFormField(
                        decoration:InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(20))
                            )
                        ) ,
                        onChanged: (val){
                          BlocProvider.of<PlacesBloc>(context).getPlacesPrediction(val);
                        },
                        controller: dropOffLocationCtrl,
                      ),
                    ],
                  ),
// List of places
                ),
              ),
            ),
            BlocProvider.of<PlacesBloc>(context).placesPredicted.length>0? Expanded(
              child: ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 5.0,vertical: 3.0),
                itemCount: BlocProvider.of<PlacesBloc>(context).placesPredicted.length,
                separatorBuilder: (context, index) => Divider(thickness: 2,),
                itemBuilder: (context, index) => PredictionTile(BlocProvider.of<PlacesBloc>(context,listen: false).placesPredicted[index]),
              ),
            ):Container()

          ],
        ),
      ),
    );
  }
  


}
class PredictionTile extends StatelessWidget {

  PredictionTile(
      this.placesPredictions
      );
  PlacesPredictions placesPredictions;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        BlocProvider.of<PlacesBloc>(context,listen: false).getPlaceDetails(
            placesPredictions.placeId,
            context
        );
      },
      child: ListTile(
        title: Text('${placesPredictions.mainText}'),
        leading: Icon(Icons.add_location),
        subtitle: Text('${placesPredictions.secondaryText}'),
      ),
    );
  }



}
