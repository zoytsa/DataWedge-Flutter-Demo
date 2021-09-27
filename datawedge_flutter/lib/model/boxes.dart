import 'package:datawedgeflutter/model/settings.dart';
import 'package:hive/hive.dart';

class Boxes {
  static Box<Settings> getSettings() => Hive.box<Settings>('settings');
}
