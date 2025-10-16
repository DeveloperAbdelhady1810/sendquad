import 'package:hive/hive.dart';
part 'template.g.dart';
@HiveType(typeId: 1)
class Template {
  @HiveField(0)
  String name;
  @HiveField(1)
  List numbers;
  @HiveField(2)
  String descrption;
  Template({
    required this.descrption,
    required this.name,
    required this.numbers
  });
}