import 'package:bluaka_event_solver/importer.dart';

String converControllerGridToString(
    List<List<TextEditingController>> controllersGrid) {
  String rowToString(List<TextEditingController> row) {
    String texts = row.map((controller) => '"${controller.text}"').join(', ');
    return '[$texts]';
  }

  String result = controllersGrid.map(rowToString).join(', ');

  return '[$result]';
}

List<List<String>> parseStringToListOfLists(String jsonString) {
  // JSONをデコードしてオブジェクトに変換
  List<dynamic> decoded = json.decode(jsonString);

  // List<dynamic>からList<List<String>>にキャスト
  List<List<String>> gridText = decoded
      .map<List<String>>((dynamic row) => List<String>.from(row))
      .toList();

  return gridText;
}
