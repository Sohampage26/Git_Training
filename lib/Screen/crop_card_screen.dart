import 'package:crops/Model/crop_information.dart';
import 'package:crops/widget/crop_card.dart';
import 'package:flutter/material.dart';
import 'package:crops/data/crop_data.dart';

class CropCardScreen extends StatelessWidget {
  CropCardScreen({Key? key, required this.cropCategory}) : super(key: key);
  final cropCategory;

  @override
  Widget build(BuildContext context) {
    List<CropInformation>? crops =
        dummyCrops.where((crop) => crop.cropCategorie == cropCategory).toList();

    Widget content = ListView.builder(
      itemCount: crops.length,
      itemBuilder: (ctx, index) => CropCard(cropInfo: crops[index]),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text((availableCrops
            .firstWhere((item) => item.id == cropCategory)).title),
      ),
      body: content,
    );
  }
}
