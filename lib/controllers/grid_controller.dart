import 'package:bluaka_event_solver/importer.dart';

class GridController {
  List<List<Widget>> textFieldGrid = [];
  List<List<TextEditingController>> controllersGrid = [];

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
    List<Widget> newRow = [];
    List<TextEditingController> newControllersRow = [];
    int numberOfRows = controllersGrid.length;
    int numberOfColmuns = controllersGrid.first.length;
    for (int col = 0; col < numberOfColmuns; col++) {
      TextEditingController newController = TextEditingController();
      newControllersRow.add(newController);
      newRow.add(TextFieldController.createTextField(
          controller: newController,
          row: numberOfRows,
          col: col,
          numberOfRows: numberOfRows));
    }
    textFieldGrid.insert(numberOfRows - 2, newRow);
    controllersGrid.insert(numberOfRows - 2, newControllersRow);
  }

  void addColumn() {
    int numberOfRows = controllersGrid.length;
    int numberOfColmuns = controllersGrid.first.length;
    for (int row = 0; row < numberOfRows; row++) {
      TextEditingController newController = TextEditingController();
      textFieldGrid[row].add(TextFieldController.createTextField(
          controller: newController,
          row: row,
          col: numberOfColmuns,
          numberOfRows: numberOfRows));
      controllersGrid[row].add(newController);
    }
  }

  void removeRow() {
    // 残り4行は削除しない
    if (textFieldGrid.length > 4) {
      // 下から3行目を削除する
      int removeIndex = textFieldGrid.length - 3;
      textFieldGrid.removeAt(removeIndex);
      controllersGrid.removeAt(removeIndex);
    }
  }

  void removeColumn() {
    // 残り3列は削除しない
    if (textFieldGrid.first.length > 3) {
      for (var row in textFieldGrid) {
        row.removeLast();
      }
      for (var rowControllers in controllersGrid) {
        rowControllers.removeLast();
      }
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
        newRow.add(TextFieldController.createTextField(
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
    textFieldGrid.clear();
    controllersGrid.clear();
  }
}
