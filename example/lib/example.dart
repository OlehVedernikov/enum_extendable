import 'package:enum_extendable_annotation/enum_extendable_annotation.dart';

part 'example.enum_extendable.g.dart';

@ExtendableEnum()
enum MathOperator { plus, minus, multiply, divide }

@ExtendableEnumPodo()
class _MathOperatorPodo {
  final num Function(num, num) calculate;
  final String symbol;
  @ExtendableEnumField(classExtension: false)
  final bool isHighPriority;

  _MathOperatorPodo({
    required this.calculate,
    required this.symbol,
    required this.isHighPriority,
  });

  @ExtendableEnumValues()
  static final Map<MathOperator, _MathOperatorPodo> _values = {
    MathOperator.plus: _MathOperatorPodo(
      calculate: (n1, n2) => n1 + n2,
      symbol: "+",
      isHighPriority: false,
    ),
    MathOperator.minus: _MathOperatorPodo(
      calculate: (n1, n2) => n1 - n2,
      symbol: "-",
      isHighPriority: false,
    ),
    MathOperator.multiply: _MathOperatorPodo(
      calculate: (n1, n2) => n1 * n2,
      symbol: "*",
      isHighPriority: true,
    ),
    MathOperator.divide: _MathOperatorPodo(
      ///division by 0 will yield double.infinity
      calculate: (n1, n2) => n1 / n2,
      symbol: "/",
      isHighPriority: true,
    ),
  };
}
