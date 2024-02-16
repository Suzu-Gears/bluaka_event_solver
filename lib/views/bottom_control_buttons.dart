import 'package:bluaka_event_solver/importer.dart';

class BottomControlButtons extends StatelessWidget {
  final VoidCallback onRemoveText;
  final VoidCallback onSave;
  final VoidCallback onLoad;
  final VoidCallback onDisplayArray;
  final VoidCallback onReset;

  const BottomControlButtons({
    Key? key,
    required this.onRemoveText,
    required this.onSave,
    required this.onLoad,
    required this.onDisplayArray,
    required this.onReset,
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
            onPressed: onRemoveText,
            child: Text('REMOVE'),
          ),
          ElevatedButton(
            onPressed: onSave,
            child: Text('SAVE'),
          ),
          ElevatedButton(
            onPressed: onLoad,
            child: Text('LOAD'),
          ),
          ElevatedButton(
            onPressed: onDisplayArray,
            child: Text('配列表示'),
          ),
          ElevatedButton(
            onPressed: onReset,
            child: Text('RESET'),
          ),
        ],
      ),
    );
  }
}
