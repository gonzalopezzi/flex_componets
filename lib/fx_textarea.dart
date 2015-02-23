import 'package:polymer/polymer.dart';

/**
 * A Polymer fx-textarea element.
 */
@CustomTag('fx-textarea')

class FxTextarea extends PolymerElement {

  @published String text;
  
  /// Constructor used to create instance of FxTextarea.
  FxTextarea.created() : super.created() {
  }
}
