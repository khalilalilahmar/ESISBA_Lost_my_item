import 'package:esi_lost_my_item/View/homePage.dart';
import 'package:esi_lost_my_item/controllers/items_controllers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../View/loginScreen.dart';

class AuthController extends GetxController {
  static AuthController controller = Get.find();
  final FirebaseAuth? auth = FirebaseAuth.instance;
  late Rx<User?> firebaseUser;

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    firebaseUser = Rx<User?>(auth!.currentUser);
    firebaseUser.bindStream(auth!.userChanges());
    ever(firebaseUser, initialScreen);
  }

  initialScreen(User? user) async {
    if (user == null) {
      Get.offAll(()=>LoginScreen());
    } else {
      Get.put(ItemsController());

      Get.offAll(()=>HomePage());
      ItemsController.controller.getFoundItems();
      ItemsController.controller.getLostItems();
      print("LOGGED IN");
    }
  }

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<void> loginGoogle() async {
    final user = await signInWithGoogle();
    print(user.user!.email);
    print(user.user!.displayName);

    if (user == null) {
      Get.rawSnackbar(
          message: "Error while login",
          borderRadius: 20,
          margin: EdgeInsets.all(5),
          backgroundColor: Colors.red);
      // _showToast("${AppLocalizations.of(context).login_err}", Colors.red);

    } else {
      if (user.user!.email!.contains("@")) {
        await FirebaseDatabase.instance
            .ref()
            .child("users")
            .child(firebaseUser.value!.uid)
            .once()
            .then((DatabaseEvent dataSnapshot) async {
          if (dataSnapshot.snapshot.value == null) {
            var userData = {
              'email': user.user?.email,
              'name': user.user?.displayName,
              'profileImage':user.user?.photoURL,
              'firstUse': true,
              'confirmed': false
            };
            await FirebaseDatabase.instance
                .ref()
                .child("users")
                .child(firebaseUser.value!.uid)
                .update(userData);
          }
        });
      }else
      {

        await GoogleSignIn().signOut();
        await AuthController.controller.auth!.signOut();
        Get.rawSnackbar(
          borderRadius: 30,margin: EdgeInsets.only(bottom: 10),
          message: "You must login only with esi sba email",
          backgroundColor: Colors.redAccent,
          padding: EdgeInsets.all(12)
        );
      }
    }
  }
}
