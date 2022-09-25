import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:track_it_app/data/services/firestore_services.dart';
import 'package:track_it_app/domain/bloc_usecases/shipments_routes_bloc/shipments_routes_bloc.dart';
import 'package:track_it_app/domain/models/routes_model.dart';
import 'package:track_it_app/domain/models/shipments_model.dart';

import '../domain/models/liveLocationModel.dart';

class ShipmentsScreen extends StatefulWidget {
  const ShipmentsScreen({Key? key}) : super(key: key);

  @override
  _ShipmentsScreenState createState() => _ShipmentsScreenState();
}

class _ShipmentsScreenState extends State<ShipmentsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('All Shipments'),),
      backgroundColor: Colors.deepPurple,
      body: SafeArea(
        child:  FutureBuilder<ShipmentsIDsModel>(
            future:BlocProvider.of<ShipmentsBloc>(context).fetchDriverShipments(),
            builder: (context,snapshot){
              if(snapshot.connectionState==ConnectionState.waiting){
                return Center(child: CircularProgressIndicator(),);
              }else if(snapshot.hasError){
                return Center(child: Text('${snapshot.error}'),);
              }else if (snapshot.hasData){

               return Padding(
                 padding: const EdgeInsets.all(22.0),
                 child: Column(
                   children: [
                     Row(
                       children: [
                         Text('Completed Shipments :',
                           style: Theme.of(context).textTheme.titleLarge!.copyWith(color: Colors.white),
                         ),
                         SizedBox(width: 30,),
                         Container(
                           decoration: BoxDecoration(
                             color: Colors.white,
                             border: Border.all(color: Colors.grey),
                             shape: BoxShape.circle
                           ),
                           child: Padding(
                             padding: const EdgeInsets.all(22.0),
                             child: Text('${snapshot.data!.shipmentIDsGroup.length}',
                               style: Theme.of(context).textTheme.titleLarge!.copyWith(color: Colors.green),
                             ),
                           ),
                         ),
                       ],
                     ),
                     Expanded(
                       child: ListView.builder(
                         itemCount: snapshot.data!.shipmentIDsGroup.length,
                           itemBuilder: (context,index){
                           return Padding(
                             padding: const EdgeInsets.only(top:22.0),
                             child: Container(color: Colors.white,
                             //height: 60,
                             child: ExpansionTile(
                               title : Center(
                                 child: Text('Shipment id :  ${snapshot.data!.shipmentIDsGroup[index]}',
                               style: Theme.of(context).textTheme.titleLarge!.copyWith(color: Colors.deepPurple),
                               ),

                               ),
                             children: [
                               ElevatedButton(onPressed: (){
                                 BlocProvider.of<ShipmentsBloc>(context).sendLocationsOfShipment(snapshot.data!.shipmentIDsGroup[index], context);
                               }, child: Text('Show Shipment Routes'))
                               // ListView.builder(
                               //   shrinkWrap: true,
                               //   itemCount: snapshot.data![index].locationsList.length,
                               //
                               //   itemBuilder: (context, index2) {
                               //     var list=snapshot.data![index].locationsList;
                               //   return Text('${list[index2].currentLocation.latitude}');
                               // }
                               // )
                               ],
                               ),
                             ),
                           );

                         }
                         ),
                     ),
                   ],
                 ),
               );
              }else{
                return Container();
              }
            }),),
    );
  }

  /*
  FutureBuilder<List<LiveLocationModel>>(
            future: FireStoreDataMethods().fetchDriverShipmentsStream(),
            builder: (context,snapshot){
              if(snapshot.connectionState==ConnectionState.waiting){
                return Center(child: CircularProgressIndicator(),);
              }else if(snapshot.hasError){
                return Center(child: Text('${snapshot.error}'),);
              }else if (snapshot.hasData){

               return ListView.builder(
                 itemCount: snapshot.data!.length,
                   itemBuilder: (context,index){
                   return Container(color: Colors.amberAccent,
                   child: Text('${snapshot.data![index].shipmentId}'),
                   );
                   }
                   );
              }else{
                return Container();
              }
            }),),
   */
}
