import 'User.dart';

class FoundItem
{
  late String id;
  late String name;
  late String time;
  late AppUser user;
  late List<String> picUrl;
  late DateTime createdAT;
  FoundItem.name(this.id,this.name, this.time, this.user, this.createdAT,this.picUrl);
}