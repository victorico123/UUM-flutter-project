class User {
  int? id;
  String? name;
  String? email;
  String? phone;
  String? address;
  String? image;

  User({this.id, this.email, this.name, this.phone, this.address, this.image});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    name = json['name'];
    phone = json['phone'];
    address = json['address'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['email'] = email;
    data['name'] = name;
    data['phone'] = phone;
    data['address'] = address;
    data['image'] = image;
    return data;
  }
}
