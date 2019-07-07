import 'package:b_smart_trash/properties.dart';

class GetAllTrashes {
  final List<Properties> myData;

  GetAllTrashes({
    this.myData,
  });

  factory GetAllTrashes.fromJson(Map<String, dynamic> json) {
    return new GetAllTrashes(
      myData:
          (json['data'] as List).map((e) => Properties.fromJson(e)).toList(),
    );
  }
}
