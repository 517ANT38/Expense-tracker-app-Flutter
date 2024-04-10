import 'package:app_finance/models/basket_plan.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import './confirm_box.dart';

class PlanCard extends StatelessWidget {
  final BasketPlan bsp;
  const PlanCard(this.bsp, {super.key});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(bsp.id),
      direction: DismissDirection.none,
      // confirmDismiss: (_) async {
      //   showDialog(
      //     context: context,
      //     builder: (_) => ConfirmBox(bsp: bsp),
      //   );
      // },
      child: ListTile(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          // child: Icon(icons[bsp.category]),
        ),
        title: Text(bsp.title),
        subtitle: Text(
          bsp.isDone ? 'выполнен' : 'не выполнен',
          style: TextStyle(
            color: bsp.isDone ? Colors.green : Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Всего: ' + NumberFormat.currency(locale: 'ru_IN', symbol: '₽')
                .format(bsp.allMoney)),
            Text('Минимум на категорию: ' + NumberFormat.currency(locale: 'ru_IN', symbol: '₽').format(
                bsp.minMoneyCategory)),
          ],
        ),
      ),
    );
  }
}
