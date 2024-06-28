import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:trim_time/colors/custom_colors.dart';
import 'package:trim_time/providers/sample_provider.dart';
import 'package:trim_time/views/editProfile/edit_profile.dart';
import 'package:trim_time/views/rateApp/rate_app.dart';
import 'package:trim_time/views/sign_in.dart';
import 'package:trim_time/views/supportAndFeedback/support_and_feedback.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    SampleProvider sampleProvider =
        Provider.of<SampleProvider>(context, listen: false);
    return Drawer(
      backgroundColor: CustomColors.gunmetal,
      child: ListView(
        padding: const EdgeInsets.all(0),
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.only(top: 100, bottom: 10),
            decoration: const BoxDecoration(
              color: CustomColors.peelOrange,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Consumer<SampleProvider>(builder: (context, provider, child) {
                  return provider.profileImageInBytes != null
                      ? CircleAvatar(
                          radius: 60,
                          backgroundImage:
                              MemoryImage(sampleProvider.profileImageInBytes!))
                      : CircleAvatar(
                          radius: 60,
                          backgroundImage: NetworkImage(sampleProvider
                              .localDataInProvider['userData']['photoURL']),
                        );
                }),
                // sampleProvider.profileImageInBytes != null
                //     ? CircleAvatar(
                //         radius: 60,
                //         backgroundImage:
                //             MemoryImage(sampleProvider.profileImageInBytes!))
                //     : CircleAvatar(
                //         radius: 60,
                //         backgroundImage: NetworkImage(sampleProvider
                //             .localDataInProvider['userData']['photoURL']),
                //       ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "${sampleProvider.localDataInProvider['userData']['name']}",
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w600),
                ),
                Text(
                  "${sampleProvider.localDataInProvider['userData']['email']}",
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w400),
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
                  icon: const Icon(Icons.person, color: CustomColors.white),
                  title: 'My Profile',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const EditProfileClient()),
                    );
                  },
                ),

                DrawerItem(
                  icon: const Icon(Icons.support_agent_outlined,
                      color: CustomColors.white),
                  title: 'Customer Support',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SupportAndFeedback()),
                    );
                  },
                ),
                DrawerItem(
                  icon: const Icon(Icons.star_rate_rounded,
                      color: CustomColors.white),
                  title: 'Rate App',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const RateApp()),
                    );
                  },
                ),
                DrawerItem(
                  icon: const Icon(Icons.logout, color: CustomColors.white),
                  title: 'Logout',
                  onTap: () async {
                    await sampleProvider.handleLogoutByProvider();
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => const SignIn()),
                        (Route route) => false);
                  },
                ),

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
        height: 54,
        padding: const EdgeInsets.only(left: 20),
        child: Row(
          children: [
            icon,
            const SizedBox(
              width: 14,
            ),
            Text(
              title,
              style: const TextStyle(
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
