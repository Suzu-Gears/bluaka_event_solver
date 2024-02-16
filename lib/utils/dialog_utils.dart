import 'package:bluaka_event_solver/importer.dart';

void showCustomDialog(
    BuildContext context, String title, String content) async {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: SelectableText(content),
        actions: <Widget>[
          ElevatedButton(
            child: Text('閉じる'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
