import 'package:app_finance/widgets/all_expenses_screen/all_plans_fetcher.dart';
import 'package:flutter/material.dart';

class AllPlans extends StatefulWidget {
  const AllPlans({super.key});
  static const name = '/all_plans';

  @override
  State<AllPlans> createState() => _AllExpensesState();
}

class _AllExpensesState extends State<AllPlans> {
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
        title: const Text('Все Задачи',
            style: TextStyle(color: Color.fromARGB(255, 93, 3, 109))),
        backgroundColor: const Color.fromARGB(255, 80, 239, 128),
      ),
      body: const AllPlansFetcher(),
    );
  }
}
