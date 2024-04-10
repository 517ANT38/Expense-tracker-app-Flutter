import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/database_provider.dart';

class PlanSearch extends StatefulWidget {
  const PlanSearch({super.key});

  @override
  State<PlanSearch> createState() => _PlanSearchState();
}

class _PlanSearchState extends State<PlanSearch> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DatabaseProvider>(context, listen: false);
    return TextField(
      onChanged: (value) {
        provider.searchText = value;
      },
      decoration: const InputDecoration(
        labelText: 'Поиск задач',
      ),
    );
  }
}
