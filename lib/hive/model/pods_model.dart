import 'package:hive_flutter/hive_flutter.dart';

part 'pods_model.g.dart';

@HiveType(typeId: 1)
class PodsModel {
  @HiveField(0)
  String nameOfTheProps;
  @HiveField(1)
  String status;
  @HiveField(2)
  String quantity;
  @HiveField(3)
  String description;
  PodsModel({
    required this.nameOfTheProps,
    required this.status,
    required this.quantity,
    this.description = "",
  });
}
