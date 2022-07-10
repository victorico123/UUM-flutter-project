// ignore_for_file: non_constant_identifier_names

class Cart {
  String? id;
  String? subject_id;
  String? user_id;

  Cart({this.id, this.subject_id, this.user_id});

  Cart.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    subject_id = json['subject_id'].toString();
    user_id = json['user_id'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['subject_id'] = subject_id;
    data['user_id'] = user_id;
    return data;
  }
}
