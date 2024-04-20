import 'package:app_finance/models/database_provider.dart';
import 'package:app_finance/widgets/all_expenses_screen/all_plans_fetcher.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AllPlans extends StatefulWidget {
  const AllPlans({super.key});
  static const name = '/all_plans';

  @override
  State<AllPlans> createState() => _AllExpensesState();
}

class _AllExpensesState extends State<AllPlans> {


  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DatabaseProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(

        actions: [IconButton(onPressed: (){
          provider.generatePlan();
        }, icon: Icon(Icons.add))],
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
          tooltip: 'Назад',
        ),
        title: const Text('Все Задачи',
            style: TextStyle(color: Color.fromARGB(255, 33, 27, 49))),
        backgroundColor: const Color.fromARGB(255, 236, 95, 70),
      ),
      body: const AllPlansFetcher(),
    );
  }
}
