import 'dart:math';

import 'package:app_finance/models/basket_plan.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../constants/icons.dart';
import './ex_category.dart';
import './expense.dart';

class DatabaseProvider with ChangeNotifier {
  String _searchText = '';
  String get searchText => _searchText;
  set searchText(String value) {
    _searchText = value;
    notifyListeners();
  }
  
  List<BasketPlan> _plans = [];
  List<BasketPlan> get plans {return _searchText != ''
        ? _plans
            .where((e) =>
                e.id == int.tryParse(_searchText.split('').last))
            .toList()
        : _plans;
  }

  List<ExpenseCategory> _categories = [];
  List<ExpenseCategory> get categories => _categories;

  List<Expense> _expenses = [];
  List<Expense> get expenses {
    return _searchText != ''
        ? _expenses
            .where((e) =>
                e.title.toLowerCase().contains(_searchText.toLowerCase()))
            .toList()
        : _expenses;
  }

  Database? _database;
  
  Future<Database> get database async {
    final dbDirectory = await getApplicationDocumentsDirectory();
    const dbName = 'expense_tc.db';
    final path = join(dbDirectory.path, dbName);

    if (await databaseExists(path)) {
      _database = await openDatabase(path);
      return _database!;
    }

    _database = await openDatabase(
      path,
      version: 1,
      onCreate: _createDb, 
    );

    return _database!;
  }

  
  static const cTable = 'categoryTable';
  static const eTable = 'expenseTable';
  static const pTable = 'planTable';
  
  
  Future<void> _createDb(Database db, int version) async {
   

    await db.transaction((txn) async {
    
     

      await txn.execute('''CREATE TABLE $cTable(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        entries INTEGER,
        totalAmount TEXT
      )''');
      
      await txn.execute('''CREATE TABLE $eTable(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        amount TEXT,
        date TEXT,
        category TEXT
      )''');

      await txn.execute('''CREATE TABLE $pTable(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        allMoney TEXT,
        science TEXT,
        car TEXT,
        food TEXT,
        palette TEXT,
        headphones TEXT,
        localActivity TEXT,
        isDone TEXT
      )''');

     for (int i = 0; i < icons.length; i++) {
        await txn.insert(cTable, {
          'title': icons.keys.toList()[i],
          'entries': 0,
          'totalAmount': (0.0).toString(),
        });
      }

    });
  }

  Future<List<BasketPlan>> fetchBasketPlans() async {
    final db = await database;
    return await db.transaction((txn) async {
      return await txn.query(pTable).then((data) {
        final converted = List<Map<String, dynamic>>.from(data);

        List<BasketPlan> nList = List.generate(converted.length,
            (index) => BasketPlan.fromString(converted[index]));

        _plans = nList;
        return _plans;
      });
    });
  }

  Future<List<ExpenseCategory>> fetchCategories() async {
    
    final db = await database;
    return await db.transaction((txn) async {
      return await txn.query(cTable).then((data) {
        final converted = List<Map<String, dynamic>>.from(data);
        
        List<ExpenseCategory> nList = List.generate(converted.length,
            (index) => ExpenseCategory.fromString(converted[index]));
       
        _categories = nList;
        return _categories;
      });
    });
  }

  Future<void> updateCategory(
    String category,
    int nEntries,
    double nTotalAmount,
  ) async {
    final db = await database;
    await db.transaction((txn) async {
      await txn
          .update(
        cTable, 
        {
          'entries': nEntries, 
          'totalAmount': nTotalAmount.toString(), 
        },
        where: 'title == ?',
        whereArgs: [category], 
      )
          .then((_) {
        var file =
            _categories.firstWhere((element) => element.title == category);
        file.entries = nEntries;
        file.totalAmount = nTotalAmount;
        notifyListeners();
      });
    });
  }

  List<int> genRandomListProcent(){
    var random = Random();
    var numbers = List<int>.generate(6, (index) => random.nextInt(100));

    
    while (numbers.reduce((a, b) => a + b) != 100) {
      numbers = List<int>.generate(6, (index) => random.nextInt(100));
    }

    return numbers;
  }


  Future<void> generatePlan() async {
    final sum = Random().nextInt(10000)+20000.0;
    final nums = genRandomListProcent();
    var  p = BasketPlan(
      id: 0,
      allMoney: sum, 
      car: nums[0],
      food: nums[1],
      palette: nums[3],
      science: nums[4],
      localActivity: nums[5],
      headphones:  nums[2],
      isDone: false
      );
    await addPlan(p);

  }

  Future<void> addPlan(BasketPlan bsp) async {
    final db = await database;
    await db.transaction((txn) async {
       

      await txn
          .insert(
        pTable,
        bsp.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      )
          .then((generatedId) {
        final file = BasketPlan(
            id: generatedId,
            allMoney: bsp.allMoney,
            science : bsp.science,
            car: bsp.car,
            food: bsp.food,
            palette: bsp.palette,
            headphones: bsp.headphones,
            localActivity: bsp.localActivity,
            isDone: bsp.isDone);

        _plans.add(file);
        notifyListeners();
      });
    });
  }

  Future<bool> addExpense(Expense exp) async {
    final db = await database;
    bool win = false;

    await db.transaction((txn) async {
      await txn
          .insert(
        eTable,
        exp.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      )
          .then((generatedId){
        final file = Expense(
            id: generatedId,
            title: exp.title,
            amount: exp.amount,
            date: exp.date,
            category: exp.category);

        _expenses.add(file);
        notifyListeners();
        var ex = findCategory(exp.category);

        updateCategory(
            exp.category, ex.entries + 1, ex.totalAmount + exp.amount);
      });
    });
     
    await db.transaction((txn) async {
      
      
      if (_plans.length != 0) {
        var total = calculateTotalExpenses();
        print(total);
        if(_expenses.indexOf(exp) == -1){
          total += exp.amount;
        }
        
        BasketPlan? res = null; 
        var fl = true;
        for(var p in _plans){
          fl=true;
          var m = p.toMap();
          for (final category in _categories) {
            var p_my = ((category.totalAmount/total)*100).toInt();
           
            var c_p = int.parse(m[trans[category.title]]);
            if ((p_my - c_p).abs() > 1) {                       
                fl = false;
                break;
            }
          }


          if(fl){
            res = p;
          }
        }

        if (res != null) {
          
          res.isDone = true;
          await txn.update(
            pTable,
            res.toMap(),
            where: 'id = ?',
            whereArgs: [res.id],
          );
          win = true;

          
          await txn.delete(eTable);

          for (final category in _categories) {
            updateCategory(category.title, 0, 0);
          }
          notifyListeners();
        }}});
        return win;
  }

  Future<void> deleteExpense(int expId, String category, double amount) async {
    final db = await database;
    await db.transaction((txn) async {
      await txn.delete(eTable, where: 'id == ?', whereArgs: [expId]).then((_) {
        _expenses.removeWhere((element) => element.id == expId);
        notifyListeners();

        var ex = findCategory(category);
        updateCategory(category, ex.entries - 1, ex.totalAmount - amount);
      });
    });
  }

  Future<List<Expense>> fetchExpenses(String category) async {
    final db = await database;
    return await db.transaction((txn) async {
      return await txn.query(eTable,
          where: 'category == ?', whereArgs: [category]).then((data) {
        final converted = List<Map<String, dynamic>>.from(data);
        List<Expense> nList = List.generate(
            converted.length, (index) => Expense.fromString(converted[index]));
        _expenses = nList;
        return _expenses;
      });
    });
  }

  Future<List<Expense>> fetchAllExpenses() async {
    final db = await database;
    return await db.transaction((txn) async {
      return await txn.query(eTable).then((data) {
        final converted = List<Map<String, dynamic>>.from(data);
        List<Expense> nList = List.generate(
            converted.length, (index) => Expense.fromString(converted[index]));
        _expenses = nList;
        return _expenses;
      });
    });
  }

  ExpenseCategory findCategory(String title) {
    return _categories.firstWhere((element) => element.title == title);
  }

  Map<String, dynamic> calculateEntriesAndAmount(String category) {
    double total = 0.0;
    var list = _expenses.where((element) => element.category == category);
    for (final i in list) {
      total += i.amount;
    }
    return {'entries': list.length, 'totalAmount': total};
  }

  double calculateTotalExpenses() {
    return _categories.fold(
        0.0, (previousValue, element) => previousValue + element.totalAmount);
  }

  List<Map<String, dynamic>> calculateWeekExpenses() {
    List<Map<String, dynamic>> data = [];

    for (int i = 0; i < 7; i++) {
      double total = 0.0;
      final weekDay = DateTime.now().subtract(Duration(days: i));

      for (int j = 0; j < _expenses.length; j++) {
        if (_expenses[j].date.year == weekDay.year &&
            _expenses[j].date.month == weekDay.month &&
            _expenses[j].date.day == weekDay.day) {
          total += _expenses[j].amount;
        }
      }

      data.add({'day': weekDay, 'amount': total});
    }
    return data;
  }
}