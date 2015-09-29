import 'package:polymer/polymer.dart';
import 'package:flex_components/fx_base.dart';
import 'dart:html';

@CustomTag('fx-button')
class FxButton extends FxBase {

  @published String label;
  @observable bool pressed = false;
  @published String type;
  @published bool enabled = true;
  @published bool toggle = false;
  
  /// Constructor used to create instance of FxButton.
  FxButton.created() : super.created() {
  }
  factory FxButton () => new Element.tag('fx-button');
  
  @override
  void enabledChanged () {
    invalidateProperties();
  }
  
  void mouseDownHandler (Event e) {
    if(toggle)
      pressed = !pressed;
    else
      pressed = true;
  }
  
  void mouseUpHandler (Event e) {
    if(!toggle)
      pressed = false;
  }
  
  @override
  void commitProperties () {
    super.commitProperties();
  }
  
}
