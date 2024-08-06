import 'package:crops/Model/crop_information.dart';
import 'package:crops/Screen/crop_card_screen.dart';
import 'package:flutter/material.dart';

class CropItem extends StatelessWidget {
  const CropItem({super.key, required this.crop});
  final CropInformation crop;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (ctx) => CropCardScreen(
                    cropCategory: crop.cropCategorie,
                    // cropId: crop.id,
                  )));
        },
        child: Stack(
          children: [
            Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 40, horizontal: 178),
              color: const Color.fromARGB(137, 71, 70, 70),
              child: Column(
                children: [
                  Text(
                    crop.title,
                    maxLines: 2,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 11, 11, 11)),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            const Row(
              children: [],
            )
          ],
        ),
      ),
    );
  }
}
