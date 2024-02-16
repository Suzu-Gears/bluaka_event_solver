import 'package:bluaka_event_solver/importer.dart';

String textKey = 'TextKey';

Future<void> saveText(String text) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString(textKey, text);
}

Future<String?> loadText() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString(textKey);
}

Future<void> removeText() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove(textKey);
}
