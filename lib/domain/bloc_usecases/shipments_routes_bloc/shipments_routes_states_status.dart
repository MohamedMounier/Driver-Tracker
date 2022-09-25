import 'package:equatable/equatable.dart';

class ShipmentRoutesStateStatus extends Equatable {
  final bool? inProccess;
  final bool? success;
  final bool? failure;
  final String? errorMessage;

  const ShipmentRoutesStateStatus({
    this.inProccess,
    this.success,
    this.failure,
    this.errorMessage,
  });

  ShipmentRoutesStateStatus copyWith({
    bool? inProccess,
    bool? success,
    bool? failure,
    String? errorMessage,
  }) {
    return ShipmentRoutesStateStatus(
      errorMessage: errorMessage ?? this.errorMessage,
      failure: failure ?? this.failure,
      inProccess: inProccess ?? this.inProccess,
      success: success ?? this.success,
    );
  }

  ShipmentRoutesStateStatus initial() {
    return const ShipmentRoutesStateStatus(
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
