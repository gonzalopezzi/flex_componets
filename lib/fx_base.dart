library fx_base;

import 'package:polymer/polymer.dart';
import 'dart:html';

class FxBase extends PolymerElement {
  
  bool _propertiesDirty = false;
  bool _displayDirty = false;
  
  
  
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
  
  void invalidateDisplay () {
    if (!_displayDirty) {
      _displayDirty = true;
      window.animationFrame.then((_) { updateDisplay(); });
    }
  }
  
  void updateDisplay () {
    _displayDirty = false;
  }
  
}