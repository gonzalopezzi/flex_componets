import 'package:polymer/polymer.dart';

/**
 * A Polymer fx-panel element.
 */
@CustomTag('fx-panel')

class FxPanel extends PolymerElement {

  @published String title;
  @published String footer;
  
  /// Constructor used to create instance of FxPanel.
  FxPanel.created() : super.created() {
  }
    
}
