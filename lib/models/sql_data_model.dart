class SqlDataModel {
  final int id;
  final String name;
  final String price;

  SqlDataModel({
    required this.id,
    required this.name,
    required this.price,
  });

  factory SqlDataModel.fromSqfliteDatabase(Map<String, dynamic> map) =>
      SqlDataModel(
        id: map['id']?.toInt() ?? 0,
        name: map['name'] ?? '',
        price: map['price'] ?? '',
      );
}
