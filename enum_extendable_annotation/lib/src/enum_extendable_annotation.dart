import 'package:meta/meta_meta.dart';

@Target({TargetKind.enumType})
class ExtendableEnum {
  const ExtendableEnum();
}

@Target({TargetKind.classType})
class ExtendableEnumPodo {
  const ExtendableEnumPodo();
}

@Target({TargetKind.field})
class ExtendableEnumValues {
  final bool checkCompleteness;

  const ExtendableEnumValues({
    this.checkCompleteness = true,
  });
}

@Target({TargetKind.field})
class ExtendableEnumField {
  final bool enumExtension;
  final bool classExtension;

  const ExtendableEnumField({
    this.enumExtension = true,
    this.classExtension = true,
  });
}
