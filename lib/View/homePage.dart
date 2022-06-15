import 'package:auto_size_text/auto_size_text.dart';
import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:esi_lost_my_item/View/foundItem.dart';
import 'package:esi_lost_my_item/controllers/items_controllers.dart';
import 'package:esi_lost_my_item/main.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../controllers/auth_controller.dart';
import 'custom_navigation_bar.dart';
import 'lostItem.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _inactiveColor = Colors.grey;

  int currentIndex = 0;

  Widget buildImage(String url, int index) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12),
      color: Colors.white,
      child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: Image.network(
            url,
            fit: BoxFit.cover,
          )),
    );
  }

  Widget _buildBottomBarDriver() {
    return CustomAnimatedBottomBar(
      containerHeight: 70,
      backgroundColor: Colors.white,
      selectedIndex: currentIndex,
      showElevation: true,
      itemCornerRadius: 24,
      curve: Curves.easeIn,
      onItemSelected: (index) {
        setState(() {
          currentIndex = index;
        });
      },
      items: <BottomNavyBarItem>[
        BottomNavyBarItem(
          icon: Icon(Icons.map_sharp),
          title: AutoSizeText('Home'),
          activeColor: Colors.blue,
          inactiveColor: _inactiveColor,
          textAlign: TextAlign.center,
        ),
        BottomNavyBarItem(
          icon: Icon(Icons.monetization_on),
          title: AutoSizeText('Lost Items'),
          activeColor: Colors.red.shade700,
          inactiveColor: _inactiveColor,
          textAlign: TextAlign.center,
        ),
        BottomNavyBarItem(
          icon: Icon(Icons.check_circle),
          title: AutoSizeText(
            'Found items',
          ),
          activeColor: Colors.green.shade700,
          inactiveColor: _inactiveColor,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget getBody() {
    List<Widget> pages = [
      Stack(children: [
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
                    "Welcome back ${AuthController.controller.auth!.currentUser!.displayName!}",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: textcolor),
                    maxLines: 1,
                  ),
                  InkWell(                    onLongPress: ()async {if(await confirm(context,title: Text("Logout confirmation ?")

                    )){
                      await AuthController.controller.auth!.signOut();
                      await GoogleSignIn().signOut();
                    }

                      },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Image.network(
                        AuthController.controller.auth!.currentUser!.photoURL!,
                        height: 50,
                        width: 50,
                        fit: BoxFit.cover,
                      ),
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
      Container(
        color: textcolor,
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Obx(() => SizedBox(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.8,
                    child: ListView.builder(
                      itemCount: ItemsController.controller.lostItemList.length,
                      itemBuilder: (context, index) => Card(
                        color: Colors.white.withOpacity(1),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        elevation: 4,
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: ItemsController.controller
                                    .lostItemList[index].picUrl.isEmpty
                                ? Column(
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            "Object description :",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            width: 15,
                                          ),
                                          Text(
                                            ItemsController.controller
                                                .lostItemList[index].name,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: textcolor),
                                            maxLines: 3,
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "Last seen in :",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            width: 15,
                                          ),
                                          Text(
                                            ItemsController.controller
                                                .lostItemList[index].place,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: textcolor),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "Time :",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Text(ItemsController.controller
                                              .lostItemList[index].time)
                                        ],
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      SizedBox(
                                        width: double.infinity,
                                        height: 60,
                                        child: Card(
                                          color: Colors.green.shade100,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30)),
                                          elevation: 5,
                                          child: Center(
                                            child: ListTile(
                                              leading: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                                child: Image.network(
                                                  ItemsController
                                                      .controller
                                                      .lostItemList[index]
                                                      .user
                                                      .profilePic,
                                                  width: 40,
                                                  height: 40,
                                                  fit: BoxFit.fill,
                                                ),
                                              ),
                                              title: Text(
                                                ItemsController
                                                    .controller
                                                    .lostItemList[index]
                                                    .user
                                                    .name,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              trailing: IconButton(
                                                onPressed: () {
                                                  Clipboard.setData(
                                                      ClipboardData(
                                                          text: ItemsController
                                                              .controller
                                                              .lostItemList[
                                                                  index]
                                                              .user
                                                              .email));
                                                  Get.rawSnackbar(
                                                      message:
                                                          "Email has been copied to clipboard",
                                                      borderRadius: 20,
                                                      margin: EdgeInsets.all(5),
                                                      backgroundColor:
                                                          Colors.green);
                                                },
                                                icon: Icon(
                                                  Icons.email,
                                                  color: Colors.green,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      if (AuthController.controller.auth!
                                              .currentUser!.uid ==
                                          ItemsController.controller
                                              .lostItemList[index].user.id)
                                        Container(
                                            height: 50,
                                            width: double.infinity,
                                            padding: const EdgeInsets.fromLTRB(
                                                10, 0, 10, 0),
                                            child: ElevatedButton(
                                              style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                          Color.fromARGB(255, 0,
                                                              101, 255)),
                                                  shape: MaterialStateProperty
                                                      .all<RoundedRectangleBorder>(
                                                          RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30.0),
                                                  ))),
                                              child: const Text(
                                                'I found my item',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                              ),
                                              onPressed: () async {
                                                if (await confirm(context)) {
                                                  await FirebaseDatabase
                                                      .instance
                                                      .ref()
                                                      .child("lostItems")
                                                      .child(ItemsController
                                                          .controller
                                                          .lostItemList[index]
                                                          .id)
                                                      .remove();
                                                  return print('pressedOK');
                                                } else {
                                                  return print('pressedCancel');
                                                }
                                              },
                                            )),
                                    ],
                                  )
                                : Column(
                                    children: [
                                      CarouselSlider.builder(
                                          itemCount: ItemsController
                                              .controller
                                              .lostItemList[index]
                                              .picUrl
                                              .length,
                                          options: CarouselOptions(height: 150),
                                          itemBuilder:
                                              (context, index1, realIndex) {
                                            final img = ItemsController
                                                .controller
                                                .lostItemList[index]
                                                .picUrl[index1];
                                            return buildImage(img, index1);
                                          }),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Object description :",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            width: 15,
                                          ),
                                          Flexible(
                                            child: Text(
                                              ItemsController.controller
                                                  .lostItemList[index].name,
                                              maxLines: 3,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: textcolor),
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Last seen in :",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            width: 15,
                                          ),
                                          Flexible(
                                            child: Text(
                                              ItemsController.controller
                                                  .lostItemList[index].place,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: textcolor),
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "Time :",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            width: 15,
                                          ),
                                          Text(
                                            ItemsController.controller
                                                .lostItemList[index].time,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.red),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      SizedBox(
                                        width: double.infinity,
                                        height: 60,
                                        child: Card(
                                          color: Colors.green.shade100,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30)),
                                          elevation: 5,
                                          child: Center(
                                            child: ListTile(
                                              leading: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                                child: Image.network(
                                                  ItemsController
                                                      .controller
                                                      .lostItemList[index]
                                                      .user
                                                      .profilePic,
                                                  width: 40,
                                                  height: 40,
                                                  fit: BoxFit.fill,
                                                ),
                                              ),
                                              title: Text(
                                                ItemsController
                                                    .controller
                                                    .lostItemList[index]
                                                    .user
                                                    .name,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              trailing: IconButton(
                                                onPressed: () {
                                                  Clipboard.setData(
                                                      ClipboardData(
                                                          text: ItemsController
                                                              .controller
                                                              .lostItemList[
                                                                  index]
                                                              .user
                                                              .email));
                                                  Get.rawSnackbar(
                                                      message:
                                                          "Email has been copied to clipboard",
                                                      borderRadius: 20,
                                                      margin: EdgeInsets.all(5),
                                                      backgroundColor:
                                                          Colors.green);
                                                },
                                                icon: Icon(
                                                  Icons.email,
                                                  color: Colors.green,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      if (AuthController.controller.auth!
                                              .currentUser!.uid ==
                                          ItemsController.controller
                                              .lostItemList[index].user.id)
                                        Container(
                                            height: 50,
                                            width: double.infinity,
                                            padding: const EdgeInsets.fromLTRB(
                                                10, 0, 10, 0),
                                            child: ElevatedButton(
                                              style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                          Color.fromARGB(255, 0,
                                                              101, 255)),
                                                  shape: MaterialStateProperty
                                                      .all<RoundedRectangleBorder>(
                                                          RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30.0),
                                                  ))),
                                              child: const Text(
                                                'I found my item',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                              ),
                                              onPressed: () async {
                                                if (await confirm(context)) {
                                                  await FirebaseDatabase
                                                      .instance
                                                      .ref()
                                                      .child("lostItems")
                                                      .child(ItemsController
                                                          .controller
                                                          .lostItemList[index]
                                                          .id)
                                                      .remove();
                                                  return print('pressedOK');
                                                } else {
                                                  return print('pressedCancel');
                                                }
                                              },
                                            )),
                                    ],
                                  )),
                      ),
                    ),
                  ))
            ],
          ),
        ),
      ),
      Container(
        color: textcolor,
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Obx(() => SizedBox(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.8,
                    child: ListView.builder(
                      itemCount:
                          ItemsController.controller.foundItemList.length,
                      itemBuilder: (context, index) => Card(
                        color: Colors.white.withOpacity(1),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        elevation: 4,
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                CarouselSlider.builder(
                                    itemCount: ItemsController.controller
                                        .foundItemList[index].picUrl.length,
                                    options: CarouselOptions(height: 150),
                                    itemBuilder: (context, index1, realIndex) {
                                      final img = ItemsController.controller
                                          .foundItemList[index].picUrl[index1];
                                      return buildImage(img, index1);
                                    }),
                                SizedBox(
                                  height: 8,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Object description :",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Flexible(
                                      child: Text(
                                        ItemsController.controller
                                            .foundItemList[index].name,
                                        maxLines: 3,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: textcolor),
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "Time :",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Text(
                                      ItemsController
                                          .controller.foundItemList[index].time,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                SizedBox(
                                  width: double.infinity,
                                  height: 60,
                                  child: Card(
                                    color: Colors.green.shade100,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                    elevation: 5,
                                    child: Center(
                                      child: ListTile(
                                        leading: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          child: Image.network(
                                            ItemsController
                                                .controller
                                                .foundItemList[index]
                                                .user
                                                .profilePic,
                                            width: 40,
                                            height: 40,
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                        title: Text(
                                          ItemsController.controller
                                              .foundItemList[index].user.name,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        trailing: IconButton(
                                          onPressed: () {
                                            Clipboard.setData(ClipboardData(
                                                text: ItemsController
                                                    .controller
                                                    .foundItemList[index]
                                                    .user
                                                    .email));
                                            Get.rawSnackbar(
                                                message:
                                                    "Email has been copied to clipboard",
                                                borderRadius: 20,
                                                margin: EdgeInsets.all(5),
                                                backgroundColor: Colors.green);
                                          },
                                          icon: Icon(
                                            Icons.email,
                                            color: Colors.green,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                if (AuthController
                                        .controller.auth!.currentUser!.uid ==
                                    ItemsController.controller
                                        .foundItemList[index].user.id)
                                  Container(
                                      height: 50,
                                      width: double.infinity,
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 0, 10, 0),
                                      child: ElevatedButton(
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    Color.fromARGB(
                                                        255, 0, 101, 255)),
                                            shape: MaterialStateProperty.all<
                                                    RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30.0),
                                            ))),
                                        child: const Text(
                                          'I found the owner',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        onPressed: () async {
                                          if (await confirm(context)) {
                                            await FirebaseDatabase.instance
                                                .ref()
                                                .child("foundItems")
                                                .child(ItemsController
                                                    .controller
                                                    .foundItemList[index]
                                                    .id)
                                                .remove();
                                            return print('pressedOK');
                                          } else {
                                            return print('pressedCancel');
                                          }
                                        },
                                      )),
                              ],
                            )),
                      ),
                    ),
                  ))
            ],
          ),
        ),
      )
    ];

    return IndexedStack(
      index: currentIndex,
      children: pages,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          bottomNavigationBar: _buildBottomBarDriver(), body: getBody()),
    );
  }
}
