class BasketPlan {
  final int id;
  final double allMoney;
  final int  science;
  final int car;
  final int food;
  final int palette;
  final int headphones;
  final int localActivity;

  bool isDone;

  BasketPlan({
    required this.id,
    required this.allMoney,
    required this.science,
    required this.car,
    required this.food,
    required this.palette,
    required this.headphones,
    required this.localActivity,
    required this.isDone,
    
  });

  Map<String, dynamic> toMap() => {
        'allMoney': allMoney.toString(),
        'science': science.toString(),
        'car': car.toString(),
        'food': food.toString(),
        'palette': palette.toString(),
        'headphones': headphones.toString(),
        'localActivity': localActivity.toString(),
        'isDone': isDone.toString(),
      };

  factory BasketPlan.fromString(Map<String, dynamic> value) => BasketPlan(
      id: value['id'],
      allMoney: double.parse(value['allMoney']),
      science: int.parse(value['science']),
      car: int.parse(value['car']),
      food: int.parse(value['food']),
      palette: int.parse(value['palette']),
      headphones: int.parse(value['headphones']),
      localActivity: int.parse(value['localActivity']),
      isDone: bool.parse(value['isDone']));
}
