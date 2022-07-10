// ignore_for_file: prefer_typing_uninitialized_variables, non_constant_identifier_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:my_tutor/model/course.dart';
import 'package:my_tutor/model/tutor.dart';
import 'package:number_paginator/number_paginator.dart';
import 'package:http/http.dart' as http;
import 'package:my_tutor/global.dart' as gb;

class TutorPage extends StatefulWidget {
  const TutorPage({Key? key}) : super(key: key);

  @override
  State<TutorPage> createState() => _TutorPageState();
}

class _TutorPageState extends State<TutorPage> {
  List<Tutor> TutorList = <Tutor>[];
  List<Course> CurrrentTutorCourseList = <Course>[];
  var _numPages, _currentPage = 1;
  var titlecenter = "";
  double courseDetailListHeight = 50;
  @override
  void initState() {
    super.initState();
    loadTutor();
  }

  void _loadTutorDetails(int index) {
    setState(() {
      var tutor_id = index + 1;
      getTutorSubject(tutor_id.toString());
      _printTutorDetails(index);
    });
  }

  Future<void> _printTutorDetails(int index) async {
    await Future.delayed(const Duration(milliseconds: 200), () {});
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: const Text(
              "Tutor Details",
              style: TextStyle(),
            ),
            content: SingleChildScrollView(
                physics: const ScrollPhysics(),
                child: Column(
                  children: [
                    CachedNetworkImage(
                      imageUrl: gb.ip +
                          "assets/tutors/" +
                          TutorList[index].tutor_id.toString() +
                          '.jpg',
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          const LinearProgressIndicator(),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                    Container(
                      margin: const EdgeInsets.all(8),
                      child: Text(
                        TutorList[index].tutor_name.toString(),
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(8),
                      child: Text(
                        "Courses Teach List:",
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                    Column(
                      children: <Widget>[
                        Container(
                          height:
                              courseDetailListHeight, // Change as per your requirement
                          width: 300.0,
                          child: CurrrentTutorCourseList.length == 0
                              ? Text('Empty',
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ))
                              : ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: CurrrentTutorCourseList.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Container(
                                      margin: const EdgeInsets.fromLTRB(
                                          0, 0, 0, 10),
                                      child: Text(
                                        CurrrentTutorCourseList[index]
                                            .subject_name
                                            .toString(),
                                        style: const TextStyle(
                                          fontSize: 14,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    );
                                  },
                                ),
                        ),
                      ],
                    ),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Card(
                            color: Colors.grey,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(3.0),
                            ),
                            child: Container(
                              margin: const EdgeInsets.all(8),
                              child: Text(
                                  "Tutor Description: \n" +
                                      TutorList[index]
                                          .tutor_description
                                          .toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                  )),
                            ),
                          ),
                          Card(
                            color: Colors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: Container(
                              margin: const EdgeInsets.all(8),
                              child: Center(
                                child: Text(
                                  TutorList[index].tutor_phone.toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                          Card(
                            color: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: Container(
                              margin: const EdgeInsets.all(8),
                              child: Center(
                                child: Text(
                                  TutorList[index].tutor_email.toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
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
                                  "Join Date: " +
                                      TutorList[index]
                                          .tutor_datereg
                                          .toString()
                                          .substring(0, 11),
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
                  setState(() {});
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  void loadTutor() {
    _numPages ?? 1;
    http.post(Uri.parse(gb.ip + "load_tutor.php"), body: {
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

        if (extractdata['tutors'] != null) {
          TutorList = <Tutor>[];
          extractdata['tutors'].forEach((v) {
            TutorList.add(Tutor.fromJson(v));
          });
        } else {
          titlecenter = "No Tutor Available";
          _numPages = 0;
          TutorList.clear();
        }
        setState(() {});
      } else {
        titlecenter = "No Tutor Available";
        _numPages = 0;
        TutorList.clear();
        setState(() {});
      }
    });
  }

  void getTutorSubject(String tutorId) {
    http.post(Uri.parse(gb.ip + "load_subject.php"), body: {
      'tutor_id_chosen': tutorId,
    }).timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        return http.Response(
            'Error', 408); // Request Timeout response status code
      },
    ).then((response) {
      var jsondata = jsonDecode(response.body);
      print(response.body);
      if (response.statusCode == 200 && jsondata['status'] == 'success') {
        var extractdata = jsondata['data'];

        if (extractdata['courses'] != null) {
          CurrrentTutorCourseList = <Course>[];
          extractdata['courses'].forEach((v) {
            CurrrentTutorCourseList.add(Course.fromJson(v));
          });
          courseDetailListHeight = CurrrentTutorCourseList.length * 50;
        } else {
          CurrrentTutorCourseList.clear();
        }
        setState(() {});
      } else {
        CurrrentTutorCourseList.clear();
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text('Tutor'),
            centerTitle: true,
            automaticallyImplyLeading: false),
        body: TutorList.isEmpty
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
                      itemCount: TutorList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () => {_loadTutorDetails(index)},
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
                                          imageUrl: gb.ip +
                                              "assets/tutors/" +
                                              TutorList[index]
                                                  .tutor_id
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
                                              margin: const EdgeInsets.all(10),
                                              child: Text(
                                                TutorList[index]
                                                    .tutor_name
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
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                      TutorList[index]
                                                          .tutor_email
                                                          .toString(),
                                                      style: const TextStyle(
                                                        color: Colors.green,
                                                        fontSize: 15,
                                                      )),
                                                  const SizedBox(
                                                    width: 30,
                                                  ),
                                                  Text(
                                                      TutorList[index]
                                                          .tutor_phone
                                                          .toString(),
                                                      style: const TextStyle(
                                                        color: Colors.green,
                                                        fontSize: 15,
                                                      )),
                                                ],
                                              ),
                                            ),
                                            Container(
                                                margin:
                                                    const EdgeInsets.fromLTRB(
                                                        20, 5, 5, 5),
                                                child: Text(
                                                    "Date Join: " +
                                                        TutorList[index]
                                                            .tutor_datereg
                                                            .toString()
                                                            .substring(0, 11),
                                                    style: const TextStyle(
                                                      color: Colors.blue,
                                                    ))
                                                // Text(TutorList[index]
                                                //     .subject_rating
                                                //     .toString()),
                                                ),
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
                            loadTutor();
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ));
  }
}
