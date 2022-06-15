import 'package:esi_lost_my_item/Model/LostItem.dart';
import 'package:esi_lost_my_item/Model/foundItem.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';

import '../Model/User.dart';

class ItemsController extends GetxController {
  static ItemsController controller = Get.find();
  RxList<LostItem> lostItemList = <LostItem>[].obs;
  RxList<FoundItem> foundItemList = <FoundItem>[].obs;

  var lostItemsRef = FirebaseDatabase.instance.ref().child("lostItems").ref;
  var foundItemsRef = FirebaseDatabase.instance.ref().child("foundItems").ref;

  Future getLostItems() async {
    print('GETTING ITEMX');

    lostItemsRef.onValue.forEach((element) async {
      lostItemList.clear();
      for (final child in element.snapshot.children) {
        print('NEW ITEM CLEARING LISt');
        List<String> carImg = <String>[];
        carImg.clear();
        var es = await FirebaseDatabase.instance
            .ref()
            .child("users")
            .child(child.child("user").value.toString())
            .get();
        var imgRef =  FirebaseDatabase.instance
            .ref()
            .child("lostItems")
            .child(child.key.toString())
            .child("picsUrl")
            .ref;

        var response = await   imgRef.get();
        for (final child in response.children) {
          print("THIS IS TIOMGGGGGGGG ${child.value.toString()}");
          carImg.add(child.value.toString());
        }
        AppUser user = AppUser(
            es.child("email").value.toString(),
            es.child("name").value.toString(),
            es.child("profileImage").value.toString());
        LostItem item = LostItem.name(
            child.key!,
            child.child("name").value.toString(),
            child.child("place").value.toString(),
            child.child("time").value.toString(),
            user,
            DateTime.parse(child.child("createdAt").value.toString()),
            carImg);
        lostItemList.add(item);
        print(lostItemList[0].picUrl.length);
      }
      for (final s in lostItemList) {
        print("this is s ${s.picUrl.length}");
      }
    });
  }

  Future getFoundItems() async {

    foundItemsRef.onValue.forEach((element) async {
      foundItemList.clear();
      for (final child in element.snapshot.children) {
        print('NEW ITEM CLEARING LISt');
        List<String> carImg = <String>[];
        carImg.clear();
        var es = await FirebaseDatabase.instance
            .ref()
            .child("users")
            .child(child.child("user").value.toString())
            .get();
        var imgRef =  FirebaseDatabase.instance
            .ref()
            .child("foundItems")
            .child(child.key.toString())
            .child("picsUrl")
            .ref;

        var response = await   imgRef.get();
        for (final child in response.children) {
          print("THIS IS TIOMGGGGGGGG ${child.value.toString()}");
          carImg.add(child.value.toString());
        }
        AppUser user = AppUser(
            es.child("email").value.toString(),
            es.child("name").value.toString(),
            es.child("profileImage").value.toString());
        FoundItem item = FoundItem.name(
            child.key!,
            child.child("name").value.toString(),
            child.child("time").value.toString(),
            user,
            DateTime.parse(child.child("createdAt").value.toString()),
            carImg);
        foundItemList.add(item);
        print(foundItemList[0].picUrl.length);
      }
      for (final s in foundItemList) {
        print("this is s ${s.picUrl.length}");
      }
    });
  }
}
