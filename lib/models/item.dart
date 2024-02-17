import 'package:bluaka_event_solver/importer.dart';

class Item {
  final String name;
  late final double _initialValue, _targetValue;
  Expression collectedValue = cm(0).asExpression();
  int currentValue = 0;

  Item(
      {required this.name,
      required double initialValue,
      required double targetValue}) {
    this.initialValue = initialValue;
    this.targetValue = targetValue;
  }

  double get initialValue => _initialValue;
  set initialValue(double value) {
    _validateNegativeValue(value, 'アイテムの初期値に負の値が含まれています。');
    _initialValue = formatNumber(value);
  }

  double get targetValue => _targetValue;
  set targetValue(double value) {
    _validateNegativeValue(value, 'アイテムの目標値に負の値が含まれています。');
    _targetValue = formatNumber(value);
  }

  double get requiredValue => formatNumber(_targetValue - _initialValue);

  void _validateNegativeValue(double value, String errorMessage) {
    assert(value >= 0, errorMessage);
  }

  @override
  String toString() {
    // アイテムの名前、初期値、目標値、現在の値、集められた値をテキスト化
    return 'Item: $name, Initial Value: ${_initialValue.toStringAsFixed(2)}, '
        'Target Value: ${_targetValue.toStringAsFixed(2)}, '
        'Current Value: $currentValue, '
        'Collected Value: ${collectedValue.value}';
  }
}
