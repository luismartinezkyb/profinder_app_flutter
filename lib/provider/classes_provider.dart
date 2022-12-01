import 'package:flutter/material.dart';

class ClassProvider with ChangeNotifier {
  String? _search;
  ClassProvider({String? search}) {
    _search = search;
  }

  getSearch() => this._search;

  // getWidgetIfLoading() {
  //   return _loading ? CircularProgressIndicator() : null;
  // }

  setSearch(String newSearch) {
    this._search = newSearch;
    print('query actualizada a $newSearch');
    notifyListeners();
  }
}
