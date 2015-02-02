library fx_base;

import 'package:polymer/polymer.dart';
import 'dart:html';

class FxBase extends PolymerElement {
  
  bool _propertiesDirty = false;
  
  FxBase.created() : super.created() {
  }
  
  void invalidateProperties () {
    _propertiesDirty = true;
    window.requestAnimationFrame((_) {
      commitProperties();
    });
  }
  
  void commitProperties () {
    _propertiesDirty = false;
  }
  
}