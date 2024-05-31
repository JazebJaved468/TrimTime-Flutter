import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:trim_time/utilities/constants/constants.dart';

Future<UserCredential> signInWithGoogle() async {
  print('<------ signInWithGoogle starts---->');
  // Trigger the authentication flow
  final GoogleSignInAccount? googleUser = await GoogleSignIn(
          // clientId: CLIENT_ID,
          )
      .signIn();

  print('googleUser----> $googleUser');

  // Obtain the auth details from the request

  final GoogleSignInAuthentication? googleAuth =
      await googleUser?.authentication;

  print('googleAuth----> $googleAuth');

  // Create a new credential
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );

  print('credential----> $credential');

  // Once signed in, return the UserCredential
  UserCredential user =
      await FirebaseAuth.instance.signInWithCredential(credential);

  print('user----> $user');
  return user;
}

signOut() async {
  GoogleSignIn().signOut();
  await FirebaseAuth.instance.signOut();
  print('signedOut---->');
}
