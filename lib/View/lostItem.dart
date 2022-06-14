import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:esi_lost_my_item/controllers/auth_controller.dart';
import 'package:esi_lost_my_item/main.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';

class LostItem extends StatefulWidget {
  const LostItem({Key? key}) : super(key: key);

  @override
  State<LostItem> createState() => _LostItemState();
}

class _LostItemState extends State<LostItem> {
  var ref = FirebaseDatabase.instance.ref().child("lostItems").push();
  var selectedDate = DateFormat("yyyy-MM-dd – kk:mm").format(DateTime.now());
  List<XFile> images = <XFile>[];
  final ImagePicker _picker = ImagePicker();
  TextEditingController name = TextEditingController();
  TextEditingController place = TextEditingController();
  GlobalKey<FormState> key = GlobalKey<FormState>();
  bool isLoading = false;
   var index = 0;
   var progress = 0.0;
  List<String> imgUrl = [];
  Future uploadImages(int a, File file) async {
    index = a;
    UploadTask task = FirebaseStorage.instance
        .ref()
        .child("lostItems")
        .child(ref.key!)
        .child(a.toString())
        .putFile(file);
    task.snapshotEvents.listen((event) {
      progress =
          ((event.bytesTransferred.toDouble() / event.totalBytes.toDouble()) *
              100)
              .roundToDouble();
      setState(() {

      });
      print(progress);
    });
    await task.whenComplete(() async {
      var s = await task.storage
          .ref()
          .child("lostItems")
          .child(ref.key!)
          .child(a.toString())
          .getDownloadURL();
      print("This is Img Url $s");
      imgUrl.add(s);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // appBar: AppBar(
        //   centerTitle: true,
        //   title: Text(
        //     "Item Lost",
        //     style: TextStyle(fontWeight: FontWeight.bold),
        //   ),
        // ),
        body: Form(
          key: key,
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            padding: EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Object description:",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: textcolor),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: name,autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator:  (value) => value!.isEmpty ? 'Object description cannot be blank' : null,
                        decoration: InputDecoration(
                            hintText: "EX: Man Watch",
                            isDense: true,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12))),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Where the last time you saw it ?",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: textcolor),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: place,
                        validator:  (value) => value!.isEmpty ? 'Object last seen cannot be blank' : null,autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: InputDecoration(
                            hintText: "EX: School library",
                            isDense: true,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12))),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Select the date you lost it  ?",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: textcolor),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 50,
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            DatePicker.showDateTimePicker(context,
                                showTitleActions: true,
                                minTime: DateTime(1900, 3, 5),
                                maxTime: DateTime.now(),
                                theme: DatePickerTheme(
                                    // headerColor: Colors.black,
                                    // backgroundColor: Colors.white,
                                    itemStyle: TextStyle(
                                        // color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                    doneStyle: TextStyle(
                                        // color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16)), onChanged: (date) {
                              print('change $date in time zone ' +
                                  date.timeZoneOffset.inHours.toString());
                            }, onConfirm: (date) {
                              print('confirm $date');
                              setState(() {
                                selectedDate = DateFormat("yyyy-MM-dd – kk:mm")
                                    .format(date);
                              });
                            },
                                currentTime: DateTime.now()
                                    .subtract(Duration(days: 6570)),
                                locale: LocaleType.en);
                          },
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<OutlinedBorder>(
                                RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            )),
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.blue),
                          ),
                          child: (selectedDate.toString() == null)
                              ? Text('No date chosen!')
                              : AutoSizeText(
                                  selectedDate.toString(),
                                  maxLines: 1,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Do you have any pictures of the item ?",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: textcolor),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all<OutlinedBorder>(
                              RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          )),
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.blue),
                        ),
                        onPressed: () async {
                          images = (await _picker.pickMultiImage())!;
                          setState(() {});
                        },
                        child: Text(
                          "Select images",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      (images.isEmpty)
                          ? const SizedBox()
                          : SizedBox(
                              height: MediaQuery.of(context).size.height * 0.3,
                              width: double.infinity,
                              child: CarouselSlider(
                                options: CarouselOptions(
                                    enableInfiniteScroll: false,
                                    height: MediaQuery.of(context).size.height *
                                        0.30),
                                items: images
                                    .map((item) => Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 0.0, horizontal: 10.0),
                                          child: Center(
                                              child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            child: Image.file(File(item.path),
                                                fit: BoxFit.fill,
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.25),
                                          )),
                                        ))
                                    .toList(),
                              )),
                      isLoading ?
                      Align(
                        alignment: Alignment.center,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 100,
                              height: 100,
                              child: LiquidCircularProgressIndicator(
                                value: progress / 100,
                                // Defaults to 0.5.
                                valueColor:
                                AlwaysStoppedAnimation(Colors.blue),
                                // Defaults to the current Theme's accentColor.
                                backgroundColor: Colors.white,
                                // Defaults to the current Theme's backgroundColor.
                                borderColor: Colors.green,
                                borderWidth: 5.0,
                                direction: Axis.vertical,
                                // The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right). Defaults to Axis.horizontal.
                                center: Text(
                                    "${progress} %",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black)),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Uploading Images ${index}/${images.length}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: textcolor),
                            )
                          ],
                        ),
                      )
                          : Align(
                        alignment: Alignment.center,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<OutlinedBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                )),
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.green.shade400),
                          ),
                          onPressed: () async {
                            if (key.currentState!
                                .validate()){
                              setState(() {
                                isLoading=true;
                              });
                              for (int i = 1;
                              i <= images.length;
                              i++) {
                                await uploadImages(
                                    i, File(images[i - 1].path));
                              }
                              Map<String,dynamic> map ={
                                'name':name.text.trim(),
                                'place':place.text.trim(),
                                'time':selectedDate,
                                'picsUrl':imgUrl,
                                'user':AuthController.controller.auth!.currentUser!.uid
                              };
                              await ref.update(map);

                            setState(() {
                              isLoading=false;
                            }); Get.back();
                            Get.rawSnackbar(
                                message: "Your items has been added successfully to the lost item list",
                                borderRadius: 20,
                                margin: EdgeInsets.all(5),
                                backgroundColor: Colors.green);
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 50, vertical: 15),
                            child: Text(
                              "Submit",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
