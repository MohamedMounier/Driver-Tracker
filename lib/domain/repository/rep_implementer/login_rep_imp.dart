import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:track_it_app/data/services/firestore_services.dart';


import '../../../data/repository/login_repository.dart';
import '../../../data/services/firebase_auth.dart';
import '../../../presentation/widgets/toasts.dart';
import '../../../resources/color_manager.dart';

 class LoginRepositoryImpl extends LoginRepository {
   final FireMethods _fireMethods=FireMethods();



  @override

  @override
  Future<UserCredential> loginAnonymously() async{
    late UserCredential userCredential;
    try{
      var user=await FireStoreDataMethods().loginAnonymously();
      userCredential=await FireStoreDataMethods().loginAnonymously();
      if(userCredential!=null){

        AppToasts.successToast( 'Logged in Successfully');
      //  AppToasts.successToast( '${user.user!.uid}');
        return userCredential;
      }else{
        AppToasts.errorToast( 'Error Occurred Try again later !');
      }

    }on FirebaseAuthException catch(e){
      AppToasts.errorToast( '${e.message}');

    }
    return await userCredential;
  }
}