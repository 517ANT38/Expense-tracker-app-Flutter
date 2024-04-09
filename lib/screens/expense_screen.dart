import 'package:flutter/material.dart';
import '../widgets/expense_screen/expense_fetcher.dart';

class ExpenseScreen extends StatelessWidget {
  const ExpenseScreen({super.key});
  static const name = '/expense_screen';
  @override
  Widget build(BuildContext context) {
    final category = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
          tooltip: 'Назад',
        ),
        title: const Text('Расход по категории',style: TextStyle(color: Color.fromARGB(255, 93, 3, 109))),
        backgroundColor: const Color.fromARGB(255, 80, 239, 128),
      ),
      body: ExpenseFetcher(category),
    );
  }
}
