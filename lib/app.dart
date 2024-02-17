import 'package:bluaka_event_solver/importer.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ブルアカイベント周回ソルバー',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('ブルアカイベント周回ソルバー'),
        ),
        body: DynamicLayoutGrid(),
      ),
    );
  }
}
