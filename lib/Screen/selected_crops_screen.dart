import 'package:crops/Model/crop_information.dart';
import 'package:crops/widget/crop_item.dart';
import 'package:flutter/material.dart';

class SelectedCropScreen extends StatelessWidget {
  const SelectedCropScreen(
      {super.key, required this.title, required this.crops});
  final String title;
  final List<CropInformation> crops;

  @override
  Widget build(BuildContext context) {
    Widget content = ListView.builder(
        itemCount: crops.length,
        itemBuilder: (ctx, index) => CropItem(crop: crops[index]));
    if (crops.isEmpty) {
      content = const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Uh No Data Found',
              style: TextStyle(fontSize: 32, color: Colors.black),
            ),
            SizedBox(
              height: 16,
            ),
            Text('Try some different categories',
                style: TextStyle(fontSize: 24, color: Colors.black)),
          ],
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: content,
    );
  }
}
