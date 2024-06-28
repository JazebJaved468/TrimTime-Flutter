import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

pickImage(ImageSource source) async {
  final ImagePicker _imagePicker = ImagePicker();
  final XFile? _file = await _imagePicker.pickImage(
    source: source,
    maxHeight: 1000,
    maxWidth: 1000,
    imageQuality: 50,
  );

  if (_file != null) {
    return await _file.readAsBytes();
  }
  print('-------------->Message : no image is selected');
}

void networkImageToUint8ListSync(String imageUrl) async {
  final image = NetworkImage(imageUrl);
  ByteData data = await rootBundle.load(imageUrl);

  List<int> bytes = data.buffer.asUint8List();

  print('image data in bytes ----> ${Uint8List.fromList(bytes)}');
  // return Uint8List.fromList(bytes);
}
