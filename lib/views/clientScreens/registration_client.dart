import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:trim_time/colors/custom_colors.dart';
import 'package:trim_time/controller/firestore.dart';
import 'package:trim_time/controller/local_storage.dart';
import 'package:trim_time/controller/login.dart';
import 'package:trim_time/providers/sample_provider.dart';
import 'package:trim_time/views/clientScreens/home_client.dart';
import 'package:trim_time/views/homescreenclient/homecontent.dart';
import 'package:trim_time/views/homescreenclient/homescreenclient.dart';
import 'package:trim_time/views/sign_in.dart';

class ClientRegistrationPage extends StatefulWidget {
  ClientRegistrationPage(
      {super.key,
      required this.photoURL,
      required this.phoneNumber,
      required this.email,
      required this.fullName,
      required this.gender,
      required this.shouldNavigate});

  final String photoURL;
  final String phoneNumber;
  final String email;
  final String fullName;
  final String gender;
  final bool shouldNavigate;

  @override
  State<ClientRegistrationPage> createState() => _ClientRegistrationPageState();
}

class _ClientRegistrationPageState extends State<ClientRegistrationPage> {
  final isClient = true;
  bool _isLoading = true;
  List<String> genders = ['male', 'female'];

  late String dropDownValue;

  late Map<String, dynamic> localData;

  // LocalStorageModel? localStorageData;

  _loadData() async {
    // await Future.delayed(const Duration(seconds: 2));

    localData = await getDataFromLocalStorage();

    print('localData in registration page----> $localData');

    setState(() {
      // dropDownValue = localData['userData']['gender'];
      _isLoading = false;
    });
  }

  // String dropDownValue = 'male';
  // List<String> genders = ['male', 'female'];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadData();
  }

  // String fullName = '';
  // String nickName = '';
  // String phoneNumber = '';
  // String address = '';
  // TextEditingController fullNameController = TextEditingController();
  // TextEditingController nickNameController = TextEditingController();
  // TextEditingController emailController = TextEditingController();
  // TextEditingController phoneNumberController = TextEditingController();
  // TextEditingController addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    SampleProvider sampleProvider =
        Provider.of<SampleProvider>(context, listen: false);

    TextEditingController fullNameController =
        TextEditingController(text: widget.fullName);
    TextEditingController nickNameController = TextEditingController();
    ;
    TextEditingController emailController =
        TextEditingController(text: widget.email);
    ;
    TextEditingController phoneNumberController =
        TextEditingController(text: widget.phoneNumber);
    ;

    TextEditingController addressController = TextEditingController();
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text("Client's Registration Page"),
          actions: [
            IconButton(
              onPressed: () async {
                await signOut();
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => SignIn()),
                    (Route route) => false);
              },
              icon: const Icon(Icons.logout),
            ),
          ],
        ),
        body: _isLoading
            ? Center(
                child: const SpinKitFadingCircle(
                color: CustomColors.peelOrange,
                size: 50.0,
              ))
            : SingleChildScrollView(
                child: Column(
                  children: [
                    Text('Register Yourself Here!'),
                    CircleAvatar(
                      radius: 50,
                      backgroundImage:
                          NetworkImage(localData['userData']['photoURL']),
                    ),
                    TextField(
                      maxLength: 30,
                      controller: fullNameController,
                      decoration: InputDecoration(
                        labelText: 'Full Name',
                      ),
                    ),
                    TextField(
                      maxLength: 30,
                      controller: nickNameController,
                      decoration: InputDecoration(
                        labelText: 'Nick Name',
                      ),
                    ),
                    TextField(
                      enabled: false,
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                      ),
                    ),
                    TextField(
                      maxLength: 11,
                      keyboardType: TextInputType.phone,
                      controller: phoneNumberController,
                      decoration: InputDecoration(
                        labelText: 'Phone Number',
                      ),
                    ),
                    TextField(
                      maxLength: 70,
                      controller: addressController,
                      decoration: InputDecoration(
                        labelText: 'Address',
                      ),
                    ),

                    Consumer<SampleProvider>(
                      builder: (context, provider, child) {
                        return DropdownButton(
                          // Initial Value
                          value: provider.clientGender,

                          icon: const Icon(Icons.keyboard_arrow_down),

                          items: genders.map((String item) {
                            return DropdownMenuItem(
                              value: item,
                              child: Text(item.toUpperCase()),
                            );
                          }).toList(),

                          onChanged: (String? newValue) {
                            provider.updateClientGEnder(newValue!);
                          },
                        );
                      },
                    ),
                    // DropdownButton(
                    //   // Initial Value
                    //   value: dropDownValue,

                    //   icon: const Icon(Icons.keyboard_arrow_down),

                    //   items: genders.map((String item) {
                    //     return DropdownMenuItem(
                    //       value: item,
                    //       child: Text(item.toUpperCase()),
                    //     );
                    //   }).toList(),

                    //   onChanged: (String? newValue) {
                    //     setState(() {
                    //       dropDownValue = newValue!;
                    //     });
                    //   },
                    // ),
                    ElevatedButton(
                      onPressed: () async {
                        await updateUserRegistrationDataInFirestore(
                            userId: localData['uid'],
                            isClient: localData['isClient'],
                            data: {
                              'isRegistered': true,
                              'name': fullNameController.text,
                              'nickName': nickNameController.text,
                              'email': emailController.text,
                              'phoneNumber': phoneNumberController.text,
                              'gender':
                                  sampleProvider.clientGender.toLowerCase(),
                              'address': addressController.text,
                            });

                        await updateUserDataInLocalStorage(
                            data: await getUserDataFromFirestore(
                                localData['uid'], isClient));

                        if (widget.shouldNavigate) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomeScreen()),
                          );
                        }
                      },
                      child: Text('Save Profile'),
                    ),
                  ],
                ),
              ));
  }
}
