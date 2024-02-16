import 'package:bluaka_event_solver/importer.dart';

class TextFieldController {
  static CustomTextField createTextField({
    required TextEditingController controller,
    required int row,
    required int col,
    required int numberOfRows,
  }) {
    int flex = 1;
    bool enabled = true;
    InputDecoration decoration = InputDecoration(
      border: OutlineInputBorder(),
      disabledBorder: InputBorder.none,
      isDense: true,
      contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 6.0),
      hintText: '0',
    );
    TextInputType keyboardType = TextInputType.number;

    if (col == 0) {
      flex = 2;
      keyboardType = TextInputType.text;
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

    return CustomTextField(
      controller: controller,
      flex: flex,
      enabled: enabled,
      decoration: decoration,
      keyboardType: keyboardType,
      inputFormatters: (row == 0 || col == 0)
          ? []
          : [
              FilteringTextInputFormatter.allow(RegExp(r'^[1-9]\d*|0$')),
            ],
    );
  }
}
