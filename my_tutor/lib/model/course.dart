// ignore_for_file: non_constant_identifier_names

class Course {
  String? subject_id;
  String? subject_name;
  String? subject_description;
  String? subject_price;
  String? tutor_id;
  String? subject_sessions;
  String? subject_rating;

  Course(
      {this.subject_id,
      this.subject_name,
      this.subject_description,
      this.subject_price,
      this.tutor_id,
      this.subject_sessions,
      this.subject_rating});

  Course.fromJson(Map<String, dynamic> json) {
    subject_id = json['subject_id'].toString();
    subject_name = json['subject_name'];
    subject_description = json['subject_description'];
    subject_price = json['subject_price'].toString();
    tutor_id = json['tutor_id'];
    subject_sessions = json['subject_sessions'].toString();
    subject_rating = json['subject_rating'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['subject_id'] = subject_id;
    data['subject_name'] = subject_name;
    data['subject_description'] = subject_description;
    data['subject_price'] = subject_price;
    data['tutor_id'] = tutor_id;
    data['subject_sessions'] = subject_sessions;
    data['subject_rating'] = subject_rating;
    return data;
  }
}
