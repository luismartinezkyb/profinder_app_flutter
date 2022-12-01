import 'package:flutter/material.dart';

class ChangingIndexScreen with ChangeNotifier {
  int? _index;
  ChangingIndexScreen({int? index}) {
    _index = index;
  }

  getIndex() => this._index;

  // getWidgetIfLoading() {
  //   return _loading ? CircularProgressIndicator() : null;
  // }

  setIndex(int checa) {
    this._index = checa;
    print('cambiamos de pagina a la $checa');
    notifyListeners();
  }
}
