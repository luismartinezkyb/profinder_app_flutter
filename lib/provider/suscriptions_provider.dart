import 'package:flutter/material.dart';

class SuscriptionsProvider with ChangeNotifier {
  bool? _suscribed;
  SuscriptionsProvider({bool? index}) {
    _suscribed = index;
  }

  getSuscription() => this._suscribed == null ? false : this._suscribed;

  // getWidgetIfLoading() {
  //   return _loading ? CircularProgressIndicator() : null;
  // }

  setIndex(bool checa) {
    this._suscribed = checa;
    print('cambiamos la suscription a $checa');
    notifyListeners();
  }
}
