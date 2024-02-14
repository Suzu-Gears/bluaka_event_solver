import 'package:flutter/material.dart';
import 'local_storage.dart';
import 'dart:convert';

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
    Future(() async {
      final String? loadedText = await loadText();
      loadedText != null
          ? createGrid(parseStringToListOfLists(loadedText))
          : initializeGrid();
    });
  }

  void initializeGrid() {
    // 初期状態で4行3列のテキストフィールドを追加
    const List<List<String>> gridText = [
      ["", "", "", ""],
      ["", "", "", ""],
      ["", "", "", ""],
      ["", "", "", ""]
    ];
    createGrid(gridText);
  }

  void addRow() {
    setState(() {
      List<TextField> newRow = [];
      List<TextEditingController> newControllersRow = [];
      int numberOfRows = controllersGrid.length;
      int numberOfColmuns = controllersGrid.first.length;
      for (int col = 0; col < numberOfColmuns; col++) {
        TextEditingController newController = TextEditingController();
        newControllersRow.add(newController);
        newRow.add(createTextField(
            controller: newController, row: numberOfRows, col: col));
      }
      textFieldGrid.add(newRow);
      controllersGrid.add(newControllersRow);
    });
  }

  void addColumn() {
    setState(() {
      int numberOfRows = controllersGrid.length;
      int numberOfColmuns = controllersGrid.first.length;
      for (int row = 0; row < numberOfRows; row++) {
        TextEditingController newController = TextEditingController();
        textFieldGrid[row].add(createTextField(
            controller: newController, row: row, col: numberOfColmuns));
        controllersGrid[row].add(newController);
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
    int numberOfRows = gridText.length;
    int numberOfColmuns = gridText.first.length;
    for (int row = 0; row < numberOfRows; row++) {
      List<String> rowText = gridText[row];
      List<TextField> newRow = [];
      List<TextEditingController> newControllersRow = [];
      for (int col = 0; col < numberOfColmuns; col++) {
        String cellText = rowText[col];
        TextEditingController newController =
            TextEditingController(text: cellText);
        newControllersRow.add(newController);
        newRow.add(
            createTextField(controller: newController, row: row, col: col));
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

  TextField createTextField(
      {required TextEditingController controller,
      required int row,
      required int col}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        hintText: '入力してください',
      ),
    );
  }

  String converControllerGridToString(
      List<List<TextEditingController>> controllersGrid) {
    String rowToString(List<TextEditingController> row) {
      String texts = row.map((controller) => '"${controller.text}"').join(', ');
      return '[$texts]';
    }

    String result = controllersGrid.map(rowToString).join(', ');

    return '[$result]';
  }

  void showCustomDialog(String title, String content) async {
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

  List<List<String>> parseStringToListOfLists(String jsonString) {
    // JSONをデコードしてオブジェクトに変換
    List<dynamic> decoded = json.decode(jsonString);

    // List<dynamic>からList<List<String>>にキャスト
    List<List<String>> gridText = decoded
        .map<List<String>>((dynamic row) => List<String>.from(row))
        .toList();

    return gridText;
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
                        : null, //行が1つ以下の場合は削除ボタンを非活性化
                    child: Text('行を削除'),
                  ),
                  ElevatedButton(
                    onPressed: addColumn,
                    child: Text('列を追加'),
                  ),
                  ElevatedButton(
                    onPressed: textFieldGrid.first.length > 3
                        ? removeColumn
                        : null, //列が3つ以下の場合は削除ボタンを非活性化
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
                      onPressed: () async {
                        removeText();
                      },
                      child: Text('REMOVE')),
                  ElevatedButton(
                      onPressed: () async {
                        saveText(converControllerGridToString(controllersGrid));
                      },
                      child: Text('SAVE')),
                  ElevatedButton(
                      onPressed: () async {
                        final String? loadedText = await loadText();
                        loadedText != null
                            ? createGrid(parseStringToListOfLists(loadedText))
                            : showCustomDialog('読み取り結果', 'データが保存されていません。');
                      },
                      child: Text('LOAD')),
                  ElevatedButton(
                    onPressed: () {
                      showCustomDialog('配列の内容',
                          converControllerGridToString(controllersGrid));
                    },
                    child: Text('配列表示'),
                  ),
                  ElevatedButton(
                    onPressed: resetGrid,
                    child: Text('RESET'),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
