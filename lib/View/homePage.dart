import 'package:auto_size_text/auto_size_text.dart';
import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:esi_lost_my_item/View/foundItem.dart';
import 'package:esi_lost_my_item/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../controllers/auth_controller.dart';
import 'lostItem.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(children: [
          Container(
            color: Color.fromARGB(255, 240, 245, 247),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.7,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AutoSizeText(
                      "Welcome back ${AuthController.controller.auth!.currentUser!.displayName!}",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: textcolor),
                      maxLines: 1,
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Image.network(
                        AuthController.controller.auth!.currentUser!.photoURL!,
                        height: 50,
                        width: 50,
                        fit: BoxFit.cover,
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.32,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      BouncingWidget(
                        duration: Duration(milliseconds: 200),
                        scaleFactor: 1.5,
                        onPressed: () async {
                          // await AuthController.controller.loginGoogle();
                          Get.to(() => LostItem(),
                              duration: Duration(milliseconds: 800),
                              transition: Transition.cupertino);
                        },
                        child: Material(
                          borderRadius: BorderRadius.circular(12),
                          elevation: 10,
                          child: Container(
                            height: 60,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.red.shade400),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                    flex: 1,
                                    child: Icon(
                                      FontAwesomeIcons.magnifyingGlass,
                                      color: Colors.white,
                                    )),
                                Expanded(
                                    flex: 2,
                                    child: AutoSizeText(
                                      "I LOST MY ITEM",
                                      maxLines: 1,
                                      style: GoogleFonts.montserrat(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontSize: 18),
                                    ))
                              ],
                            ),
                          ),
                        ),
                      ),
                      BouncingWidget(
                        duration: Duration(milliseconds: 200),
                        scaleFactor: 1.5,
                        onPressed: () async {
                          Get.to(() => FoundItem(),
                              duration: Duration(milliseconds: 800),
                              transition: Transition.cupertino);
                        },
                        child: Material(
                          borderRadius: BorderRadius.circular(12),
                          elevation: 10,
                          child: Container(
                            height: 60,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.green.shade400),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                    flex: 1,
                                    child: Icon(
                                        FontAwesomeIcons
                                            .magnifyingGlassArrowRight,
                                        color: Colors.white)),
                                Expanded(
                                    flex: 2,
                                    child: AutoSizeText(
                                      "I FOUND AN ITEM",
                                      maxLines: 1,
                                      style: GoogleFonts.montserrat(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontSize: 18),
                                    ))
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
