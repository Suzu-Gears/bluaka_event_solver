import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: Scaffold(
        appBar: AppBar(
          title: Text('動的なレイアウトデモ'),
        ),
        body: DynamicLayoutScreen(),
      ),
    );
  }
}

class DynamicLayoutScreen extends StatefulWidget {
  @override
  _DynamicLayoutScreenState createState() => _DynamicLayoutScreenState();
}

class _DynamicLayoutScreenState extends State<DynamicLayoutScreen> {
  // テキストフィールドのリストを管理するための二次配列
  List<List<TextField>> textFieldGrid = [];
  // テキストフィールドのコントローラーの二次配列
  List<List<TextEditingController>> controllersGrid = [];

  @override
  void dispose() {
    // コントローラーのリソースを解放
    for (var row in controllersGrid) {
      for (var controller in row) {
        controller.dispose();
      }
    }
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // 行列の初期化
    initializeGrid();
  }

  void initializeGrid() {
    // 初期状態で4行3列のテキストフィールドを追加
    addRow();
    addRow();
    addRow();
    addRow();
    addColumn();
    addColumn();
    addColumn();
  }

  void addRow() {
    setState(() {
      int numberOfColumns =
          controllersGrid.isEmpty ? 1 : controllersGrid.first.length;
      List<TextField> newRow = [];
      List<TextEditingController> newControllersRow = [];
      for (int i = 0; i < numberOfColumns; i++) {
        TextEditingController newController = TextEditingController();
        newControllersRow.add(newController);
        newRow.add(createTextField(newController));
      }
      textFieldGrid.add(newRow);
      controllersGrid.add(newControllersRow);
    });
  }

  void addColumn() {
    setState(() {
      for (int i = 0; i < textFieldGrid.length; i++) {
        TextEditingController newController = TextEditingController();
        controllersGrid[i].add(newController);
        textFieldGrid[i].add(createTextField(newController));
      }
    });
  }

  void removeRow() {
    // 残り1行は削除しない
    if (textFieldGrid.length > 1) {
      setState(() {
        textFieldGrid.removeLast();
        controllersGrid.removeLast();
      });
    }
  }

  void removeColumn() {
    // 各行の残り3列は削除しない
    if (textFieldGrid.first.length > 3) {
      setState(() {
        for (var row in textFieldGrid) {
          row.removeLast();
        }
        for (var rowControllers in controllersGrid) {
          rowControllers.removeLast();
        }
      });
    }
  }

  void createGrid(List<List<String>> gridText) {
    removeGrid();
    for (List<String> rowText in gridText) {
      List<TextField> newRow = [];
      List<TextEditingController> newControllersRow = [];
      for (String cellText in rowText) {
        TextEditingController newController =
            TextEditingController(text: cellText);
        newControllersRow.add(newController);
        newRow.add(createTextField(newController));
      }
      textFieldGrid.add(newRow);
      controllersGrid.add(newControllersRow);
    }
  }

  void resetGrid() {
    removeGrid();
    initializeGrid();
  }

  void removeGrid() {
    setState(() {
      textFieldGrid.clear();
      controllersGrid.clear();
    });
  }

  TextField createTextField(TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        hintText: '入力してください',
      ),
    );
  }

  void showGridAsText() {
    // テキスト形式で二次配列をダイアログに表示
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('配列の内容'),
          content: SelectableText('[${controllersGrid.map((row) {
            return '[${row.map((controller) => controller.text).join(', ')}]';
          }).join(',')}]'),
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

  void createGridTrigger() {
    createGrid([
      ['Stage8', '0', '0', '0', '0', '0'],
      ['Stage9', '1', '1', '1', '1', '1'],
      ['Stage10', '2', '2', '2', '2', '2'],
      ['Stage11', '3', '3', '3', '3', '3'],
      ['Stage12', '4', '4', '4', '4', '4']
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              color: Colors.blueGrey,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: addRow,
                    child: Text('行を追加'),
                  ),
                  ElevatedButton(
                    onPressed: textFieldGrid.length > 1
                        ? removeRow
                        : null, //行が1つのみの場合は削除ボタンを非活性化
                    child: Text('行を削除'),
                  ),
                  ElevatedButton(
                    onPressed: addColumn,
                    child: Text('列を追加'),
                  ),
                  ElevatedButton(
                    onPressed: textFieldGrid.first.length > 3
                        ? removeColumn
                        : null, //列が1つのみの場合は削除ボタンを非活性化
                    child: Text('列を削除'),
                  ),
                ],
              ),
            ),
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  children: textFieldGrid.map((List<TextField> row) {
                    return Row(
                      children: row
                          .map((textField) => Expanded(child: textField))
                          .toList(),
                    );
                  }).toList(),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              color: Colors.blueGrey,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: showGridAsText,
                    child: Text('配列表示'),
                  ),
                  ElevatedButton(
                    onPressed: resetGrid,
                    child: Text('配列リセット'),
                  ),
                  ElevatedButton(
                    onPressed: createGridTrigger,
                    child: Text('配列作成'),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
