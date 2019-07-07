import 'package:b_smart_trash/notification.dart';

class MyNotification {
  final List<ReadNotification> myData;
  final int page;
  final int pageCount;
  final int limit;
  final int totalCount;
  final Map links;
  MyNotification(
      {this.myData,
      this.page,
      this.pageCount,
      this.limit,
      this.totalCount,
      this.links});
  factory MyNotification.fromJson(Map<String, dynamic> json) {
    return new MyNotification(
        myData: (json['data'] as List)
            .map((e) => ReadNotification.fromJson(e))
            .toList(),
        page: json['page'],
        pageCount: json['pageCount'],
        limit: json['limit'],
        totalCount: json['totalCount'],
        links: json['links']);
  }
}
