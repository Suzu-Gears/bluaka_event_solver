import 'package:bluaka_event_solver/importer.dart';

class BottomControlButtons extends StatelessWidget {
  final VoidCallback onSave;
  final VoidCallback onLoad;
  final VoidCallback onReset;
  final VoidCallback onCalc;

  const BottomControlButtons({
    Key? key,
    required this.onSave,
    required this.onLoad,
    required this.onReset,
    required this.onCalc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      color: Colors.blueGrey,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
            onPressed: onSave,
            child: Text('SAVE'),
          ),
          ElevatedButton(
            onPressed: onLoad,
            child: Text('LOAD'),
          ),
          ElevatedButton(
            onPressed: onReset,
            child: Text('RESET'),
          ),
          ElevatedButton(
            onPressed: onCalc,
            child: Text('計算実行'),
          ),
        ],
      ),
    );
  }
}
