import 'package:flutter/material.dart';

class CashbookScreen extends StatelessWidget {
  const CashbookScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Cashbook Screen',
          style: TextStyle(fontSize: 22),
        ),
      ),
    );
  }
}