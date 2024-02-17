import 'package:bluaka_event_solver/importer.dart';

class Stage {
  final String name;
  late double _requiredAP;
  late final List<double> _dropItems;
  Param run = Param(0);

  Stage(
      {required this.name,
      required double requiredAP,
      required List<double> dropItems}) {
    this.requiredAP = requiredAP;
    this.dropItems = dropItems;
  }

  double get requiredAP => _requiredAP;
  set requiredAP(double value) {
    assert(value >= 0, '必要APに負の値が含まれています。');
    _requiredAP = formatNumber(value);
  }

  List<double> get dropItems => _dropItems;
  set dropItems(List<double> value) {
    assert(value.every((item) => item >= 0), 'ドロップアイテムに負の値が含まれています。');
    _dropItems = value;
  }

  int get baseRun => formatNumber(run.value).toInt();

  bool isArrowdZeroAPStage() {
    if (_requiredAP <= 0 && dropItems.any((item) => item > 0)) {
      return false;
    }
    return true;
  }

  @override
  String toString() {
    // ステージ名、必要AP、ドロップアイテムをテキスト化
    String dropItemsText =
        _dropItems.map((item) => item.toStringAsFixed(0)).join(', ');
    return 'Stage: $name, Required AP: ${_requiredAP.toStringAsFixed(0)}, Drop Items: [$dropItemsText]';
  }
}
