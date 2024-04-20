import 'package:app_finance/widgets/all_expenses_screen/all_plans_list.dart';
import 'package:app_finance/widgets/all_expenses_screen/plan_search.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/database_provider.dart';

class AllPlansFetcher extends StatefulWidget {
  const AllPlansFetcher({super.key});

  @override
  State<AllPlansFetcher> createState() => _AllPlansFetcherState();
}

class _AllPlansFetcherState extends State<AllPlansFetcher> {
  late Future _allPlansList;

  Future _getAllPlans() async {
    final provider = Provider.of<DatabaseProvider>(context, listen: false);
    return await provider.fetchBasketPlans();
  }

  @override
  void initState() {
    super.initState();
    _allPlansList = _getAllPlans();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _allPlansList,
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          } else {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: const [
                  PlanSearch(),
                  Expanded(child: AllPlansList()),
                ],
              ),
            );
          }
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
