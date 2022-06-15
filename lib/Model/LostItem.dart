import 'User.dart';

class LostItem
{
late String id;
late String name;
late String place;
late String time;
late AppUser user;
late DateTime createdAT;
late List<String> picUrl;

LostItem.name(this.id,this.name, this.place, this.time, this.user,this.createdAT, this.picUrl);
}