import 'package:flutter/material.dart';

class PayOnline extends StatelessWidget {

  final Function() payAction;

  const PayOnline({Key? key , required this.payAction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
          onPressed: payAction,
          child: const Text("Pay")
      ),
    );
  }
}
