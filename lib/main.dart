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

  @override
  void initState() {
    super.initState();
    // 行列の初期化
    initializeGrid();
  }

  void initializeGrid() {
    // 初期状態で1行1列のテキストフィールドを追加
    addRow();
  }

  void addRow() {
    // 新しい行を追加し、現在の列の数だけテキストフィールドを追加する
    setState(() {
      int numberOfColumns =
          textFieldGrid.isEmpty ? 1 : textFieldGrid.first.length;
      List<TextField> newRow = List.generate(
        numberOfColumns,
        (index) => createTextField(),
      );
      textFieldGrid.add(newRow);
    });
  }

  void addColumn() {
    setState(() {
      for (var row in textFieldGrid) {
        row.add(createTextField());
      }
    });
  }

  void removeRow() {
    // 最後の1行は削除しない
    if (textFieldGrid.length > 1) {
      setState(() {
        textFieldGrid.removeLast();
      });
    }
  }

  void removeColumn() {
    // 各行の最後の1列は削除しない
    if (textFieldGrid.first.length > 1) {
      setState(() {
        for (var row in textFieldGrid) {
          row.removeLast();
        }
      });
    }
  }

  TextField createTextField() {
    return TextField(
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        hintText: '入力してください',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        SingleChildScrollView(
          child: Column(
            children: [
              ...textFieldGrid.map((List<TextField> row) {
                return Row(
                  children: row
                      .map((textField) => Expanded(child: textField))
                      .toList(),
                );
              }).toList(),
              SizedBox(height: 50), // 下の要素の高さのスペースを確保
            ],
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            height: 50, // 下の要素の高さは固定
            color: Colors.blueGrey,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: addRow,
                    child: Text('行を追加'),
                  ),
                  SizedBox(width: 20), // ボタン間のスペース
                  ElevatedButton(
                    onPressed: textFieldGrid.length > 1
                        ? removeRow
                        : null, //行が1つのみの場合は削除ボタンを非活性化
                    child: Text('行を削除'),
                  ),
                  SizedBox(width: 20), // ボタン間のスペース
                  ElevatedButton(
                    onPressed: addColumn,
                    child: Text('列を追加'),
                  ),
                  SizedBox(width: 20), // ボタン間のスペース
                  ElevatedButton(
                    onPressed: textFieldGrid.first.length > 1
                        ? removeColumn
                        : null, //列が1つのみの場合は削除ボタンを非活性化
                    child: Text('列を削除'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
