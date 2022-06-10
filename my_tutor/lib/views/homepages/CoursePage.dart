// ignore_for_file: non_constant_identifier_names, prefer_typing_uninitialized_variables

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:my_tutor/model/course.dart';
import 'package:my_tutor/model/tutor.dart';
import 'package:number_paginator/number_paginator.dart';
import 'package:http/http.dart' as http;

class CoursePage extends StatefulWidget {
  const CoursePage({Key? key}) : super(key: key);

  @override
  State<CoursePage> createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursePage> {
  List<Course> CourseList = <Course>[];
  List<Tutor> TutorList = <Tutor>[];
  var _numPages, _currentPage = 1;
  var titlecenter = "";
  @override
  void initState() {
    super.initState();
    loadCourse();
    loadTutor();
  }

  void _loadCourseDetails(int index) {
    Tutor chosenTutor = Tutor();
    for (var tutor in TutorList) {
      if (tutor.tutor_id == CourseList[index].tutor_id) {
        chosenTutor = tutor;
      }
    }
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: const Text(
              "Course Details",
              style: TextStyle(),
            ),
            content: SingleChildScrollView(
                child: Column(
              children: [
                CachedNetworkImage(
                  imageUrl: "http://10.19.48.148/myTutorAPI/assets/courses/" +
                      CourseList[index].subject_id.toString() +
                      '.jpg',
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      const LinearProgressIndicator(),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
                Container(
                  margin: const EdgeInsets.all(8),
                  child: Text(
                    CourseList[index].subject_name.toString(),
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Card(
                    color: Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3.0),
                    ),
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      child: Text(
                          "Course Detail: \n" +
                              CourseList[index].subject_description.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                          )),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Card(
                          color: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: Container(
                            margin: const EdgeInsets.all(8),
                            child: Text(
                                "RM " +
                                    double.parse(CourseList[index]
                                            .subject_price
                                            .toString())
                                        .toStringAsFixed(2),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                )),
                          ),
                        ),
                        Card(
                          color: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: Container(
                            margin: const EdgeInsets.all(8),
                            child: Text(
                                CourseList[index].subject_sessions.toString() +
                                    " session",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                )),
                          ),
                        ),
                        Card(
                          color: Colors.amber,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: Container(
                              alignment: Alignment.centerLeft,
                              margin: const EdgeInsets.fromLTRB(5, 5, 6, 5),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.star, color: Colors.white),
                                  Text(
                                      CourseList[index]
                                          .subject_rating
                                          .toString(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      )),
                                ],
                              )),
                        ),
                      ],
                    ),
                  ),
                  Card(
                    color: Colors.purple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      child: Center(
                        child: Text(
                          "Tutor: " + chosenTutor.tutor_name.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ])
              ],
            )),
            actions: [
              TextButton(
                child: const Text(
                  "Close",
                  style: TextStyle(),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  void loadCourse() {
    _numPages ?? 1;
    http.post(Uri.parse("http://10.19.48.148/myTutorAPI/load_subject.php"),
        body: {
          'page': _currentPage.toString(),
        }).timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        return http.Response(
            'Error', 408); // Request Timeout response status code
      },
    ).then((response) {
      var jsondata = jsonDecode(response.body);
      if (response.statusCode == 200 && jsondata['status'] == 'success') {
        var extractdata = jsondata['data'];
        _numPages = int.parse(jsondata['totalPages']);

        if (extractdata['courses'] != null) {
          CourseList = <Course>[];
          extractdata['courses'].forEach((v) {
            CourseList.add(Course.fromJson(v));
          });
          titlecenter = CourseList.length.toString() + " Courses Available";
        } else {
          titlecenter = "No Course Available";
          CourseList.clear();
        }
        setState(() {});
      } else {
        titlecenter = "No Course Available 2";
        CourseList.clear();
        setState(() {});
      }
    });
  }

  void loadTutor() {
    http.post(Uri.parse("http://10.19.48.148/myTutorAPI/load_tutor.php"),
        body: {
          'page': _currentPage.toString(),
          'limit': 'all',
        }).timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        return http.Response(
            'Error', 408); // Request Timeout response status code
      },
    ).then((response) {
      var jsondata = jsonDecode(response.body);
      if (response.statusCode == 200 && jsondata['status'] == 'success') {
        var extractdata = jsondata['data'];

        if (extractdata['tutors'] != null) {
          TutorList = <Tutor>[];
          extractdata['tutors'].forEach((v) {
            TutorList.add(Tutor.fromJson(v));
          });
        } else {
          TutorList.clear();
        }
        setState(() {});
      } else {
        TutorList.clear();
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text('Course'),
            centerTitle: true,
            automaticallyImplyLeading: false),
        body: CourseList.isEmpty
            ? Center(
                child: Text(
                titlecenter,
                style: const TextStyle(fontSize: 60),
              ))
            : SingleChildScrollView(
                physics: const ScrollPhysics(),
                child: Column(
                  children: <Widget>[
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: CourseList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () => {_loadCourseDetails(index)},
                          child: SizedBox(
                              height: 200,
                              child: Card(
                                margin:
                                    const EdgeInsets.fromLTRB(15, 10, 15, 5),
                                child: Row(
                                  children: [
                                    Flexible(
                                      flex: 4,
                                      child: Container(
                                        margin: const EdgeInsets.fromLTRB(
                                            0, 0, 5, 0),
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              "http://10.19.48.148/myTutorAPI/assets/courses/" +
                                                  CourseList[index]
                                                      .subject_id
                                                      .toString() +
                                                  '.jpg',
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) =>
                                              const LinearProgressIndicator(),
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.error),
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                        flex: 6,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.all(5),
                                              child: Text(
                                                CourseList[index]
                                                    .subject_name
                                                    .toString(),
                                                style: const TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            Container(
                                              margin: const EdgeInsets.all(8),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Card(
                                                    color: Colors.green,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15.0),
                                                    ),
                                                    child: Container(
                                                      margin:
                                                          const EdgeInsets.all(
                                                              8),
                                                      child: Text(
                                                          "RM " +
                                                              double.parse(CourseList[
                                                                          index]
                                                                      .subject_price
                                                                      .toString())
                                                                  .toStringAsFixed(
                                                                      2),
                                                          style:
                                                              const TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 15,
                                                          )),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Card(
                                                    color: Colors.blue,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15.0),
                                                    ),
                                                    child: Container(
                                                      margin:
                                                          const EdgeInsets.all(
                                                              8),
                                                      child: Text(
                                                          CourseList[index]
                                                                  .subject_sessions
                                                                  .toString() +
                                                              " session",
                                                          style:
                                                              const TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 15,
                                                          )),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                                alignment: Alignment.centerLeft,
                                                margin:
                                                    const EdgeInsets.fromLTRB(
                                                        20, 5, 5, 5),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    const Icon(Icons.star,
                                                        color: Colors.amber),
                                                    Text(
                                                        CourseList[index]
                                                            .subject_rating
                                                            .toString(),
                                                        style: const TextStyle(
                                                          color: Colors.amber,
                                                          fontSize: 16,
                                                        )),
                                                  ],
                                                )),
                                          ],
                                        ))
                                  ],
                                ),
                              )),
                        );
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: NumberPaginator(
                        numberPages: _numPages ?? 1,
                        onPageChange: (int index) {
                          setState(() {
                            _currentPage = index + 1;
                            loadCourse();
                            // loadTutor();
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ));
  }
}
