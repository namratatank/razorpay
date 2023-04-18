import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    print('Payment success: ${response.paymentId}');
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Payment success: ${response.paymentId}')));
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print('Payment error: ${response.code} - ${response.message}');
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Payment success: ${response.code}')));
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print('External wallet selected: ${response.walletName}');
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Payment success: ${response.walletName}')));
  }

  void _makePayment() async {
    var options = {
      'key': 'rzp_test_1DP5mmOlF5G5ag',
      'amount': 2000,
      'name': 'Test Payment',
      'description': 'Test Payment Description',
      'prefill': {'contact': '9999999999', 'email': 'test@razorpay.com'},
      'external': {
        'wallets': ['paytm', 'freecharge', 'mobikwik']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Razorpay Demo'),
      ),
      body: Center(
        child: ElevatedButton(
          child: const Text('Pay Now'),
          onPressed: () {
            _makePayment();
          },
        ),
      ),
    );
  }
}

