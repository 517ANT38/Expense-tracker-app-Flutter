import 'package:app_finance/widgets/expense_screen/plan_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/database_provider.dart';

class AllPlansList extends StatelessWidget {
  const AllPlansList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DatabaseProvider>(
      builder: (_, db, __) {
        var list = db.plans;
        return list.isNotEmpty
            ? ListView.builder(
                physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                itemCount: list.length,
                itemBuilder: (_, i) => PlanCard(list[i]),
              )
            : const Center(
                child: Text('Записи не найдены'),
              );
      },
    );
  }
}
