class BasketPlan {
  final int id;
  final String title;
  final double allMoney;
  final double minMoneyCategory;
  bool isDone;

  BasketPlan({
    required this.id,
    required this.title,
    required this.allMoney,
    required this.minMoneyCategory,
    required this.isDone,
  });

  Map<String, dynamic> toMap() => {
        'title': title,
        'allMoney': allMoney.toString(),
        'minMoneyCategory': minMoneyCategory.toString(),
        'isDone': isDone.toString(),
      };

  factory BasketPlan.fromString(Map<String, dynamic> value) => BasketPlan(
      id: value['id'],
      title: value['title'],
      allMoney: double.parse(value['allMoney']),
      minMoneyCategory: double.parse(value['minMoneyCategory']),
      isDone: bool.parse(value['isDone']));
}
