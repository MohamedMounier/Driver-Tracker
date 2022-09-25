import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:track_it_app/domain/bloc_usecases/home_bloc/home_bloc.dart';
import 'package:track_it_app/domain/bloc_usecases/home_bloc/home_events.dart';
import 'package:track_it_app/domain/bloc_usecases/home_bloc/home_states.dart';
import 'package:track_it_app/domain/models/driver_model.dart';
import 'package:track_it_app/presentation/shipments_screen.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

late HomeBloc _homeBloc;
  @override
  void initState() {
    _homeBloc= BlocProvider.of<HomeBloc>(context);
    _homeBloc.add(HomeGetDriverInfo());
    super.initState();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();


  }
  @override
  Widget build(BuildContext context) {
    double screenHeight=MediaQuery.of(context).size.height;
    double screenWidth=MediaQuery.of(context).size.width;


    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          BlocProvider.of<HomeBloc>(context).logOut(context);
        }, icon: Icon(Icons.logout_outlined)),
      ),
      backgroundColor: Colors.deepPurple,
      body: SafeArea(
         child: BlocBuilder<HomeBloc,HomeStates>(
             builder: (context,states){
               if(states.initialBlocStateStatus!.inProccess!  ){
                 return Center(child: CircularProgressIndicator(),);
               }else  if(states.initialBlocStateStatus!.success!){
                 DateTime dateTime=states.driverModel!.driverLoginDate!.toDate();

                 return driverDataWidget(states.driverModel!,dateTime,screenHeight,screenWidth,context,states );
               }else if (states.initialBlocStateStatus!.failure! ){
                 return Container(child: Center(child: Text('${states.initialBlocStateStatus!.errorMessage}'),));
               }else{
                 return Container();
               }
             },

         )),
    );
  }

  Widget driverDataWidget(DriverModel driverModel, DateTime dateTime,double screenHeight,double screenWidth,BuildContext context,HomeStates states) {
    return Center(
      child: Container(
        //width: screenWidth*.8,
      height: screenHeight*.8,
       width: screenWidth*.8,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal:20.0,vertical: 20.0),
            child: SingleChildScrollView(
              child: Column(
               // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: screenHeight*.05,),
                  //SizedBox(height: 100,),
                  Row(

                    children: [
                      Text('Welcome',
                      style: Theme.of(context).textTheme.titleLarge,
                      ),
                      SizedBox(width: screenWidth*.1,),
                     // SizedBox(width: 150,),
                      Text('${states.driverModel!.driverName}',
                        style: Theme.of(context).textTheme.displayLarge,

                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight*.02,),
                //  SizedBox(height: 30,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('Phone : ',
                      style: Theme.of(context).textTheme.bodyMedium,
                      ),
                     SizedBox(width: screenWidth*.05,),
                   //   SizedBox(width: 100,),
                      Text('${states.driverModel!.driverPhoneNumber}',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                 // SizedBox(height: 20),
                  SizedBox(height: screenHeight*.01,),
                  Row(
                   // mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text('Last Login : ',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      SizedBox(width: screenWidth*.05,),
                     // SizedBox(width: 50,),
                      Text('${dateTime.day} - ${dateTime.month} - ${dateTime.year}\n At ${dateTime.hour} : ${dateTime.minute}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),

                    ],
                  ),
                  SizedBox(height: screenHeight*.2,),
                  //SizedBox(height: 20),

                       BlocBuilder<HomeBloc,HomeStates>(
                         builder: (context,state) {
                           return CheckboxListTile(
                            title: Text('Search for Address'),
                            value:states.checkMark ,
                            onChanged: (value){

                              BlocProvider.of<HomeBloc>(context).add(HomeChangeCheckMark(value));
                            },
                            checkColor: Theme.of(context).primaryColor,
                            activeColor: Theme.of(context).primaryColorDark ,
                      );
                         }
                       ),

                  SizedBox(height: 50,),

                  TextFormField(

                    controller:  BlocProvider.of<HomeBloc>(context,listen: false).shiCtrl,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        label: Text('Shipment id')
                    ),
                  ),
                  ElevatedButton(onPressed: (){
                    BlocProvider.of<HomeBloc>(context).checkControllerAndStartShipment(context);


                  }, child: Text('Start Shipment')),
                 SizedBox(height: screenHeight*.04,),
                 // SizedBox(height: 20,),
                  ElevatedButton(onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (ctx)=>ShipmentsScreen()));
                  }, child: Text('View Shipments')),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
/*
 FutureBuilder<DriverModel>(
           future: BlocProvider.of<HomeBloc>(context).getDriver(),
             builder: (context,snapshot){
               if(snapshot.connectionState==ConnectionState.waiting){
                 return Center(child: CircularProgressIndicator(),);
               }else if(snapshot.hasError){
                 return Center(child: Text('${snapshot.error}'),);
               }else if (snapshot.hasData){
                 DateTime dateTime=snapshot.data!.driverLoginDate!.toDate();
                 return driverDataWidget(snapshot.data!, dateTime,screenHeight,screenWidth,context);
               }else{
                 return Container();
               }
             }),
 */