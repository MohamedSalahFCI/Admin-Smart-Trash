import 'package:b_smart_trash/notification_properties.dart';

class ReadNotification {
  final List<NotifyProperties> target;
  final bool read;
  final bool deleted;
  final String description;
  final Map resource;
  final int subject;
  final String createdAt;
  final String updatedAt;
  final int id;

  ReadNotification(
      {this.target,
      this.read,
      this.deleted,
      this.description,
      this.resource,
      this.subject,
      this.createdAt,
      this.updatedAt,
      this.id});

  factory ReadNotification.fromJson(Map<String, dynamic> json) {
    return new ReadNotification(
        target: (json['target'] as List)
            .map((e) => NotifyProperties.fromJson(e))
            .toList(),
        read: json['read'],
        deleted: json['deleted'],
        description: json['description'],
        resource: json['resource'],
        subject: json['subject'],
        createdAt: json['createdAt'],
        updatedAt: json['updatedAt'],
        id: json["id"]);
  }
}
