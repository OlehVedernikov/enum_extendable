import 'package:collection/collection.dart';
import 'package:example/example.dart';
import 'package:test/test.dart';

void main() {
  Function listEquals = const ListEquality().equals;

  group('MathOperator enum', () {
    test('the MathOperator enum should contains 4 items', () {
      expect(MathOperator.values.length, 4);
    });
  });

  group('MathOperatorExt', () {
    test('the method isHighPriority should return correct item', () {
      expect(MathOperator.plus.isHighPriority, false);
      expect(MathOperator.minus.isHighPriority, false);
      expect(MathOperator.multiply.isHighPriority, true);
      expect(MathOperator.divide.isHighPriority, true);
    });

    test('the method symbol should return correct item', () {
      expect(MathOperator.plus.symbol, '+');
      expect(MathOperator.minus.symbol, '-');
      expect(MathOperator.multiply.symbol, '*');
      expect(MathOperator.divide.symbol, '/');
    });

    test('the method calculate should return correct item', () {
      expect(MathOperator.plus.calculate(1, 1), 2);
      expect(MathOperator.plus.calculate(-1, 1), 0);

      expect(MathOperator.minus.calculate(1, 1), 0);
      expect(MathOperator.minus.calculate(-1, 1), -2);

      expect(MathOperator.multiply.calculate(1, 2), 2);
      expect(MathOperator.multiply.calculate(0, 1), 0);

      expect(MathOperator.divide.calculate(4, 2), 2.0);
      expect(MathOperator.divide.calculate(4, 0), double.infinity);
    });
  });

  group('MathOperatorStringExt', () {
    test(
        'The method toMathOperatorBySymbol should return correct '
        'enum values by correct symbols and null by incorrect ones', () {
      expect('+'.toMathOperatorBySymbol(), MathOperator.plus);
      expect('-'.toMathOperatorBySymbol(), MathOperator.minus);
      expect('*'.toMathOperatorBySymbol(), MathOperator.multiply);
      expect('/'.toMathOperatorBySymbol(), MathOperator.divide);
    });

    test('The method toMathOperatorBySymbol should return null', () {
      expect(''.toMathOperatorBySymbol(), null);
      expect('1'.toMathOperatorBySymbol(), null);
      expect('a'.toMathOperatorBySymbol(), null);
    });

    test('The method toMathOperatorBySymbol should return defaultValue', () {
      expect(''.toMathOperatorBySymbol(defaultValue: MathOperator.plus),
          MathOperator.plus);
      expect('1'.toMathOperatorBySymbol(defaultValue: MathOperator.minus),
          MathOperator.minus);
      expect('a'.toMathOperatorBySymbol(defaultValue: MathOperator.multiply),
          MathOperator.multiply);
      expect('a'.toMathOperatorBySymbol(defaultValue: MathOperator.divide),
          MathOperator.divide);
    });
  });

  group('MathOperatorStringIterableExt', () {
    test(
        'The method toMathOperatorBySymbol should return correct enum items by correct symbols and null by incorrect ones',
        () {
      expect(
        listEquals(
            [
              '+',
              '',
              '*',
              '1',
              '-',
              '/',
              'a',
            ].toMathOperatorBySymbol(),
            [
              MathOperator.plus,
              null,
              MathOperator.multiply,
              null,
              MathOperator.minus,
              MathOperator.divide,
              null,
            ]),
        true,
      );
    });

    test('The method toMathOperatorBySymbol should return an empty list', () {
      expect(
        <String>[].toMathOperatorBySymbol().isEmpty,
        true,
      );
    });

    test(
        'The method toNotNullMathOperatorBySymbol should return correct enum items by correct symbols and the default value by incorrect ones',
        () {
      expect(
        listEquals(
            [
              '+',
              '',
              '*',
              '1',
              '-',
              '/',
              'a',
            ].toNotNullMathOperatorBySymbol(MathOperator.plus),
            [
              MathOperator.plus,
              MathOperator.plus,
              MathOperator.multiply,
              MathOperator.plus,
              MathOperator.minus,
              MathOperator.divide,
              MathOperator.plus,
            ]),
        true,
      );
    });

    test('The method toNotNullMathOperatorBySymbol should return an empty list',
        () {
      expect(
        <String>[].toNotNullMathOperatorBySymbol(MathOperator.plus).isEmpty,
        true,
      );
    });
  });
}
