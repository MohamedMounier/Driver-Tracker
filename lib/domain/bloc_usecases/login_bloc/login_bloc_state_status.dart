import 'package:equatable/equatable.dart';

class LoginBlocStateStatus extends Equatable {
  final bool? inProccess;
  final bool? success;
  final bool? failure;
  final String? errorMessage;

  const LoginBlocStateStatus({
    this.inProccess,
    this.success,
    this.failure,
    this.errorMessage,
  });

  LoginBlocStateStatus copyWith({
    bool? inProccess,
    bool? success,
    bool? failure,
    String? errorMessage,
  }) {
    return LoginBlocStateStatus(
      errorMessage: errorMessage ?? this.errorMessage,
      failure: failure ?? this.failure,
      inProccess: inProccess ?? this.inProccess,
      success: success ?? this.success,
    );
  }

  LoginBlocStateStatus initial() {
    return const LoginBlocStateStatus(
      errorMessage: '',
      failure: false,
      inProccess: false,
      success: false,
    );

  }

  @override
  List<Object> get props => [
    inProccess!,
    success!,
    failure!,
    errorMessage!,
  ];
}
