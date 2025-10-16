import 'dart:io';
import 'package:excel/excel.dart' as excell;
import 'package:hive/hive.dart';
class Variables {
  String url = "http://localhost";
  readExcell(path2) async {
    var bytes = File(path2).readAsBytesSync();
    var excel = excell.Excel.decodeBytes(bytes);
    Map<String, bool> numbers = {};
    for (var table in excel.tables.keys) {
      for (var row in excel.tables[table]!.rows) {
        for (var cell in row.map((e) => e).toList()) {
          try {
            if (int.tryParse(cell!.value
                    .toString()
                    .replaceAll("+", "")
                    .replaceAll(" ", "")) !=
                null) {
              String number = cell.value.toString().replaceAll(" ", "");
              // print(number[0]);
              if (number[0] == "+") {
                numbers.addAll({
                  "2${cell.value.toString().replaceAll("+2", "").replaceAll(" ", "")}":
                      false
                });
              } else if (number[0] == "0") {
                numbers.addAll({
                  "2${cell.value.toString().replaceAll("+2", "").replaceAll(" ", "")}":
                      false
                });
              } else if (number[0] == "2") {
                numbers
                    .addAll({cell.value.toString().replaceAll(" ", ""): false});
              } else if (number[0] == "1") {
                numbers.addAll({
                  "20${cell.value.toString().replaceAll("+2", "").replaceAll(" ", "")}":
                      false
                });
              } else {
                print("phone format is wrong");
              }
            } else {
              print("Number error");
            }
          } catch (e) {
            
          }
        }
      }
    }
    return numbers;
  }
  Box templates = Hive.box("templates");
}
