# Enum Extendable Example
The example of usage of the Enum Extendable package.
## Overview
Calculates the value of the expression inputted at the command line.\
Only numbers and operators `+`, `-`, `*`, `/` are allowed.\
Run `bin/main.dart` to launch the project.
## Enum example
See [example.dart](lib/example.dart) as an example of an enum with it
PODO class.\
The `example.enum_extendable.g.dart` file is generated.
**Note:** The `isHighPriority` is annotated with `@ExtendableEnumField
(classExtension: false)` to avoid generation of the specific methods at the extension on the
`bool` class since the enum value can't be taken from value of this field
(two enum values have the same value).