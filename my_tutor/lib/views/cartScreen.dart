import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_tutor/model/cart.dart';
import 'package:my_tutor/model/course.dart';
import 'package:http/http.dart' as http;
import 'package:my_tutor/global.dart' as gb;
import 'package:my_tutor/model/tutor.dart';
import 'package:my_tutor/views/paymentScreen.dart';

class CartScreen extends StatefulWidget {
  CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<Course> CourseList = <Course>[];
  List<Tutor> TutorList = <Tutor>[];
  num totalPay = 0;
  // List<Cart> CartList = <Cart>[];
  String titlecenter = "";
  @override
  void initState() {
    super.initState();
    setState(() {
      loadCartCourse();
      loadTutor();
      processTotalPayment();
    });
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
                  imageUrl: gb.ip +
                      "assets/courses/" +
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
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red, // background
                    onPrimary: Colors.white, // foreground
                  ),
                  onPressed: () {
                    _removeCart(CourseList[index].subject_id.toString());
                  },
                  child: Text("Remove From Cart"))
            ],
          );
        });
  }

  void loadTutor() {
    http.post(Uri.parse(gb.ip + "load_tutor.php"), body: {
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

  void _removeCart(String index) {
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
              child: Center(
                child:
                    Text("Are You sure to remove this subject from your cart?"),
              ),
            ),
            actions: [
              TextButton(
                child: const Text(
                  "Cancel",
                  style: TextStyle(),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red, // background
                    onPrimary: Colors.white, // foreground
                  ),
                  onPressed: () {
                    removeFromCart(index);
                    Navigator.of(context).pop();
                  },
                  child: Text("Remove"))
            ],
          );
        });
  }

  void loadCartCourse() {
    http.post(Uri.parse(gb.ip + "load_cart.php"), body: {
      'userId': gb.globaUser.id.toString(),
    }).timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        return http.Response(
            'Error', 408); // Request Timeout response status code
      },
    ).then((response) {
      print(response.body);
      var jsondata = jsonDecode(response.body);
      if (response.statusCode == 200 && jsondata['status'] == 'success') {
        var extractdata = jsondata['data'];

        if (extractdata['courses'] != null) {
          CourseList = <Course>[];
          extractdata['courses'].forEach((v) {
            CourseList.add(Course.fromJson(v));
          });
          titlecenter = "Cart Available";
        } else {
          titlecenter = "Fail to get Course in Cart";
          CourseList.clear();
        }
      } else {
        titlecenter = "No Course Available in cart";
        CourseList.clear();
      }
      setState(() {
        processTotalPayment();
      });
    });
  }

  void removeFromCart(String subjectId) {
    http.post(Uri.parse(gb.ip + "delete_from_cart.php"), body: {
      'subjectId': subjectId,
      'userId': gb.globaUser.id.toString(),
    }).timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        return http.Response(
            'Error', 408); // Request Timeout response status code
      },
    ).then((response) {
      print(response.body);
      var jsondata = jsonDecode(response.body);
      if (response.statusCode == 200 && jsondata['status'] == 'success') {
        Fluttertoast.showToast(
            msg: "Success delete from cart",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
      } else {
        Fluttertoast.showToast(
            msg: "Failed delete from cart",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
      }
      if (subjectId != "-1") {
        Navigator.of(context).pop();
      }
      setState(() {
        loadCartCourse();
        processTotalPayment();
      });
    });
  }

  void processTotalPayment() {
    totalPay = 0;
    if (!CourseList.isEmpty) {
      for (var i = 0; i < CourseList.length; i++) {
        setState(() {
          totalPay += num.parse(CourseList[i].subject_price.toString());
        });
      }
    }
  }

  void _payment() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: const Text(
            "Pay Now",
            style: TextStyle(),
          ),
          content: const Text("Are you sure?", style: TextStyle()),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () async {
                Navigator.of(context).pop();
                await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (content) =>
                            PaymentScreen(totalPay: totalPay)));
              },
            ),
            TextButton(
              child: const Text(
                "No",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('My Cart'),
          centerTitle: true,
        ),
        body: CourseList.isEmpty
            ? Center(
                child: Text(
                titlecenter,
                style: const TextStyle(fontSize: 30),
              ))
            : SingleChildScrollView(
                physics: const ScrollPhysics(),
                child: Column(
                  children: [
                    CourseList.isEmpty
                        ? Center(
                            child: Container(
                            margin: EdgeInsets.all(10),
                            child: Text(
                              titlecenter,
                              style: const TextStyle(fontSize: 30),
                              textAlign: TextAlign.center,
                            ),
                          ))
                        : Column(
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
                                          margin: const EdgeInsets.fromLTRB(
                                              15, 10, 15, 5),
                                          child: Row(
                                            children: [
                                              Flexible(
                                                flex: 4,
                                                child: Container(
                                                  margin:
                                                      const EdgeInsets.fromLTRB(
                                                          0, 0, 5, 0),
                                                  child: CachedNetworkImage(
                                                    imageUrl: gb.ip +
                                                        "assets/courses/" +
                                                        CourseList[index]
                                                            .subject_id
                                                            .toString() +
                                                        '.jpg',
                                                    fit: BoxFit.cover,
                                                    placeholder: (context,
                                                            url) =>
                                                        const LinearProgressIndicator(),
                                                    errorWidget: (context, url,
                                                            error) =>
                                                        const Icon(Icons.error),
                                                  ),
                                                ),
                                              ),
                                              Flexible(
                                                  flex: 6,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Container(
                                                        margin: const EdgeInsets
                                                            .all(5),
                                                        child: Text(
                                                          CourseList[index]
                                                              .subject_name
                                                              .toString(),
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ),
                                                      Container(
                                                        margin: const EdgeInsets
                                                            .all(8),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Card(
                                                              color:
                                                                  Colors.green,
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            15.0),
                                                              ),
                                                              child: Container(
                                                                margin:
                                                                    const EdgeInsets
                                                                        .all(8),
                                                                child: Text(
                                                                    "RM " +
                                                                        double.parse(CourseList[index].subject_price.toString())
                                                                            .toStringAsFixed(
                                                                                2),
                                                                    style:
                                                                        const TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          15,
                                                                    )),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              width: 10,
                                                            ),
                                                            Card(
                                                              color:
                                                                  Colors.blue,
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            15.0),
                                                              ),
                                                              child: Container(
                                                                margin:
                                                                    const EdgeInsets
                                                                        .all(8),
                                                                child: Text(
                                                                    CourseList[index]
                                                                            .subject_sessions
                                                                            .toString() +
                                                                        " session",
                                                                    style:
                                                                        const TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          15,
                                                                    )),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          margin:
                                                              const EdgeInsets
                                                                      .fromLTRB(
                                                                  20, 5, 5, 5),
                                                          child: Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              const Icon(
                                                                  Icons.star,
                                                                  color: Colors
                                                                      .amber),
                                                              Text(
                                                                  CourseList[
                                                                          index]
                                                                      .subject_rating
                                                                      .toString(),
                                                                  style:
                                                                      const TextStyle(
                                                                    color: Colors
                                                                        .amber,
                                                                    fontSize:
                                                                        16,
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
                                  child: Center(
                                      child: Text(
                                          "Total Payment : " +
                                              totalPay.toString(),
                                          style:
                                              const TextStyle(fontSize: 20)))),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: ElevatedButton(
                                          onPressed: _payment,
                                          child: Text('Proceed to Pay'))),
                                  Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            primary: Colors.red, // background
                                            onPrimary:
                                                Colors.white, // foreground
                                          ),
                                          onPressed: () {
                                            _removeCart("-1");
                                          },
                                          child: Text("Remove From Cart"))),
                                ],
                              ),
                            ],
                          ),
                  ],
                )));
  }
}
