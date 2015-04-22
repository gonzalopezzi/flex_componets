import 'package:polymer/polymer.dart';
import 'dart:html';
import 'package:flex_components/fx_base.dart';
import 'dart:async';

@CustomTag('fx-radio-button')
class FxRadioButton extends FxBase {
  
  @published String text;
  @published bool selected = false;
  @published dynamic value;
  
  StreamController selectionDispatcher = new StreamController.broadcast();
  Stream get onSelection => selectionDispatcher.stream;
  
  FxRadioButton.created() : super.created() {
  }
  
  void selectedChanged (bool oldValue) {
    invalidateProperties();
  }
  
  @override
  void attached () {
    invalidateProperties();
  }
  
  void clickHandler (MouseEvent e) {
    selectionDispatcher.add(value);
  }
  
  @override
  void commitProperties () {
    super.commitProperties();
    Element radioSelection = ($['fx-radio-selection'] as Element);
    Element label = ($['fx-radio-button-label'] as Element);
    radioSelection.style.visibility = selected ? "visible" : "hidden";
    if (selected) {
      label.classes.add("fx-radio-button-selected-label");
    }
    else {
      label.classes.remove("fx-radio-button-selected-label");
    }
    
  }
}
