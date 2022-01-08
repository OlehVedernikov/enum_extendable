import 'dart:io';

import 'package:example/example.dart';
import 'package:example/utils.dart';

final _inputMessage =
    'Type a math expression (operators: ${MathOperator.values.map((e) => '${e.symbol}').toList()}): '
        .replaceAll('[', '')
        .replaceAll(']', '');
const _emptyExpressionMessage = 'The format of the expression is incorrect!';
const _incorrectExpressionMessage = 'The expression is incorrect!';
const _oneMoreCalculationMessage = 'One more calculation? (y/N)';

void main() {
  bool oneMoreCalculation = true;
  do {
    stdout.write(_inputMessage);
    final expression = stdin.readLineSync();
    stdout.writeln((expression?.isEmpty ?? true)
        ? _emptyExpressionMessage
        : CalcUtils.calculate(expression!, _incorrectExpressionMessage));

    stdout.writeln(_oneMoreCalculationMessage);
    oneMoreCalculation = stdin.readLineSync()?.toLowerCase() == "y";
  } while (oneMoreCalculation);
}
