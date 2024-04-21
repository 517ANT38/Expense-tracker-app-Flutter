import 'package:app_finance/models/basket_plan.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PlanCard extends StatelessWidget {
  final BasketPlan bsp;
  const PlanCard(this.bsp, {super.key});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(bsp.id),
      direction: DismissDirection.none,
     
      child: Column(
        children:[ Padding(
          padding: const EdgeInsets.all(8.0),
        ),
        Text("Задача ${bsp.id}"),
        Text(
          bsp.isDone ? 'выполнен' : 'не выполнен',
          style: TextStyle(
            color: bsp.isDone ? Colors.green : Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          child: Column(
        
          
          children: [

            Text('Требуется распределить сумму денег: на учебу ${bsp.science}%, '+
            'на транспорт ${bsp.car}%, на еду и напитки ${bsp.food}%, на хобби ${bsp.palette}%,'
             'на равлечения ${bsp.headphones}%, и на прочее ${bsp.localActivity}%'),

            Text('Сумма для задания: ' + NumberFormat.currency(locale: 'ru_IN', symbol: '₽')
                .format(bsp.allMoney)),
            
          ],
        ),
      )]),
    );
  }
}
