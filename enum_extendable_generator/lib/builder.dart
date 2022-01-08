library enum_extendable.builder;

import 'package:build/build.dart';
import 'package:enum_extendable_generator/src/enum_extendable_generator.dart';
import 'package:source_gen/source_gen.dart';

/// Builds generators for `build_runner` to run
// Builder enumExtendable(BuilderOptions options) =>
//     SharedPartBuilder([EnumExtendableGenerator()], 'enum_extendable_generator');
Builder enumExtendable(BuilderOptions options) {
  return PartBuilder(
    [EnumExtendableGenerator()],
    '.enum_extendable.g.dart',
    options: options,
  );
}
