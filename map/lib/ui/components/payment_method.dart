import 'package:flutter/material.dart';
import 'package:map/business_logic/payment_methods.dart';

class PaymentMethod extends StatelessWidget {

  final Function(PaymentMethods) selectPaymentMethod;
  final PaymentMethods? selectedPayment;
  final Function() nextButtonAction;

  const PaymentMethod({Key? key , required this.selectedPayment , required this.nextButtonAction , required this.selectPaymentMethod}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            children: [
              ListTile(
                onTap: (){
                  selectPaymentMethod(PaymentMethods.creditCard);
                },
                title: const Text("Pay with credit card"),
                leading: const Icon(Icons.credit_card),
                selected: selectedPayment == PaymentMethods.creditCard,
              ),
              ListTile(
                onTap: (){
                  selectPaymentMethod(PaymentMethods.cash);
                },
                title: const Text("Pay cash"),
                leading: const Icon(Icons.credit_card),
                selected: selectedPayment == PaymentMethods.cash,
              ),
            ],
          ),
        ),
        ElevatedButton(
            onPressed: (){
              nextButtonAction();
            },
            child: const Text("Next")
        )
      ],
    );
  }
}
