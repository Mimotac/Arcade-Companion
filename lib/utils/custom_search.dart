import 'package:fuzzy/data/result.dart';
import 'package:fuzzy/fuzzy.dart';

class CustomSearch {
  static List<Result<String>> defineSearch(
      String filterValue, List<String>? list) {
    final FuzzyOptions<String> fuseOption =
        FuzzyOptions(matchAllTokens: true, tokenize: true, threshold: 0.0);
    final Fuzzy<String> searcher = Fuzzy(list, options: fuseOption);
    final List<Result<String>> results = searcher.search(filterValue);
    return results;
  }
}
