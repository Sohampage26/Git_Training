import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:crops/Model/crop_information.dart';

// Firestore Functions

Future<String> getDeviceKey() async {
  final prefs = await SharedPreferences.getInstance();
  String? deviceKey = prefs.getString('device_key');

  if (deviceKey == null) {
    deviceKey = Uuid().v4();
    await prefs.setString('device_key', deviceKey);
  }

  return deviceKey;
}

Future<void> subscribeToCrop(CropInformation cropInfo) async {
  final deviceKey = await getDeviceKey();
  final firestore = FirebaseFirestore.instance;

  await firestore.collection('subscriptions').add({
    'deviceKey': deviceKey,
    'cropId': cropInfo.id,
    'cropCategorie': cropInfo.cropCategorie,
    'title': cropInfo.title,
  });
}

Future<void> unsubscribeFromCrop(String cropId) async {
  final deviceKey = await getDeviceKey();
  final firestore = FirebaseFirestore.instance;

  final querySnapshot = await firestore
      .collection('subscriptions')
      .where('deviceKey', isEqualTo: deviceKey)
      .where('cropId', isEqualTo: cropId)
      .get();

  for (var doc in querySnapshot.docs) {
    await doc.reference.delete();
  }
}

Future<bool> isSubscribedToCrop(String cropId) async {
  final deviceKey = await getDeviceKey();
  final firestore = FirebaseFirestore.instance;

  final querySnapshot = await firestore
      .collection('subscriptions')
      .where('deviceKey', isEqualTo: deviceKey)
      .where('cropId', isEqualTo: cropId)
      .get();

  return querySnapshot.docs.isNotEmpty;
}

class CropDetails extends StatefulWidget {
  final CropInformation cropInfo;

  const CropDetails({Key? key, required this.cropInfo}) : super(key: key);

  @override
  _CropDetailsState createState() => _CropDetailsState();
}

class _CropDetailsState extends State<CropDetails> {
  bool isSubscribed = false;

  @override
  void initState() {
    super.initState();
    _checkSubscription();
  }

  Future<void> _checkSubscription() async {
    bool subscribed = await isSubscribedToCrop(widget.cropInfo.id);
    setState(() {
      isSubscribed = subscribed;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool hasInfo = widget.cropInfo.additionalInfo.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.cropInfo.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: widget.cropInfo.id,
              child: Image.network(
                widget.cropInfo.imageUrl,
                height: 300,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: isSubscribed ? Colors.green : Colors.blue,
                ),
                onPressed: () async {
                  setState(() {
                    isSubscribed = !isSubscribed;
                  });

                  if (isSubscribed) {
                    await subscribeToCrop(widget.cropInfo);
                  } else {
                    await unsubscribeFromCrop(widget.cropInfo.id);
                  }

                  final snackBar = SnackBar(
                    content: Text(isSubscribed
                        ? 'Subscription added'
                        : 'Subscription removed'),
                    action: SnackBarAction(
                      label: 'Undo',
                      onPressed: () async {
                        setState(() {
                          isSubscribed = !isSubscribed;
                        });

                        if (isSubscribed) {
                          await subscribeToCrop(widget.cropInfo);
                        } else {
                          await unsubscribeFromCrop(widget.cropInfo.id);
                        }
                      },
                    ),
                  );

                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                },
                child: Text(
                  isSubscribed
                      ? 'Subscription added'
                      : 'Subscribe to this crop',
                ),
              ),
            ),
            if (hasInfo)
              ...widget.cropInfo.additionalInfo.entries.map(
                (entry) {
                  return ExpansionTile(
                    title: Text(entry.key),
                    children: [
                      ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxHeight: 160,
                        ),
                        child: IntrinsicHeight(
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16.0,
                              ),
                              child: ListTile(
                                title: Text(entry.value),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            if (hasInfo)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'टीप: वरील माहिती ही महात्मा फुले कृषी विद्यापीठ, राहुरी आणि इतर तज्ञ यांच्या सौजन्याने दिलेली मार्गदर्शक तत्वे आहेत. प्रत्यक्ष परिस्थिती, जमिनीची प्रतवारी, पाणी, हवामान याप्रमाणे काही परिमाणे बदलू शकतात.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 10),
                  ),
                ),
              ),
            if (!hasInfo)
              const ListTile(
                title: Text('Information will be added soon'),
              ),
          ],
        ),
      ),
    );
  }
}
