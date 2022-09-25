import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class DriverModel extends Equatable{
  String? driverName;
  String? driverPhoneNumber;
  Timestamp? driverLoginDate;

  DriverModel({this.driverName,this.driverLoginDate,this.driverPhoneNumber});

  DriverModel.fromFireBase(data){
    driverName=data['Driver Name'];
    driverPhoneNumber=data['Driver Number'];
    driverLoginDate=data['Driver Login Date'];
  }

  toMap()=>{
    'Driver Name':driverName,
    'Driver Number':driverPhoneNumber,
    'Driver Login Date':driverLoginDate,
  };

  @override
  // TODO: implement props
  List<Object?> get props => [driverName,driverPhoneNumber,driverLoginDate];
}