import 'dart:collection';

import 'package:collection/collection.dart';
import 'package:example/example.dart';
import 'package:example/extensions.dart';

class CalcUtils {
  static const List<String> _signSymbols = ['+', '-'];

  ///Returns calculated value of [expression], or [failMessage] if
  ///format of [expression] is incorrect.
  ///
  ///Returns 'Infinity' if [expression] contains any division by zero
  static String calculate(String expression, String failMessage) {
    final formatted = expression.replaceAll(" ", "");
    return _calculateFormatted(formatted, failMessage);
  }

  static String _calculateFormatted(String expression, String failMessage) {
    try {
      return num.parse(expression).toString();
    } on FormatException catch (_) {
      try {
        final String newExpression = _calcSingle(expression, failMessage);
        return MathOperatorUtils.isAnyOperator(newExpression)
            ? _calculateFormatted(newExpression, failMessage)
            : newExpression;
      } catch (_) {
        return failMessage;
      }
    }
  }

  static String _calcSingle(String expression, String failMessage) {
    try {
      return num.parse(expression).toString();
    } catch (e) {
      final operatorsSymbols =
          MathOperatorUtils.isAnyHighPriorityOperator(expression)
              ? MathOperatorUtils.highPriorityOperatorsSymbols
              : MathOperatorUtils.operatorsSymbols;
      final _CalcData? calcData =
          _findFirstCalcData(expression, operatorsSymbols);
      return calcData == null
          ? failMessage
          : expression.replaceFirst(calcData.source, calcData.result);
    }
  }

  static _CalcData? _findFirstCalcData(
      String expression, Set<String> operatorsSymbols) {
    final fail = null;
    try {
      final List<String> subStrings =
          expression.splitWithDividers(MathOperatorUtils.operatorsSymbols);
      if (subStrings.length > 1 &&
          subStrings[0].isEmpty &&
          _signSymbols.contains(subStrings[1])) {
        final String sign = subStrings[1];
        subStrings.removeRange(0, 2);
        subStrings[0] = sign + subStrings[0];
      }
      final index = subStrings
          .indexWhere((element) => operatorsSymbols.contains(element));

      ///1. index == -1 - not found
      ///
      ///2. index == 0 - an operator is at the first position, so the first
      ///argument for calculation is absent
      ///
      ///3. index == subStrings.length - 1 - an operator is at the
      ///last position, so the second argument for calculation is absent
      if (index < 1 || index == subStrings.length - 1) return fail;

      final operator = subStrings[index].toMathOperatorBySymbol();
      if (operator == null) return fail;

      final n1 = num.parse(subStrings[index - 1]);
      final n2 = num.parse(subStrings[index + 1]);

      final source =
          subStrings[index - 1] + subStrings[index] + subStrings[index + 1];

      return _CalcData(operator, n1, n2, source);
    } catch (e) {
      return fail;
    }
  }
}

class MathOperatorUtils {
  /// The set of symbols of all [MathOperator] items
  static final Set<String> operatorsSymbols =
      HashSet.from(MathOperator.values.map((e) => e.symbol).toList());

  /// The set of symbols of high priority [MathOperator] items
  static final Set<String> highPriorityOperatorsSymbols = HashSet.from(
      MathOperator.values
          .where((element) => element.isHighPriority)
          .map((e) => e.symbol)
          .toList());

  /// Return true if [str] contains at least one of [MathOperator] item symbols
  static bool isAnyOperator(String str) =>
      operatorsSymbols.firstWhereOrNull(
        (operatorSymbol) => str.contains(operatorSymbol),
      ) !=
      null;

  /// Return true if [str] contains at least one of high priority [MathOperator] item symbols
  static bool isAnyHighPriorityOperator(String str) =>
      highPriorityOperatorsSymbols.firstWhereOrNull(
        (operatorSymbol) => str.contains(operatorSymbol),
      ) !=
      null;
}

class _CalcData {
  final MathOperator operator;
  final num n1;
  final num n2;
  final String source;

  _CalcData(this.operator, this.n1, this.n2, this.source);

  String get result => operator.calculate(n1, n2).toString();

  ttt() {
    final n1 = 1;
    final n2 = 2.0;
    MathOperator.values.forEach((operator) {
      print('$n1 ${operator.symbol} $n2 = ${operator.calculate(n1, n2)}');
    });
  }
}
