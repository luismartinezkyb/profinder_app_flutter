import 'package:flutter/material.dart';

import '../settings/style_settings.dart';

class LoadingProvider with ChangeNotifier {
  bool? _loading;
  LoadingProvider({bool? loading}) {
    _loading = loading;
  }

  getIfLoading() => this._loading;

  // getWidgetIfLoading() {
  //   return _loading ? CircularProgressIndicator() : null;
  // }

  setIfLoading(bool checa) {
    this._loading = checa;
    notifyListeners();
  }
}
