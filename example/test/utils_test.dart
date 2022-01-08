import 'package:example/utils.dart';
import 'package:test/test.dart';

void main() {
  const _failCalculateMessage = "fail calculation";
  const _divisionByZeroMessage = "Infinity";

  group('CalcUtils', () {
    test('the calculate method should correct calculate', () {
      expect(CalcUtils.calculate("-1", _failCalculateMessage), '-1');
      expect(CalcUtils.calculate("+1", _failCalculateMessage), '1');
      expect(CalcUtils.calculate("-1.2", _failCalculateMessage), '-1.2');
      expect(CalcUtils.calculate("+1.2", _failCalculateMessage), '1.2');
      expect(CalcUtils.calculate("1+3", _failCalculateMessage), '4');
      expect(CalcUtils.calculate("1+3*2", _failCalculateMessage), '7');
      expect(CalcUtils.calculate("1+3/2", _failCalculateMessage), '2.5');
      expect(CalcUtils.calculate("1+3/2+1.23", _failCalculateMessage), '3.73');
      expect(CalcUtils.calculate("1-3/2-1.23", _failCalculateMessage), '-1.73');
      expect(
          CalcUtils.calculate("-1+2*3-4*5/2", _failCalculateMessage), '-5.0');
    });

    test('the calculate method should return Infinity if division by zero', () {
      expect(CalcUtils.calculate("1/0", _failCalculateMessage),
          _divisionByZeroMessage);
      expect(CalcUtils.calculate("1+1/0", _failCalculateMessage),
          _divisionByZeroMessage);
    });

    test(
        'the calculate method should return failMessage if format is incorrect',
        () {
      expect(CalcUtils.calculate("", _failCalculateMessage),
          _failCalculateMessage);
      expect(CalcUtils.calculate("a", _failCalculateMessage),
          _failCalculateMessage);
      expect(CalcUtils.calculate("+-8", _failCalculateMessage),
          _failCalculateMessage);
      expect(CalcUtils.calculate("8,7+1", _failCalculateMessage),
          _failCalculateMessage);
    });
  });

  group('MathOperatorUtils', () {
    test('the operatorsSymbols set should contain only characters +, -, *, /',
        () {
      expect(MathOperatorUtils.operatorsSymbols.length, 4);
      expect(MathOperatorUtils.operatorsSymbols.contains("+"), true);
      expect(MathOperatorUtils.operatorsSymbols.contains("-"), true);
      expect(MathOperatorUtils.operatorsSymbols.contains("*"), true);
      expect(MathOperatorUtils.operatorsSymbols.contains("/"), true);
    });

    test(
        'the highPriorityOperatorsSymbols set should contain only characters *, /',
        () {
      expect(MathOperatorUtils.highPriorityOperatorsSymbols.length, 2);
      expect(
          MathOperatorUtils.highPriorityOperatorsSymbols.contains("*"), true);
      expect(
          MathOperatorUtils.highPriorityOperatorsSymbols.contains("/"), true);
    });

    test(
        'the isAnyOperator method should return true if the str contains at least one of characters +, -, *, /',
        () {
      expect(MathOperatorUtils.isAnyOperator('+'), true);
      expect(MathOperatorUtils.isAnyOperator('-'), true);
      expect(MathOperatorUtils.isAnyOperator('*'), true);
      expect(MathOperatorUtils.isAnyOperator('/'), true);
      expect(MathOperatorUtils.isAnyOperator('a+'), true);
      expect(MathOperatorUtils.isAnyOperator('a-'), true);
      expect(MathOperatorUtils.isAnyOperator('a*'), true);
      expect(MathOperatorUtils.isAnyOperator('a/'), true);
      expect(MathOperatorUtils.isAnyOperator('a+b'), true);
      expect(MathOperatorUtils.isAnyOperator('a-b'), true);
      expect(MathOperatorUtils.isAnyOperator('a*b'), true);
      expect(MathOperatorUtils.isAnyOperator('a/b'), true);
      expect(MathOperatorUtils.isAnyOperator('a+b-c'), true);
      expect(MathOperatorUtils.isAnyOperator('a+b-c*d'), true);
      expect(MathOperatorUtils.isAnyOperator('a+b-c*d/e'), true);
    });

    test(
        'the isAnyOperator method should return false if the str does not contains any of characters +, -, *, /',
        () {
      expect(MathOperatorUtils.isAnyOperator(''), false);
      expect(MathOperatorUtils.isAnyOperator('.'), false);
      expect(MathOperatorUtils.isAnyOperator('1'), false);
      expect(MathOperatorUtils.isAnyOperator('abc'), false);
    });

    test(
        'the isAnyHighPriorityOperator method should return true if the str contains at least one of characters *, /',
        () {
      expect(MathOperatorUtils.isAnyHighPriorityOperator('*'), true);
      expect(MathOperatorUtils.isAnyHighPriorityOperator('/'), true);
      expect(MathOperatorUtils.isAnyHighPriorityOperator('a*'), true);
      expect(MathOperatorUtils.isAnyHighPriorityOperator('a/'), true);
      expect(MathOperatorUtils.isAnyHighPriorityOperator('a*b'), true);
      expect(MathOperatorUtils.isAnyHighPriorityOperator('a/b'), true);
      expect(MathOperatorUtils.isAnyHighPriorityOperator('a*b'), true);
      expect(MathOperatorUtils.isAnyHighPriorityOperator('a*b/c'), true);
    });

    test(
        'the isAnyHighPriorityOperator method should return false if the str does not contains any of characters *, /',
        () {
      expect(MathOperatorUtils.isAnyHighPriorityOperator(''), false);
      expect(MathOperatorUtils.isAnyHighPriorityOperator('.'), false);
      expect(MathOperatorUtils.isAnyHighPriorityOperator('1'), false);
      expect(MathOperatorUtils.isAnyHighPriorityOperator('abc'), false);
      expect(MathOperatorUtils.isAnyHighPriorityOperator('+'), false);
      expect(MathOperatorUtils.isAnyHighPriorityOperator('-'), false);
    });
  });
}
