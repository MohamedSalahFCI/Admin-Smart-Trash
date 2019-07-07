import 'package:b_smart_trash/message_properties.dart';

class GetAllMessages {
  final List<MessageProperties> myData;

  GetAllMessages({
    this.myData,
  });

  factory GetAllMessages.fromJson(Map<String, dynamic> json) {
    return new GetAllMessages(
      myData: (json['data'] as List)
          .map((e) => MessageProperties.fromJson(e))
          .toList(),
    );
  }
}
