import 'package:collection/collection.dart';
import 'package:example/extensions.dart';
import 'package:test/test.dart';

void main() {
  Function listEquals = const ListEquality().equals;

  group('StringExt', () {
    test(
        'the splitWithDividers method should return the list of strings that contains splitted parts of the source string and dividers as well',
        () {
      expect(listEquals('a b'.splitWithDividers([' ']), ['a', ' ', 'b']), true);
      expect(listEquals('a b '.splitWithDividers([' ']), ['a', ' ', 'b', ' ']),
          true);
      expect(
          listEquals(
              'a1b2c'.splitWithDividers(['1', '2']), ['a', '1', 'b', '2', 'c']),
          true);
    });

    test(
        'the splitWithDividers method should return empty list if source string is empty',
        () {
      expect(''.splitWithDividers([' ']).isEmpty, true);
    });

    test(
        'the splitWithDividers method should return a list with a single element (source) if the source does not contain any divider',
        () {
      expect(listEquals('abc'.splitWithDividers([' ']), ['abc']), true);
    });

    test(
        'the findFirstOfSubstrings method should return the substring with the lowest index in the source string and minimum length if indexes are equals',
        () {
      expect('aabb'.findFirstOfSubstrings(['ab', 'aa', 'bb']), 'aa');
      expect('aabb'.findFirstOfSubstrings(['ab', 'aa', 'a', 'bb']), 'a');
    });

    test('the findFirstOfSubstrings method should ignore empty substrings', () {
      expect('aabb'.findFirstOfSubstrings(['ab', 'aa', 'a', 'bb', '']), 'a');
    });

    test(
        'the findFirstOfSubstrings method should return null when the source string does not contain any substring',
        () {
      expect('abc'.findFirstOfSubstrings(['aa', 'bb']), null);
    });
  });
}
