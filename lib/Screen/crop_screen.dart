import 'package:crops/Screen/crop_card_screen.dart';
import 'package:crops/widget/category_grid_item.dart';
import 'package:crops/Model/crop.dart';
import 'package:crops/data/crop_data.dart';
import 'package:flutter/material.dart';

class CropScreen extends StatefulWidget {
  const CropScreen({super.key});

  @override
  State<CropScreen> createState() {
    return _CropScreen();
  }
}

class _CropScreen extends State<CropScreen> {
  void _selectedCrop(BuildContext context, Crop crop) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (ctx) => CropCardScreen(cropCategory: crop.id)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Crop Type'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          color: Colors.white,
          child: GridView(
            padding: const EdgeInsets.all(24),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 3 / 2,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
            ),
            children: [
              for (final crop in availableCrops)
                CategoryGridItem(
                    category: crop,
                    onSelectCategory: () {
                      _selectedCrop(context, crop);
                    })
            ],
          ),
        ),
      ),
    );
  }
}
