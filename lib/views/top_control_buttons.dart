import 'package:bluaka_event_solver/importer.dart';

class TopControlButtons extends StatelessWidget {
  final VoidCallback onAddRow;
  final VoidCallback? onRemoveRow;
  final VoidCallback onAddColumn;
  final VoidCallback? onRemoveColumn;

  const TopControlButtons({
    Key? key,
    required this.onAddRow,
    required this.onRemoveRow,
    required this.onAddColumn,
    required this.onRemoveColumn,
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
            onPressed: onAddRow,
            child: Text('行を追加'),
          ),
          ElevatedButton(
            onPressed: onRemoveRow,
            child: Text('行を削除'),
          ),
          ElevatedButton(
            onPressed: onAddColumn,
            child: Text('列を追加'),
          ),
          ElevatedButton(
            onPressed: onRemoveColumn,
            child: Text('列を削除'),
          ),
        ],
      ),
    );
  }
}
