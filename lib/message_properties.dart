class MessageProperties {
  final bool replyStatus;
  final bool deleted;
  final String name;
  final String number;
  final String email;
  final String message;
  final Map user;
  final String createdAt;
  final String updatedAt;
  final String reply;
  final int id;

  MessageProperties(
      {this.replyStatus,
      this.deleted,
      this.name,
      this.number,
      this.email,
      this.message,
      this.user,
      this.createdAt,
      this.updatedAt,
      this.reply,
      this.id});

  factory MessageProperties.fromJson(Map<String, dynamic> json) {
    return new MessageProperties(
      replyStatus: json['replyStatus'],
      deleted: json['deleted'],
      name: json['name'],
      number: json['number'],
      email: json['email'],
      message: json['message'],
      user: json['user'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      reply: json['reply'],
      id: json['id'],
    );
  }
}
