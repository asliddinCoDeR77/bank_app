import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_bank/data/models/cart_model.dart';
import 'package:online_bank/logic/blocs/cart_bloc.dart';

class CardInfoDialog extends StatefulWidget {
  const CardInfoDialog({super.key});

  @override
  State<CardInfoDialog> createState() => _CardInfoDialogState();
}

class _CardInfoDialogState extends State<CardInfoDialog> {
  final _formKey = GlobalKey<FormState>();

  String? cardName;

  String? cardNumber;

  String? expiryDate;

  String? cardBalance;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Enter Card Information'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(labelText: 'Card Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the card name';
                  }
                  return null;
                },
                onSaved: (value) => cardName = value,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Card Number'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the card number';
                  }
                  if (value.length != 19) {
                    return 'Card number must be 16 digits';
                  }
                  return null;
                },
                onSaved: (value) => cardNumber = value,
              ),
              TextFormField(
                decoration:
                    const InputDecoration(labelText: 'Expiry Date (MM/YY)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the expiry date';
                  }
                  final regex = RegExp(r'^(0[1-9]|1[0-2])\/?([0-9]{2})$');
                  if (!regex.hasMatch(value)) {
                    return 'Enter a valid expiry date';
                  }
                  return null;
                },
                onSaved: (value) => expiryDate = value,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Card Balance'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the card balance';
                  }
                  try {
                    final balance = double.parse(value);
                    if (balance < 0) {
                      return 'Balance cannot be negative';
                    }
                  } catch (e) {
                    return 'Enter a valid number';
                  }
                  return null;
                },
                onSaved: (value) => cardBalance = value,
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('Submit'),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              context.read<CartBloc>().add(
                    AddCartEvent(
                      carts: CartModel(
                        id: FirebaseAuth.instance.currentUser!.uid,
                        cartName: cardName!,
                        cartNumber: cardNumber!,
                        axpiryDate: expiryDate!,
                        balance: cardBalance!,
                      ),
                    ),
                  );
              print("++++++++++++++++++++++++++++++");
              print('Card Name: $cardName');
              print('Card Number: $cardNumber');
              print('Expiry Date: $expiryDate');
              print('Card Balance: $cardBalance');
              print("++++++++++++++++++++++++++++++");

              Navigator.of(context).pop();
            }
          },
        ),
      ],
    );
  }
}
