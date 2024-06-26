import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:trim_time/colors/custom_colors.dart';
import 'package:trim_time/providers/sample_provider.dart';
import 'package:trim_time/views/sign_in.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    double mediaWidth = MediaQuery.of(context).size.width;
    double mediaHeight = MediaQuery.of(context).size.height;
    SampleProvider sampleProvider =
        Provider.of<SampleProvider>(context, listen: false);
    return Drawer(
      backgroundColor: CustomColors.gunmetal,
      child: ListView(
        padding: const EdgeInsets.all(0),
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 10),
            padding: EdgeInsets.only(top: 100, bottom: 10),
            decoration: BoxDecoration(
              color: CustomColors.peelOrange,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundImage: NetworkImage(sampleProvider
                      .localDataInProvider['userData']['photoURL']),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "${sampleProvider.localDataInProvider['userData']['name']}",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 0,
                ),
                Text(
                  " ${sampleProvider.localDataInProvider['userData']['email']}",
                ),
              ],
            ),
          ),
          //DrawerHeader
          Container(
            child: Column(
              // mainAxisSize: MainAxisSize.max,
              children: [
                DrawerItem(
                    icon: Icon(Icons.person, color: CustomColors.white),
                    title: 'My Profile',
                    onTap: () {
                      print('go to profile');
                    }),
                DrawerItem(
                    icon: Icon(Icons.logout, color: CustomColors.white),
                    title: 'Logout',
                    onTap: () async {
                      await sampleProvider.handleLogoutByProvider();
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => const SignIn()),
                          (Route route) => false);
                    }),

                // ListTile(
                //   leading: const Icon(Icons.book),
                //   title: const Text(' My Course '),
                //   onTap: () {
                //     Navigator.pop(context);
                //   },
                // ),
                // ListTile(
                //   leading: const Icon(Icons.workspace_premium),
                //   title: const Text(' Go Premium '),
                //   onTap: () {
                //     Navigator.pop(context);
                //   },
                // ),
                // ListTile(
                //   leading: const Icon(Icons.video_label),
                //   title: const Text(' Saved Videos '),
                //   onTap: () {
                //     Navigator.pop(context);
                //   },
                // ),
                // ListTile(
                //   leading: const Icon(Icons.edit),
                //   title: const Text(' Edit Profile '),
                //   onTap: () {
                //     Navigator.pop(context);
                //   },
                // ),
                // ListTile(
                //   leading: const Icon(Icons.logout),
                //   title: const Text('LogOut'),
                //   onTap: () {
                //     Navigator.pop(context);
                //   },
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DrawerItem extends StatelessWidget {
  const DrawerItem(
      {super.key,
      required this.icon,
      required this.title,
      required this.onTap});

  final Widget icon;
  final String title;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
      child: Container(
        height: 50,
        padding: EdgeInsets.only(left: 20),
        child: Row(
          children: [
            icon,
            SizedBox(
              width: 14,
            ),
            Text(
              title,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: CustomColors.white),
            ),
          ],
        ),
      ),
    );
  }
}
