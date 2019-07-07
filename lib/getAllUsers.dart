import 'package:b_smart_trash/properties2.dart';

class GetAllUsers {
  final List<Properties2> myData;

  GetAllUsers({
    this.myData,
  });

  factory GetAllUsers.fromJson(Map<String, dynamic> json) {
    return new GetAllUsers(
      myData:
          (json['data'] as List).map((e) => Properties2.fromJson(e)).toList(),
    );
  }
}
