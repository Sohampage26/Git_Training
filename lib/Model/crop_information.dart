class CropInformation {
  String id;
  String title;
  String cropCategorie;
  String timeRequired;

  String imageUrl;
  Map<String, String> additionalInfo;

  CropInformation({
    required this.id,
    required this.title,
    required this.cropCategorie,
    required this.timeRequired,
    required this.imageUrl,
    required this.additionalInfo,
  });
}
