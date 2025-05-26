import 'package:hive_flutter/hive_flutter.dart';

part 'rehearsal_model.g.dart';

@HiveType(typeId: 2)
class RehearsalModel {
  @HiveField(0)
  String nameOfThePerformance;
  @HiveField(1)
  DateTime date;
  @HiveField(2)
  String time;
  @HiveField(3)
  String chooseHall;
  @HiveField(4)
  List<String> listMembers;
  @HiveField(5)
  String desription;
  RehearsalModel({
    required this.nameOfThePerformance,
    required this.date,
    required this.time,
    required this.chooseHall,
    required this.listMembers,
    this.desription = "",
  });
}
