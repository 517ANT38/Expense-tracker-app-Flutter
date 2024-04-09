import 'package:flutter/material.dart';
import '../widgets/all_expenses_screen/all_expenses_fetcher.dart';

class AllExpenses extends StatefulWidget {
  const AllExpenses({super.key});
  static const name = '/all_expenses';

  @override
  State<AllExpenses> createState() => _AllExpensesState();
}

class _AllExpensesState extends State<AllExpenses> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
          tooltip: 'Назад',
        ),
        title: const Text('Все расходы',style: TextStyle(color: Color.fromARGB(255, 93, 3, 109))),
        backgroundColor: const Color.fromARGB(255, 80, 239, 128),
      ),
      body: const AllExpensesFetcher(),
    );
  }
}
