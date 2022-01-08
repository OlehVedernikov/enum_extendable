extension StringExt on String {
  ///Returns a list of splitted substrings including [dividers].
  List<String> splitWithDividers(Iterable<String> dividers) {
    if (isEmpty) return [];

    String notProcessed = this;
    final List<String> result = [];
    do {
      final String? firstDivider = notProcessed.findFirstOfSubstrings(dividers);
      if (firstDivider == null) {
        result.add(notProcessed);
        notProcessed = "";
      } else {
        final int startIndex = notProcessed.indexOf(firstDivider);
        result.add(notProcessed.substring(0, startIndex));
        result.add(firstDivider);
        notProcessed = notProcessed.substring(startIndex + firstDivider.length);
      }
    } while (notProcessed.isNotEmpty);

    return result;
  }

  ///Returns a substring with the lowest index, or null if there are not any
  ///substring.
  ///
  ///A substring with the minimum length will be returned if there are several
  ///substrings with the same index.
  ///
  ///Empty substrings are ignored.
  String? findFirstOfSubstrings(Iterable<String> substrings) {
    final sorted = [...substrings];
    sorted.sort((a, b) {
      if (a.length == b.length) return 0;
      return (a.length > b.length ? 1 : -1);
    });

    int minIndex = this.length;
    String? result;
    sorted.forEach((element) {
      if (element.isNotEmpty) {
        final int index = this.indexOf(element);
        if (index >= 0 && index < minIndex) {
          minIndex = index;
          result = element;
        }
      }
    });
    return result;
  }
}
