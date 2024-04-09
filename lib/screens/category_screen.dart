import 'package:flutter/material.dart';
import '../widgets/category_screen/category_fetcher.dart';
import '../widgets/expense_form.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});
  static const name = '/category_screen'; 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
        title: const Text('Категории',style: TextStyle(color: Color.fromARGB(255, 93, 3, 109)),),
        backgroundColor: const Color.fromARGB(255, 80, 239, 128),
      ),
      body: const CategoryFetcher(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (_) => const ExpenseForm(),
          );
        },
        backgroundColor: const Color.fromARGB(255, 80, 239, 128),
        child: const Icon(Icons.add,color: Color.fromARGB(255, 93, 3, 109),),
      ),
    );
  }
}
