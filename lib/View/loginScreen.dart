import 'package:auto_size_text/auto_size_text.dart';
import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:esi_lost_my_item/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../controllers/auth_controller.dart';


class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children:[
            Container(  color: Color.fromARGB(255, 240, 245, 247),),
            Center(
            child: Container(

              height: MediaQuery.of(context).size.height * 0.5,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  AutoSizeText(
                    "Login with ESI-SBA Email",overflow: TextOverflow.fade,
                    style: GoogleFonts.montserrat(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: textcolor),
                    // minFontSize: 26,
                    maxLines: 1,
                  ),
                  BouncingWidget(
                    duration: Duration(milliseconds: 200),
                    scaleFactor: 1.5,
                    onPressed: () async{
                      await AuthController.controller.loginGoogle();
                    },
                    child: Material(
                      borderRadius: BorderRadius.circular(12),
                      elevation: 10,
                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.white),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                                flex: 1, child: SvgPicture.asset(
                                "assets/googleLogo.svg",
                                semanticsLabel: 'Google Logo'
                            )),
                            Expanded(
                                flex: 2,
                                child: AutoSizeText(
                                  "Sign in with Google",
                                  maxLines: 1,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ))
                          ],
                        ),
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ),]
        ),
      ),
    );
  }
}
