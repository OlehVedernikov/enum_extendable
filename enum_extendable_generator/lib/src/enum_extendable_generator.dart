import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/dart/element/visitor.dart';
import 'package:build/build.dart';
import 'package:collection/collection.dart' show IterableExtension;
import 'package:enum_extendable_annotation/enum_extendable_annotation.dart';
import 'package:source_gen/source_gen.dart';

const _buildEnumExtensionDefaultValue = true;
const _buildClassExtensionDefaultValue = true;
const _checkValuesCompletenessDefaultValue = true;

class EnumExtendableGenerator extends GeneratorForAnnotatedClass {
  static const _deepEqualsMethod = "_deepEquals";
  static const _defaultValueVarName = "defaultValue";
  static const _kDefaultValuesFieldName = "values";

  PodoVisitor _podoVisitor = PodoVisitor();
  final buf = StringBuffer();

  String? _enumName;
  String? _valuesName;
  bool _checkValues = _checkValuesCompletenessDefaultValue;

  EnumExtendableGenerator()
      : super([
          ExtendableEnum,
          ExtendableEnumPodo,
          ExtendableEnumValues,
          ExtendableEnumField,
        ]);

  @override
  String _generateCode() {
    if (_enumName == null) {
      if (!_podoVisitor.fields.isEmpty) {
        _generateEnumAnnotationWarning();
      }
    } else if (_valuesName == null && _isDefaultValuesFieldAbsent) {
      _generateValuesAnnotationWarning();
    } else {
      _generateEnumExtension();
      buf.writeln();
      _generateClassesExtensions();
      buf.writeln();
      if (_isAnyIterable(_podoVisitor.buildClassExtensionFields.keys)) {
        _generateDeepEquals();
      }
      if (_checkValues) _generateValuesCheck();
    }

    final String result = buf.toString().replaceAll("*", "");
    _reset();
    return result;
  }

  @override
  _generateForAnnotatedEnum(Element element, ConstantReader annotation) {
    if (annotation.instanceOf(TypeChecker.fromRuntime(ExtendableEnum)))
      _enumName = element.displayName;
  }

  @override
  _generateForAnnotatedClass(Element element, ConstantReader annotation) {
    if (annotation.instanceOf(TypeChecker.fromRuntime(ExtendableEnumPodo)))
      element.visitChildren(_podoVisitor);
  }

  @override
  _generateForAnnotatedField(FieldElement field, ConstantReader annotation) {
    if (annotation.instanceOf(TypeChecker.fromRuntime(ExtendableEnumValues))) {
      _valuesName = field.displayName;
      _checkValues = annotation.peek('checkCompleteness')?.boolValue ??
          _checkValuesCompletenessDefaultValue;
      final fieldData = _podoVisitor.fields
          .firstWhereOrNull((element) => element.name == field.name);
      if (fieldData != null) {
        fieldData.enumExtension = false;
        fieldData.classExtension = false;
      }
    } else if (annotation
        .instanceOf(TypeChecker.fromRuntime(ExtendableEnumField))) {
      final fieldData = _podoVisitor.fields
          .firstWhereOrNull((element) => element.name == field.name);
      if (fieldData != null) {
        fieldData.enumExtension = annotation.peek('enumExtension')?.boolValue ??
            _buildEnumExtensionDefaultValue;
        fieldData.classExtension =
            annotation.peek('classExtension')?.boolValue ??
                _buildClassExtensionDefaultValue;
      }
    }
  }

  bool get _isDefaultValuesFieldAbsent =>
      _podoVisitor.fields.firstWhereOrNull(
          (element) => element.name == _kDefaultValuesFieldName) ==
      null;

  void _generateEnumAnnotationWarning() {
    _generateWarning([
      'Please, make sure your enum is annotated with @ExtendableEnum().',
    ]);
  }

  void _generateValuesAnnotationWarning() {
    _generateWarning([
      'Values field with the default name "values" is not found.',
      'Please annotate your values field with @ExtendableEnumValues().',
    ]);
  }

  void _generateWarning(List<String> message) {
    buf.writeln('// '
        '!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'
        '!!!!!!!!');
    message.forEach((element) {
      buf.writeln('// $element');
    });
    buf.writeln(
        '// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'
        '!!!!!!!!');
    buf.writeln();
  }

  String? _generateEnumExtension() {
    buf.writeln("extension ${_enumName}Ext on $_enumName {");
    buf.writeln("");
    _podoVisitor.fields.forEach((fieldData) {
      if (_shouldBuildEnumExtensionMethod(fieldData)) {
        _generateSingleLineMethod(
            signature: '${fieldData.type} get '
                '${fieldData.name}',
            body:
                '${_podoVisitor.className}.$_valuesFieldName[this]!.${fieldData.name};');
      }
    });
    buf.writeln("}");
  }

  _generateClassesExtensions() {
    _podoVisitor.buildClassExtensionFields.keys.forEach((dartType) {
      _generateClassExtension(
        dartType,
        _podoVisitor.buildClassExtensionFields[dartType]!,
      );
      buf.writeln();
      _generateClassIterableExtension(
        dartType,
        _podoVisitor.buildClassExtensionFields[dartType]!,
      );
    });
  }

  _generateClassExtension(
    DartType dartType,
    List<FieldData> fields,
  ) {
    buf.writeln("extension $_enumName${_buildTypeLabel(dartType)}Ext on "
        "$dartType"
        " {");
    fields.forEach((field) {
      if (_valuesName != null || field.name != _kDefaultValuesFieldName) {
        _generateFieldClassExtensionWithDefaultValue(
          dartType,
          field,
        );
        buf.writeln("");
      }
    });
    buf.writeln("}");
  }

  _generateFieldClassExtensionWithDefaultValue(
    DartType dartType,
    FieldData field,
  ) {
    _generateFieldClassExtension(
      dartType,
      field,
    );
  }

  _generateFieldClassExtension(
    DartType dartType,
    FieldData field,
  ) {
    final capitalizedFieldName = field.name.capitalize();
    buf.writeln("$_enumName? "
        "to${_enumName}By$capitalizedFieldName"
        "({$_enumName? $_defaultValueVarName}) {");
    if (_checkValues) buf.writeln("$_checkValueMethodName;");
    buf.writeln("for ($_enumName element in ${_podoVisitor.className}"
        ".$_valuesFieldName.keys) {");
    if (_isAnyIterable([dartType]))
      buf.writeln("if ($_deepEqualsMethod(${_podoVisitor.className}"
          ".$_valuesFieldName[element]!.${field.name}, this)) {");
    else
      buf.writeln(
          "if (${_podoVisitor.className}.$_valuesFieldName[element]!.${field.name} == this) {");
    buf.writeln("return element;");
    buf.writeln("}");
    buf.writeln("}");
    buf.writeln("return $_defaultValueVarName;");
    buf.writeln("}");
    buf.writeln("");
  }

  _generateClassIterableExtension(
    DartType dartType,
    List<FieldData> fields,
  ) {
    buf.writeln(
        "extension $_enumName${_buildTypeLabel(dartType)}IterableExt on "
        "Iterable<$dartType> {");
    fields.forEach((field) {
      if (_valuesName != null || field.name != _kDefaultValuesFieldName) {
        _generateNullableFieldClassIterableExtension(
          field,
        );
        buf.writeln("");
        _generateFieldClassIterableExtensionWithDefaultValue(
          field,
        );
      }
    });
    buf.writeln("}");
  }

  _generateNullableFieldClassIterableExtension(
    FieldData field,
  ) {
    final capitalizedFieldName = field.name.capitalize();
    _generateSingleLineMethod(
        signature: 'List<$_enumName?> to${_enumName}By$capitalizedFieldName'
            '({$_enumName? $_defaultValueVarName})',
        body: 'List<$_enumName?>.of(map((e) => e'
            '.to${_enumName}By$capitalizedFieldName'
            '($_defaultValueVarName: $_defaultValueVarName)).toList());');
  }

  _generateFieldClassIterableExtensionWithDefaultValue(
    FieldData field,
  ) {
    final capitalizedFieldName = field.name.capitalize();
    _generateSingleLineMethod(
        signature: 'List<$_enumName> '
            'toNotNull${_enumName}By$capitalizedFieldName'
            '($_enumName $_defaultValueVarName,)',
        body: 'List<$_enumName>.of(map((e) => e'
            '.to${_enumName}By$capitalizedFieldName($_defaultValueVarName: '
            '$_defaultValueVarName)'
            ' ?? $_defaultValueVarName'
            ').toList());');
  }

  _generateDeepEquals() {
    buf.writeln('/// Make sure the collection package is imported at the '
        '"part of" file:');
    buf.writeln("/// import 'package:collection/collection.dart';");
    buf.writeln("Function $_deepEqualsMethod = const DeepCollectionEquality()"
        ".equals;");
    buf.writeln("");
  }

  _generateValuesCheck() {
    buf.writeln("$_checkValueMethodName {assert(${_podoVisitor.className}"
        ".$_valuesFieldName.length == $_enumName.values.length);}");
    buf.writeln("");
  }

  String get _checkValueMethodName => "_check${_enumName}Values()";

  String get _valuesFieldName {
    return _valuesName ?? _kDefaultValuesFieldName;
  }

  _generateSingleLineMethod({
    String? signature,
    String? body,
  }) {
    if (signature == null || body == null) return;

    if (!_checkValues) {
      buf.writeln("$signature => $body");
    } else {
      buf.writeln("$signature {");
      buf.writeln("$_checkValueMethodName;");
      buf.writeln("return $body");
      buf.writeln("}");
    }
    buf.writeln("");
  }

  static bool _shouldBuildEnumExtensionMethod(
    FieldData fieldData,
  ) =>
      !fieldData.isStatic && fieldData.enumExtension;

  static bool _isAnyIterable(Iterable<DartType> types) =>
      _isAnyList(types) || _isAnySet(types) || _isAnyMap(types);

  static bool _isAnyList(Iterable<DartType> types) =>
      types.firstWhereOrNull((element) => element.isDartCoreList) != null;

  static bool _isAnySet(Iterable<DartType> types) =>
      types.firstWhereOrNull((element) => element.isDartCoreSet) != null;

  static bool _isAnyMap(Iterable<DartType> types) =>
      types.firstWhereOrNull((element) => element.isDartCoreMap) != null;

  static String _buildTypeLabel(DartType dartType) {
    return dartType
        .toString()
        .capitalize()
        .replaceAll("<", "Of")
        .replaceAll(">", "")
        .replaceAll(",", "")
        .replaceAll(" ", "");
  }

  _reset() {
    buf.clear();
    _podoVisitor = PodoVisitor();
    _enumName = null;
    _valuesName = null;
    _checkValues = _checkValuesCompletenessDefaultValue;
  }
}

class PodoVisitor extends SimpleElementVisitor {
  DartType? className;
  List<FieldData> fields = [];

  @override
  visitConstructorElement(ConstructorElement element) {
    className = element.type.returnType;
    return super.visitConstructorElement(element);
  }

  @override
  visitFieldElement(FieldElement element) {
    fields.add(FieldData(element.name, element.type, element.isStatic));
    return super.visitFieldElement(element);
  }

  Map<DartType, List<FieldData>> get buildClassExtensionFields {
    final Map<DartType, List<FieldData>> res = {};
    fields.forEach((field) {
      if (field.classExtension && !field.type.toString().contains("Function")) {
        if (res[field.type] == null) res[field.type] = [];
        res[field.type]!.add(field);
      }
    });
    return res;
  }
}

class FieldData {
  final String name;
  final DartType type;
  final bool isStatic;
  bool? _enumExtension;
  bool? _classExtension;

  FieldData(
    this.name,
    this.type,
    this.isStatic,
  );

  bool get enumExtension => _enumExtension ?? _buildEnumExtensionDefaultValue;
  set enumExtension(bool value) => _enumExtension = value;

  bool get classExtension =>
      _classExtension ?? _buildClassExtensionDefaultValue;
  set classExtension(bool value) => _classExtension = value;
}

abstract class GeneratorForAnnotatedClass extends Generator {
  final List<Type> _annotationTypes;

  GeneratorForAnnotatedClass(
    this._annotationTypes,
  );

  _generateForAnnotatedEnum(
    Element element,
    ConstantReader annotation,
  );

  _generateForAnnotatedClass(
    Element element,
    ConstantReader annotation,
  );

  _generateForAnnotatedField(
    FieldElement field,
    ConstantReader annotation,
  );

  String _generateCode();

  @override
  String generate(LibraryReader library, BuildStep buildStep) {
    for (final element in library.allElements) {
      if (element is ClassElement) {
        final annotation = _getAnnotation(element);
        if (annotation != null) {
          if (element.isEnum)
            _generateForAnnotatedEnum(
              element,
              ConstantReader(annotation),
            );
          else
            _generateForAnnotatedClass(
              element,
              ConstantReader(
                annotation,
              ),
            );
        }

        if (!element.isEnum) {
          for (final field in element.fields) {
            final annotation = _getAnnotation(field);
            if (annotation != null) {
              _generateForAnnotatedField(
                field,
                ConstantReader(annotation),
              );
            }
          }
        }
      }
    }

    return _generateCode();
  }

  /// Returns the annotation with the given [_annotationTypes] of the given
  /// [element], or [null] if it doesn't have any.
  DartObject? _getAnnotation(Element element) {
    final List<DartObject> res = [];
    _annotationTypes.forEach((annotationType) {
      res.addAll(
          TypeChecker.fromRuntime(annotationType).annotationsOf(element));
    });
    if (res.isEmpty) {
      return null;
    }
    if (res.length > 1) {
      throw Exception("You tried to add multiple annotations to the "
          "same element (${element.name}), but that's not possible.");
    }
    return res.single;
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}
