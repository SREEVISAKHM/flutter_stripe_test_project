import 'package:flutter/material.dart';
import 'package:stripe_payment/screens/stripe_payment_view.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey =
      'pk_test_51KEUGqSByJQEX31Q0HRZ1H3n5bBusuOy2AbbtW3OCbVY70rUld0GnycaHGBVLK5zKTg3c9vQKoVGdRcRXp2atVJI00136A07T3';
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const StripePaymentView(),
    );
  }
}
