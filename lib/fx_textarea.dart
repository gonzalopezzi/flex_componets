import 'package:polymer/polymer.dart';
import 'dart:html';

/**
 * A Polymer fx-textarea element.
 */
@CustomTag('fx-textarea')

class FxTextarea extends PolymerElement {

  @published String text;
  @published bool readonly;
  @observable bool focused = false;
  
  /// Constructor used to create instance of FxTextarea.
  FxTextarea.created() : super.created() {
  }
  
  void focusHandler (Event e) {
    focused = true;
  }
  
  void blurHandler (Event e) {
    focused = false;
  }
}
