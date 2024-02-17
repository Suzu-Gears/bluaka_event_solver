import 'package:bluaka_event_solver/importer.dart';

double truncateDecimalPoint(double value) => value.truncateToDouble();

double negativeToZero(double value) => max(0, value);

double formatNumber(double value) =>
    negativeToZero(truncateDecimalPoint(value));

List<Stage> gridTextToStageList(List<List<String>> gridText) {
  List<Stage> stageList = [];

  List<List<String>> extractedGrid = gridText.sublist(1, gridText.length - 2);
  for (var stageData in extractedGrid) {
    String name = stageData[0];
    double requiredAP = double.parse(stageData[1]);
    List<double> dropItems =
        stageData.sublist(2).map((item) => double.parse(item)).toList();

    stageList
        .add(Stage(name: name, requiredAP: requiredAP, dropItems: dropItems));
  }
  return stageList;
}

List<Item> gridTextToItemList(List<List<String>> gridText) {
  List<Item> itemList = [];

  List<String> firstRow = gridText.first;
  List<List<String>> lastTwoRows = gridText.sublist(gridText.length - 2);

  List<List<String>> extractedGrid = [firstRow] + lastTwoRows;
  int numberOfColumns = extractedGrid.first.length;
  for (var col = 2; col < numberOfColumns; col++) {
    String name = extractedGrid[0][col];
    double initialValue = double.parse(extractedGrid[1][col]);
    double targetValue = double.parse(extractedGrid[2][col]);

    itemList.add(
        Item(name: name, initialValue: initialValue, targetValue: targetValue));
  }
  return itemList;
}
