import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:track_it_app/domain/bloc_usecases/login_bloc/login_events.dart';
import 'package:track_it_app/presentation/home_screen.dart';

import '../../domain/bloc_usecases/home_bloc/home_bloc.dart';
import '../../domain/bloc_usecases/home_bloc/home_events.dart';
import '../../domain/bloc_usecases/login_bloc/login_bloc.dart';
import '../../domain/bloc_usecases/login_bloc/login_states.dart';
import '../../resources/color_manager.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late LoginBloc _loginBloc;

  @override
  void dispose() {
    // TODO: implement dispose
    // LoginBloc.formKeyLogin.currentState?.dispose();
    // BlocProvider.of<LoginBloc>(context).nameCtrl.dispose();
    // BlocProvider.of<LoginBloc>(context).phoneCtrl.dispose();
    super.dispose();

  }
  @override
  void initState() {
    // TODO: implement initState
    _loginBloc=BlocProvider.of<LoginBloc>(context);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    double screenHeight=MediaQuery.of(context).size.height;
    double screenWidth=MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Colors.deepPurple,
        body: SafeArea(
          child: BlocConsumer<LoginBloc,LoginStates>(
            listener: (context,state){
              if(state.loginStatus!.success!){
               // HomeBloc().add(HomeGetDriverInfo());
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
              }
            },
              builder: (context,states) {

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 20.0),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 20.0),
                      child: Form(
                        key:    _loginBloc.formKeyLogin,
                        child: ListView(
                          children: [
                            SizedBox(
                              height: screenHeight*0.1,
                            ),
                            Text('Login',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30,
                                  color: ColorManager.sacramento
                              ),
                            ),

                            SizedBox(
                              height: screenHeight*0.1,
                            ),
                            TextFormField(
                              validator: (val){
                                if(val!.isEmpty ){
                                  return ' Name can not be empty';
                                }else return null;
                              },
                              keyboardType: TextInputType.emailAddress,
                              controller: _loginBloc.nameCtrl,
                              style: TextStyle(color: ColorManager.sacramento),
                              decoration: InputDecoration(
                                  errorStyle: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.red),
                                  labelText: 'Name',
                                  hintStyle:TextStyle( color: ColorManager.sacramento),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide:BorderSide( color: ColorManager.sacramento) ),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide:BorderSide(color: Colors.pink.shade900) ),
                                  errorBorder: OutlineInputBorder(
                                      borderSide:BorderSide(color: Colors.red.shade900) )
                              ),
                            ),
                            SizedBox(height: screenHeight*.05,),
                            TextFormField(
                              validator: (val){
                                if(val!.isEmpty){
                                  return 'Phone shouldn\'t be empty';
                                }else if(val.length<8){
                                  return 'Phone should contain at least 8 characters !!';
                                }else return null;
                              },
                              keyboardType: TextInputType.phone,
                              controller: _loginBloc.phoneCtrl,
                              style: TextStyle( color: ColorManager.sacramento),

                              decoration: InputDecoration(
                               errorStyle: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.red),
                                labelText: 'Phone',
                                hintStyle:TextStyle( color: ColorManager.sacramento),
                                enabledBorder: OutlineInputBorder(
                                    borderSide:BorderSide( color: ColorManager.sacramento) ),
                                focusedBorder: OutlineInputBorder(
                                    borderSide:BorderSide(color: Colors.pink.shade900) ),
                                errorBorder: OutlineInputBorder(
                                    borderSide:BorderSide(color: Colors.red.shade900) ),
                                focusedErrorBorder: OutlineInputBorder(
                                    borderSide:BorderSide(color: Colors.red.shade900) ),
                              ),
                            ),
                            SizedBox(height: 30,),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: TextButton(onPressed: (){
                               // Get.toNamed(Routes.forgotPassRoute);
                              }, child: Text('Forgot Password ?',
                                style: TextStyle( color: ColorManager.sacramento,fontSize: 16,decoration: TextDecoration.underline),
                              )),
                            ),
                            SizedBox(height: 30,),
                            CheckboxListTile(
                              checkColor: Colors.white,
                              activeColor:Colors.green,
                              checkboxShape: RoundedRectangleBorder(
                              ),
                              value: states.isUserSaved,
                              onChanged: (val){
                                _loginBloc.add(LoginSaveUserCheck(val));
                              },
                              title: Text('Save login ',
                                style: Theme.of(context).textTheme.titleMedium?.copyWith( color: ColorManager.sacramento),
                              ),
                            ),
                            SizedBox(height: 30,),

                            states.loginStatus!.inProccess!?Center(child: CircularProgressIndicator(color: ColorManager.green,),)
                                :Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 15),
                                  child: ElevatedButton.icon(onPressed: (){
                              _loginBloc.add(LoginEventLogUserIn());
                            }, icon: Icon(Icons.login), label: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Login'),
                            ),

                            ),
                                ),
                            // !states.loginStatus!.inProccess!? ElevatedButton.icon(onPressed: (){
                            //   _loginBloc.add(LoginEventLogUserIn(context));
                            // }, icon: Icon(Icons.login), label: Padding(
                            //   padding: const EdgeInsets.all(8.0),
                            //   child: Text('Login Announmously'),
                            // ),
                            //
                            // ):Center(child: CircularProgressIndicator(color: ColorManager.green,),),
                            SizedBox(height: screenHeight*.05,),



                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }
          ),
        )


    );
  }
}
