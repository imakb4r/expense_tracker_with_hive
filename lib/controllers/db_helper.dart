import 'package:hive/hive.dart';

class DbHelper {
  late Box box;

  DbHelper() {
    openBox();
  }

  openBox() {
    box = Hive.box('money');
  }

  Future? addData(int amount, String note, String type, DateTime date) {
    var value = {"amount": amount, 'date': date, 'type': type, 'note': note};
    box.add(value);
    return null;
  }

  Future<Map> fetch() {
    if (box.values.isEmpty) {
      return Future.value({});
    } else {
      return Future.value(box.toMap()
      );
    }
  }
}
