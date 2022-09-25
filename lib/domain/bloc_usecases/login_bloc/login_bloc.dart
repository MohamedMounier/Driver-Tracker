import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:track_it_app/data/local/shared_pref.dart';
import 'package:track_it_app/domain/bloc_usecases/login_bloc/login_bloc_state_status.dart';
import 'package:track_it_app/domain/bloc_usecases/login_bloc/login_events.dart';
import 'package:track_it_app/domain/bloc_usecases/login_bloc/login_states.dart';
import 'package:track_it_app/domain/models/driver_model.dart';
import 'package:track_it_app/domain/repository/rep_implementer/driver_rep_impl.dart';
import 'package:track_it_app/domain/repository/rep_implementer/login_rep_imp.dart';
import 'package:track_it_app/presentation/home_screen.dart';

import '../../../data/repository/driver_repository.dart';
import '../../../data/repository/login_repository.dart';
import '../../../presentation/widgets/toasts.dart';
import '../../../resources/color_manager.dart';

class LoginBloc extends Bloc<LoginEvents,LoginStates>{
  LoginBloc( ) : super(LoginStates().initialState());


  final TextEditingController nameCtrl=TextEditingController();
  final TextEditingController phoneCtrl = TextEditingController();
  bool obsecure = true;
  bool loading = false;
  GlobalKey<FormState> formKeyLogin=GlobalKey<FormState>();

  LoginRepository _loginRepository = LoginRepositoryImpl();
  DriverRepository driverRep = DriverRepImpl();

  // final FirebaseAuth auth = FirebaseAuth.instance;
  bool isLoginSaved = false;

  @override
  Stream<LoginStates> mapEventToState(LoginEvents event)async* {

    if(event is LoginSaveUserCheck){
      yield* changeUserSaved(isUserSaved: event.checkSearch);
    }if (event is LoginEventLogUserIn){
      yield* loginUser();
    }
  }

  Stream<LoginStates> changeUserSaved({bool? isUserSaved})async*{
    saveLogin(isUserSaved);
    yield state.copyWith(
      loginBlocStateStatus:  state.loginStatus!.initial(),
      isUserSaved: isUserSaved,
    );
  }
  Stream<LoginStates> loginUser()async*{
  //  saveLogin(isUserSaved);
    yield state.copyWith(
        loginBlocStateStatus:  state.loginStatus!.copyWith(
            inProccess: true,
            failure: false,
           success: false,
            errorMessage: ''
        )
    );
    bool isValid = formKeyLogin.currentState!.validate();
    if(isValid){

      try{

       var data= await login().then((value) async{

         await saveDriverInfo().then((value) {

          // navigatingAfterLoging(context);
         });
       }

        );
       if(FirebaseAuth.instance.currentUser!=null){
         yield state.copyWith(
             loginBlocStateStatus: state.loginStatus!.copyWith(
                 success: true,
                 inProccess: false,
                 failure: false
             )
         );
       }else{
         yield state.copyWith(
             loginBlocStateStatus: state.loginStatus!.copyWith(
                 success: false,
                 inProccess: false,
                 failure: true,
               errorMessage: 'No user recorded'
             )
         );
       }

     //  AppToasts.successToast('statussss ${state.loginStatus!.success!}');



      }on FirebaseAuthException catch(error){
        yield state.copyWith(
            loginBlocStateStatus:  state.loginStatus!.copyWith(
                success: false,
                inProccess: false,
              failure: true,
              errorMessage: error.message
            )
        );
        AppToasts.errorToast('${error.message}');
      }on FirebaseException catch(error){
        yield state.copyWith(
            loginBlocStateStatus:  state.loginStatus!.copyWith(
                success: false,
                inProccess: false,
                failure: true,
                errorMessage: error.message
            )
        );
        AppToasts.errorToast('${error.message}');

      }catch (error){
        yield state.copyWith(
            loginBlocStateStatus:  state.loginStatus!.copyWith(
                success: false,
                inProccess: false,
                failure: true,
                errorMessage: error.toString()
            )
        );
        AppToasts.errorToast('${error.toString()}');

      }
    }else{
      yield state.copyWith(
          loginBlocStateStatus: state.loginStatus!.initial()
      );
    //  AppToasts.errorToast('form is not validated');

    }

  }


  // signOut()async{
  //   _loginRepository.signOut();
  // }
  saveLogin(isLoginSaved) {
    if (isLoginSaved == true) {
      CacheHelper.putData('savedLoggin', true);
    } else {
      CacheHelper.putData('savedLoggin', false);
    }

  }



  navigatingAfterLoging(BuildContext context) {
    final _auth = FirebaseAuth.instance;
    User? user = _auth.currentUser;
    if (user != null) {
      // Fluttertoast.showToast(
      //     msg: 'Logged in successfully Yeah!',
      //     backgroundColor: ColorManager.white,
      //     textColor: ColorManager.darkGrey);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
    }
  }

  Future<void> login() async {
    await _loginRepository.loginAnonymously().then((value) {

    });

    // navigatingAfterLoging();
  }
  Future<void> saveDriverInfo()async{
    //emit(LoginSendDataLoadingState());

    DriverModel driverModel=DriverModel(
      driverLoginDate: Timestamp.now(),
      driverName: nameCtrl.text.trim(),
      driverPhoneNumber: phoneCtrl.text.trim()
    );
   await driverRep.saveDriverData(driverModel);
  }

}