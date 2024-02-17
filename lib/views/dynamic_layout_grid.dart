import 'package:bluaka_event_solver/importer.dart';

class DynamicLayoutGrid extends StatefulWidget {
  @override
  _DynamicLayoutGridState createState() => _DynamicLayoutGridState();
}

class _DynamicLayoutGridState extends State<DynamicLayoutGrid> {
  final GridController _gridController = GridController();

  @override
  void dispose() {
    for (var row in _gridController.controllersGrid) {
      for (var controller in row) {
        controller.dispose();
      }
    }
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _gridController.initializeGrid();
    Future(() async {
      final String? loadedText = await loadText();
      if (loadedText != null) {
        _createGrid(parseStringToListOfLists(loadedText));
      }
    });
  }

  void _addRow() {
    setState(() {
      _gridController.addRow();
    });
  }

  void _addColumn() {
    setState(() {
      _gridController.addColumn();
    });
  }

  void _removeRow() {
    setState(() {
      _gridController.removeRow();
    });
  }

  void _removeColumn() {
    setState(() {
      _gridController.removeColumn();
    });
  }

  void _createGrid(List<List<String>> gridText) {
    setState(() {
      _gridController.createGrid(gridText);
    });
  }

  void _resetGrid() {
    setState(() {
      _gridController.resetGrid();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(4),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: Column(
            children: [
              TopControlButtons(
                onAddRow: _addRow,
                onRemoveRow: _gridController.textFieldGrid.length > 4
                    ? _removeRow
                    : null,
                onAddColumn: _addColumn,
                onRemoveColumn: _gridController.textFieldGrid.first.length > 3
                    ? _removeColumn
                    : null,
              ),
              Row(
                children: _gridController.textFieldGrid.first,
              ),
              Flexible(
                child: Scrollbar(
                  thumbVisibility: true,
                  child: SingleChildScrollView(
                    child: Column(
                      children: _gridController.textFieldGrid
                          .sublist(1, _gridController.textFieldGrid.length - 2)
                          .map((List<Widget> row) {
                        return Row(
                          children: row,
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
              Row(
                children: _gridController
                    .textFieldGrid[_gridController.textFieldGrid.length - 2],
              ),
              Row(
                children: _gridController.textFieldGrid.last,
              ),
              BottomControlButtons(
                onSave: () async {
                  saveText(converControllerGridToString(
                      _gridController.controllersGrid));
                },
                onLoad: () async {
                  final String? loadedText = await loadText();
                  loadedText != null
                      ? _createGrid(parseStringToListOfLists(loadedText))
                      : showCustomDialog(context, '読み取り結果', 'データが保存されていません。');
                },
                onDisplayArray: () {
                  showCustomDialog(
                      context,
                      '配列の内容',
                      converControllerGridToString(
                          _gridController.controllersGrid));
                },
                onReset: _resetGrid,
                onCalc: () {
                  SolverLogic solverLogic = SolverLogic(
                      stageList: gridTextToStageList(fillWithZero(
                          parseStringToListOfLists(converControllerGridToString(
                              _gridController.controllersGrid)))),
                      itemList: gridTextToItemList((fillWithZero(
                          parseStringToListOfLists(converControllerGridToString(
                              _gridController.controllersGrid))))),
                      context: context);
                  solverLogic.calculateSolver();
                },
              ),
            ],
          ),
        ));
  }
}
