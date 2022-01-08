// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'example.dart';

// **************************************************************************
// EnumExtendableGenerator
// **************************************************************************

extension MathOperatorExt on MathOperator {
  num Function(num, num) get calculate {
    _checkMathOperatorValues();
    return _MathOperatorPodo._values[this]!.calculate;
  }

  String get symbol {
    _checkMathOperatorValues();
    return _MathOperatorPodo._values[this]!.symbol;
  }

  bool get isHighPriority {
    _checkMathOperatorValues();
    return _MathOperatorPodo._values[this]!.isHighPriority;
  }
}

extension MathOperatorStringExt on String {
  MathOperator? toMathOperatorBySymbol({MathOperator? defaultValue}) {
    _checkMathOperatorValues();
    for (MathOperator element in _MathOperatorPodo._values.keys) {
      if (_MathOperatorPodo._values[element]!.symbol == this) {
        return element;
      }
    }
    return defaultValue;
  }
}

extension MathOperatorStringIterableExt on Iterable<String> {
  List<MathOperator?> toMathOperatorBySymbol({MathOperator? defaultValue}) {
    _checkMathOperatorValues();
    return List<MathOperator?>.of(
        map((e) => e.toMathOperatorBySymbol(defaultValue: defaultValue))
            .toList());
  }

  List<MathOperator> toNotNullMathOperatorBySymbol(
    MathOperator defaultValue,
  ) {
    _checkMathOperatorValues();
    return List<MathOperator>.of(map((e) =>
        e.toMathOperatorBySymbol(defaultValue: defaultValue) ??
        defaultValue).toList());
  }
}

_checkMathOperatorValues() {
  assert(_MathOperatorPodo._values.length == MathOperator.values.length);
}
