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
