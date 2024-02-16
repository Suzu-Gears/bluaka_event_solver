import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  List<List<Widget>> textFieldGrid = [];
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
    initializeGrid();
    Future(() async {
      final String? loadedText = await loadText();
      if (loadedText != null) {
        createGrid(parseStringToListOfLists(loadedText));
      }
    });
  }

  void initializeGrid() {
    // 初期状態で4行3列のテキストフィールドを追加
    const List<List<String>> gridText = [
      ["", "", "", "", ""],
      ["", "", "", "", ""],
      ["", "", "", "", ""],
      ["", "", "", "", ""],
      ["", "", "", "", ""],
      ["", "", "", "", ""],
      ["", "", "", "", ""]
    ];
    createGrid(gridText);
  }

  void addRow() {
    setState(() {
      List<Widget> newRow = [];
      List<TextEditingController> newControllersRow = [];
      int numberOfRows = controllersGrid.length;
      int numberOfColmuns = controllersGrid.first.length;
      for (int col = 0; col < numberOfColmuns; col++) {
        TextEditingController newController = TextEditingController();
        newControllersRow.add(newController);
        newRow.add(createTextField(
            controller: newController,
            row: numberOfRows,
            col: col,
            numberOfRows: numberOfRows));
      }
      textFieldGrid.insert(numberOfRows - 2, newRow);
      controllersGrid.insert(numberOfRows - 2, newControllersRow);
    });
  }

  void addColumn() {
    setState(() {
      int numberOfRows = controllersGrid.length;
      int numberOfColmuns = controllersGrid.first.length;
      for (int row = 0; row < numberOfRows; row++) {
        TextEditingController newController = TextEditingController();
        textFieldGrid[row].add(createTextField(
            controller: newController,
            row: row,
            col: numberOfColmuns,
            numberOfRows: numberOfRows));
        controllersGrid[row].add(newController);
      }
    });
  }

  void removeRow() {
    // 残り4行以下では削除しない
    if (textFieldGrid.length > 4) {
      setState(() {
        // 下から3行目の要素を削除する
        int removeIndex = textFieldGrid.length - 3;
        textFieldGrid.removeAt(removeIndex);
        controllersGrid.removeAt(removeIndex);
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
      List<Widget> newRow = [];
      List<TextEditingController> newControllersRow = [];
      for (int col = 0; col < numberOfColmuns; col++) {
        String cellText = rowText[col];
        TextEditingController newController =
            TextEditingController(text: cellText);
        newControllersRow.add(newController);
        newRow.add(createTextField(
            controller: newController,
            row: row,
            col: col,
            numberOfRows: numberOfRows));
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

  Widget createTextField(
      {required TextEditingController controller,
      required int row,
      required int col,
      required int numberOfRows}) {
    int flex = 1;
    bool enabled = true;
    InputDecoration decoration = InputDecoration(
      border: OutlineInputBorder(),
      disabledBorder: InputBorder.none,
      isDense: true,
      contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 6.0),
      hintText: '0',
    );
    TextInputType keyboadType = TextInputType.number;

    if (col == 0) {
      flex = 2;
      keyboadType = TextInputType.text;
      decoration = decoration.copyWith(
        hintText: 'Stage Name',
      );
    }
    if (row == 0) {
      if (col == 0 || col == 1) {
        decoration = decoration.copyWith(
          hintText: col == 0 ? 'Stage' : 'AP',
          hintStyle: TextStyle(color: Colors.black),
          contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 6.0),
        );
        enabled = false;
      } else {
        decoration = decoration.copyWith(
          hintText: 'Item',
        );
      }
    }
    if (row == numberOfRows - 2) {
      if (col == 0 || col == 1) {
        decoration = decoration.copyWith(
          hintText: col == 0 ? '' : '初期数',
          hintStyle: TextStyle(color: Colors.black),
          contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 6.0),
        );
        enabled = false;
      }
    }
    if (row == numberOfRows - 1) {
      if (col == 0 || col == 1) {
        decoration = decoration.copyWith(
          hintText: col == 0 ? '' : '目標数',
          hintStyle: TextStyle(color: Colors.black),
          contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 6.0),
        );
        enabled = false;
      }
    }

    return Expanded(
      flex: flex,
      child: TextField(
        controller: controller,
        enabled: enabled,
        decoration: decoration,
        keyboardType: keyboadType,
        inputFormatters: (row == 0 || col == 0)
            ? []
            : [
                FilteringTextInputFormatter.allow(RegExp(r'^[1-9]\d*|0$')),
              ],
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
        alignment: Alignment.center,
        padding: const EdgeInsets.all(4),
        child: Column(
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
                  children: textFieldGrid.map((List<Widget> row) {
                    return Row(
                      children: row,
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
