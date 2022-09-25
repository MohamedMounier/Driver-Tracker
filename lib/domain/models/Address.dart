class Address
{
   String? placeName;
   double? placeLatitude;
   double? placeLongtitude;
   String? status;
  String? placeID
  ;

  Address(
      {required this.placeName, required this.placeLatitude, required this.placeLongtitude,  this.placeID});


  Address.FromJson(Map<String,dynamic> json){
    placeName=json['result']['name'];
    placeLatitude=json['result']['geometry']['location']['lat'];
    placeLongtitude=json['result']['geometry']['location']['lng'];
    status=json['status'];
  }
}