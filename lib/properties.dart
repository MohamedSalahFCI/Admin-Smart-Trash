class Properties {
  final List destination;
  final String status;
  final bool deleted;
  final String color;
  final String number;
  final String createdAt;
  final String updatedAt;
  final int id;

  Properties(
      {this.destination,
      this.status,
      this.deleted,
      this.color,
      this.number,
      this.createdAt,
      this.updatedAt,
      this.id});

  factory Properties.fromJson(Map<String, dynamic> json) {
    return new Properties(
        destination: json['destination'],
        status: json['status'],
        deleted: json['deleted'],
        color: json['color'],
        number: json['number'],
        createdAt: json['createdAt'],
        updatedAt: json['updatedAt'],
        id: json['id']);
  }
}
