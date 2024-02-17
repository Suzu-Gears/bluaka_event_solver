import 'package:bluaka_event_solver/importer.dart';

class SolverLogic {
  late final List<Stage> _stageList;
  late final List<Item> _itemList;
  late final BuildContext _context;
  late int numberOfStages;
  late int numberOfItems;

  SolverLogic({
    required List<Stage> stageList,
    required List<Item> itemList,
    required BuildContext context,
  }) {
    this._stageList = stageList;
    this._itemList = itemList;
    this._context = context;
    this.numberOfStages = _stageList.length;
    this.numberOfItems = _itemList.length;
  }

  set stageList(List<Stage> value) {
    _stageList = value;
    numberOfStages = _stageList.length;
  }

  set itemList(List<Item> value) {
    _itemList = value;
    numberOfItems = _itemList.length;
  }

  set context(BuildContext value) {
    _context = value;
  }

  bool _isApprovedAllZeroAPStages() {
    return _stageList.every((stage) => stage.isArrowdZeroAPStage());
  }

  bool _canGetAllItems() {
    for (int itemIndex = 0; itemIndex < numberOfItems; itemIndex++) {
      // そのアイテムがどのステージでもドロップしない場合falseを返す
      if (_itemList[itemIndex].requiredValue > 0 &&
          _stageList.every((stage) => stage.dropItems[itemIndex] <= 0)) {
        return false;
      }
    }
    // 全ての必要なアイテムが少なくとも1つのステージでドロップする場合trueを返す
    return true;
  }

  void calculateSolver() {
    if (!_isApprovedAllZeroAPStages()) {
      showCustomDialog(_context, 'エラー', 'APが0でアイテムがドロップするステージがあります。');
      return;
    }
    if (!_canGetAllItems()) {
      showCustomDialog(_context, 'エラー', '目標値があるのにドロップしないアイテムがあります。');
      return;
    }

    final solver = Solver();

    Expression totalAP = cm(0).asExpression();
    for (var stage in _stageList) {
      // 各ステージの周回数は0以上とする強い制約
      solver.addConstraint(stage.run >= cm(0)
        ..priority = Priority.strong);

      for (int itemIndex = 0; itemIndex < numberOfItems; itemIndex++) {
        // 各アイテム毎にドロップ数を加算
        _itemList[itemIndex].collectedValue +=
            cm(stage.dropItems[itemIndex]) * stage.run;
      }

      // 各ステージ毎にAPの消費量を加算
      totalAP += cm(stage.requiredAP) * stage.run;
    }

    //合計APを0以下とする弱い制約(目的関数の代用)
    solver.addConstraint(totalAP <= cm(0)
      ..priority = Priority.weak);

    // 各アイテム毎の合計ドロップ数は必要アイテム数以上とする強い制約
    for (var item in _itemList) {
      if (item.requiredValue > 0) {
        solver.addConstraint(item.collectedValue >= cm(item.requiredValue)
          ..priority = Priority.strong);
      }
    }
    solver.flushUpdates();

    // 解の出力
    print('totalAP: ${totalAP.value}');
    for (var stage in _stageList) {
      print('${stage.name}: ${stage.run.value}');
    }
    for (var item in _itemList) {
      print('${item.name}: ${item.collectedValue.value}');
    }

    int combinations = 1 << numberOfStages;
    int bestCombination = 0;
    double bestAP = double.infinity;
    List<int> bestStageRuns = List.filled(numberOfStages, 0);
    List<int> itemSums = List.filled(numberOfItems, 0);

    // 切り捨て後の解をスタートとする
    List<int> baseStageRuns = _stageList.map((stage) => stage.baseRun).toList();

    // 各組み合わせの検証
    for (int combination = 0; combination < combinations; combination++) {
      double currentAP = 0;
      List<int> currentStageRuns = List<int>.from(baseStageRuns);
      List<int> currentitemSums = List.filled(numberOfItems, 0);
      bool meetsTarget = true;

      // ステージの回数を増加させるかの判定
      for (int i = 0; i < numberOfStages; i++) {
        if ((combination & (1 << i)) != 0) {
          currentStageRuns[i] += 1;
        }
      }

      // 各ステージで得られるアイテムの合計数を計算
      for (int j = 0; j < numberOfStages; j++) {
        int stageRuns = currentStageRuns[j];
        currentAP += _stageList[j].requiredAP * stageRuns;
        for (int k = 0; k < numberOfItems; k++) {
          currentitemSums[k] +=
              (stageRuns * _stageList[j].dropItems[k]).toInt();
        }
      }

      // 各アイテムに対する目標達成のチェック
      for (int k = 0; k < numberOfItems; k++) {
        if (currentitemSums[k] < _itemList[k].requiredValue) {
          meetsTarget = false;
          break;
        }
      }

      // 最良の結果を更新
      if (meetsTarget && currentAP < bestAP) {
        bestAP = currentAP;
        bestCombination = combination;
        bestStageRuns = currentStageRuns;
        itemSums = currentitemSums;
      }
    }
    // 表示情報の設定
    String localDisplayText = '';
    localDisplayText += '必要周回数\n';
    for (int i = 0; i < bestStageRuns.length; i++) {
      localDisplayText += '${_stageList[i].name}: ${bestStageRuns[i]}回\n';
    }
    localDisplayText += '\n収集アイテム数\n';
    for (var i = 0; i < numberOfItems; i++) {
      localDisplayText +=
          '${_itemList[i].name}: ${itemSums[i] + _itemList[i].initialValue}/${_itemList[i].targetValue}\n';
    }
    localDisplayText += '\n合計AP: ${bestAP.toInt()}';
    showCustomDialog(_context, '計算結果', localDisplayText);
  }
}
