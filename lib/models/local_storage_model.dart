class LocalStorageModel {
  String? uid;
  bool isClient;

  LocalStorageModel({
    this.uid,
    required this.isClient,
  });

  // Factory constructor for creating a new LocalStorageModel instance from a map.
  factory LocalStorageModel.fromJson(Map<String, dynamic> json) {
    return LocalStorageModel(
      uid: json['uid'] as String,
      isClient: json['isClient'] as bool,
    );
  }

  // Method to convert a LocalStorageModel instance into a map.
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'isClient': isClient,
    };
  }
}

// void main() {
//   // Example JSON data
//   Map<String, dynamic> jsonData = {
//     'uid': 'qew',
//     'isClient': true,
//   };

//   // Deserialize JSON to LocalStorageModel object
//   LocalStorageModel user = LocalStorageModel.fromJson(jsonData);
//   print('UID: ${user.uid}, isClient: ${user.isClient}'); // Output: UID: qew, isClient: true

//   // Serialize LocalStorageModel object to JSON
//   Map<String, dynamic> userJson = user.toJson();
//   print(userJson); // Output: {uid: qew, isClient: true}
// }