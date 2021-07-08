import 'package:hive/hive.dart';

part 'settings.g.dart';

@HiveType(typeId: 0)
class Settings extends HiveObject {
  @HiveField(0)
  late String name = "";

  @HiveField(1)
  late dynamic value = "";

  @HiveField(2)
  late bool valueBool = false;

  @HiveField(3)
  late double valueDouble = 0.0;

  @HiveField(4)
  late String valueString = "";

  @HiveField(5)
  late DateTime valueDate = DateTime.now();

  Settings(this.name, this.value);
}
