import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:my_tutor/global.dart' as gb;

class PaymentScreen extends StatefulWidget {
  final num totalPay;
  const PaymentScreen({Key? key, required this.totalPay}) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  void initState() {
    super.initState();
    tester();
  }

  void tester() {
    print("asdasd");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Payment'),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: WebView(
                initialUrl: gb.ip +
                    'payment.php?email=' +
                    gb.globaUser.email.toString() +
                    '&mobile=' +
                    gb.globaUser.phone.toString() +
                    '&name=' +
                    gb.globaUser.name.toString() +
                    '&amount=' +
                    widget.totalPay.toString(),
                javascriptMode: JavascriptMode.unrestricted,
                onWebViewCreated: (WebViewController webViewController) {
                  _controller.complete(webViewController);
                },
              ),
            )
          ],
        ));
  }
}
