import 'package:equatable/equatable.dart';
import 'package:track_it_app/domain/bloc_usecases/login_bloc/login_bloc_state_status.dart';

 class LoginStates extends Equatable{
  LoginBlocStateStatus? loginStatus;
  bool? isUserSaved;
   LoginStates({this.loginStatus,this.isUserSaved});


   LoginStates copyWith({
  LoginBlocStateStatus? loginBlocStateStatus,
     bool? isUserSaved
}){
     return LoginStates(
       isUserSaved: isUserSaved??this.isUserSaved,
       loginStatus: loginBlocStateStatus??this.loginStatus
     );

}
LoginStates initialState({
   LoginBlocStateStatus? loginBlocStateStatus,
  bool? isUserSaved
 }){
     return LoginStates(
       loginStatus: LoginBlocStateStatus().initial(),
       isUserSaved: false
     );
}

  @override
  // TODO: implement props
  List<Object?> get props => [this.loginStatus,this.isUserSaved];
}

