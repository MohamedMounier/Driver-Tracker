class PlacesModel {
  late String status;
  late List predictions;


  PlacesModel(
      {required this.status,required this.predictions});


  PlacesModel.FromJson(Map<String,dynamic> json){

    status=json['status'];
    predictions=json['predictions'];
  }
}