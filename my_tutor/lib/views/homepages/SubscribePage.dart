import 'package:flutter/material.dart';

class SubscribePage extends StatefulWidget {
  SubscribePage({Key? key}) : super(key: key);

  @override
  State<SubscribePage> createState() => _SubscribePageState();
}

class _SubscribePageState extends State<SubscribePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text('Subscribe'),
            centerTitle: true,
            automaticallyImplyLeading: false),
        body: Text(''));
  }
}
