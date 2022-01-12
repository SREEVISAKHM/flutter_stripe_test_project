// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

class StripePaymentView extends StatefulWidget {
  const StripePaymentView({Key? key}) : super(key: key);

  @override
  _StripePaymentViewState createState() => _StripePaymentViewState();
}

class _StripePaymentViewState extends State<StripePaymentView> {
  Map<String, dynamic>? paymentIntentData;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stripe Payment'),
      ),
      body: Container(
        color: Colors.white,
        child: Center(
          child: InkWell(
            onTap: () async {
              await makePayment();
            },
            child: Container(
              height: 20,
              width: 100,
              color: Colors.amber,
              child: const Center(
                child: Text('Stripe Payment'),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> makePayment() async {
    try {
      paymentIntentData = await createPaymentIntent('30', 'INR');

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntentData!['client_secret'],
          applePay: true,
          googlePay: true,
          merchantCountryCode: 'INR',
          style: ThemeMode.light,
          merchantDisplayName: 'Sreevisakh',
        ),
      );

      displayPaymentSheet();
    } catch (e) {
      print(e);
    }
  }

  displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet();
      setState(() {
        paymentIntentData = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Payment Successful'),
        ),
      );
      print('compleateeee');
    } on StripeException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }

  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': calculatedAmount(amount),
        'currency': currency,
        'payment_method_types[]': 'card',
      };
      var response = await http.post(
          Uri.parse('https://api.stripe.com/v1/payment_intents'),
          headers: {
            'Authorization':
                'Bearer sk_test_51KEUGqSByJQEX31QfQOn4Qb3lNoqhbdyLrMYVm1p6PUXlOo9sHEvFdy6AFwKrBAXofLyfL9fb3GtuZCALSr4ds0T00E8QRPBcN',
            'Content-Type': 'application/x-www-form-urlencoded',
          },
          body: body);
      return json.decode(response.body.toString());
    } catch (e) {
      print(e);
    }
  }

  calculatedAmount(String amount) {
    final price = int.parse(amount) * 100;
    return price.toString();
  }
}
