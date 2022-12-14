
class ImageModel{
  final String imageName;

  ImageModel({required this.imageName});

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(
      imageName: json["ImageName"],
    );
  }


  Map<String, dynamic> toImageMap() {
    var map = <String, dynamic>{"ImageName": imageName};
    return map;
  }




}