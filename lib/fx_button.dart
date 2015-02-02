import 'package:polymer/polymer.dart';
import 'dart:html';

/**
 * A Polymer fx-button element.
 */
@CustomTag('fx-button')

class FxButton extends PolymerElement {

  @published String label;
  @observable bool pressed;
  @published String type;
  
  /// Constructor used to create instance of FxButton.
  FxButton.created() : super.created() {
  }
  factory FxButton () => new Element.tag('fx-button');
  
  void mouseDownHandler (Event e) {
    pressed = true;
  }
  
  void mouseUpHandler (Event e) {
    pressed = false;
  }
  
}
