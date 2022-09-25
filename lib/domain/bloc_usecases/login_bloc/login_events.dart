 import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:track_it_app/domain/models/driver_model.dart';

class LoginEvents extends Equatable{
const LoginEvents();

  @override
  // TODO: implement props
  List<Object?> get props =>[];
 }

class LoginEventLogUserIn extends LoginEvents{


}
class LoginSaveUserCheck extends LoginEvents{
  bool? checkSearch;

  LoginSaveUserCheck(this.checkSearch);
  @override
  // TODO: implement props
  List<Object?> get props =>[checkSearch];
}

