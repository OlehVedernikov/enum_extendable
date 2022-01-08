Annotations for **enum_extendable_generator**.\
This package does nothing without [enum_extendable_generator](https://pub.dev/packages/enum_extendable_generator).

### **Annotations**

#### **ExtendableEnum**
The enum should be annotated with `ExtendableEnum`.\
It's a mandatory annotation.

#### **ExtendableEnumPodo**
Use 'ExtendableEnumPodo' to annotate the PODO class of your enum.'
It's the second mandatory annotation.

#### **ExtendableEnumValues**
The map of values (PODO instances by enum values) should be annotated with `ExtendableEnumValues`.\
This annotation can be omitted, if the name of this field is `values`.\
There is one parameter `bool checkCompleteness`. If the value of this parameter is `true` an [assert](https://dart.dev/guides/language/language-tour#assert) statement is generated to make sure that all enum items are in the `values` map. It can be useful when a new item is added into the enum.\
The default value of `checkCompleteness` is `true`.

#### **ExtendableEnumField**
Any field of the PODO class can be annotated with `ExtendableEnumField`. This annotation is optional and can be used to determinate extensions nomenclature. It has two parameters:
- `bool enumExtension` - set `false` if you **don't** want to generate a
method for this field at the extension on enum.\
The default value is `true`.
- `bool classExtension` - set `false` if you **don't** want to generate
methods for a class (and Iterable of this class) of this field.\
The default value is `true`.