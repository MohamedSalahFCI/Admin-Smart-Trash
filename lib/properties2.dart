class Properties2 {
  final String type;
  final bool active;
  final int rate;
  final List token;
  final bool deleted;
  final String firstname;
  final String lastname;
  final String phone;
  final String email;
  final String img;
  final String createdAt;
  final String updatedAt;
  final int verifycode;
  final int id;

  Properties2(
      {this.type,
      this.active,
      this.rate,
      this.token,
      this.deleted,
      this.firstname,
      this.lastname,
      this.phone,
      this.email,
      this.img,
      this.createdAt,
      this.updatedAt,
      this.verifycode,
      this.id});

  factory Properties2.fromJson(Map<String, dynamic> json) {
    return new Properties2(
        type: json['type'],
        active: json['active'],
        rate: json['rate'],
        token: json['token'],
        deleted: json['deleted'],
        firstname: json['firstname'],
        lastname: json['lastname'],
        phone: json['phone'],
        email: json['email'],
        img: json['img'],
        createdAt: json['createdAt'],
        updatedAt: json['updatedAt'],
        verifycode: json['verifycode'],
        id: json['id']);
  }
}
