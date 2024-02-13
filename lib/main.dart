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
  // テキストフィールドのリストを管理するためのリスト
  List<Widget> textFields = [];

  @override
  void initState() {
    super.initState();
    // 初期状態で1つテキストフィールドをリストに追加
    addTextField();
  }

  // テキストフィールドを追加するメソッド
  void addTextField() {
    textFields.add(
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'ここに入力してください',
          ),
        ),
      ),
    );
    setState(() {}); // 状態を更新して再描画をトリガー
  }

  // テキストフィールドを削除するメソッド
  void removeTextField() {
    // リストの長さが2以上の時のみ削除処理を行う
    if (textFields.length > 1) {
      textFields.removeLast();
      setState(() {}); // 状態を更新して再描画をトリガー
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        SingleChildScrollView(
          child: Column(
            children: <Widget>[
              ...textFields, // 展開して全てのテキストフィールドを表示
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
                    onPressed: addTextField, // テキストフィールド追加
                    child: Text('追加'),
                  ),
                  SizedBox(width: 20), // ボタン間のスペース
                  ElevatedButton(
                    onPressed: textFields.length > 1
                        ? removeTextField
                        : null, // テキストフィールド削除 テキストフィールドが1つのみの場合は削除ボタンを非活性化
                    child: Text('削除'),
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
