import 'package:equatable/equatable.dart';

class HomeBlocStateStatus extends Equatable {
  final bool? inProccess;
  final bool? success;
  final bool? failure;
  final String? errorMessage;

  const HomeBlocStateStatus({
    this.inProccess,
    this.success,
    this.failure,
    this.errorMessage,
  });

  HomeBlocStateStatus copyWith({
    bool? inProccess,
    bool? success,
    bool? failure,
    String? errorMessage,
  }) {
    return HomeBlocStateStatus(
      errorMessage: errorMessage ?? this.errorMessage,
      failure: failure ?? this.failure,
      inProccess: inProccess ?? this.inProccess,
      success: success ?? this.success,
    );
  }

  HomeBlocStateStatus initial() {
    return const HomeBlocStateStatus(
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
