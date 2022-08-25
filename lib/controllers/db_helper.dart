import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DbHelper {
  late Box box;
  late SharedPreferences preferences;

  DbHelper() {
    openBox();
  }

  openBox() {
    box = Hive.box('money');
  }

  Future deleteData(int index) async {
    await box.delete(index);
  }

  Future? addData(int amount, String note, String type, DateTime date) {
    var value = {"amount": amount, 'date': date, 'type': type, 'note': note};
    box.add(value);
    return null;
  }

  addName(String name) async {
    preferences = await SharedPreferences.getInstance();
    preferences.setString("Name", name);
  }

  getName() async {
    preferences = await SharedPreferences.getInstance();
    return preferences.getString('Name');
  }
}
