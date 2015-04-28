import 'package:polymer/polymer.dart';
import 'package:flex_components/fx_base.dart';
import 'dart:html';

@CustomTag('fx-button')
class FxButton extends FxBase {

  @published String label;
  @observable bool pressed;
  @published String type;
  @published bool enabled = true;
  
  /// Constructor used to create instance of FxButton.
  FxButton.created() : super.created() {
  }
  factory FxButton () => new Element.tag('fx-button');
  
  @override
  void enabledChanged () {
    invalidateProperties();
  }
  
  void mouseDownHandler (Event e) {
    pressed = true;
  }
  
  void mouseUpHandler (Event e) {
    pressed = false;
  }
  
  @override
  void commitProperties () {
    super.commitProperties();
  }
  
}
