import 'package:polymer/polymer.dart';

/**
 * A Polymer fx-tab-navigator element.
 */
@CustomTag('fx-tab-navigator')

class FxTabNavigator extends PolymerElement {

  @published int selectedIndex;
  
  /// Constructor used to create instance of FxTabNavigator.
  FxTabNavigator.created() : super.created() {
  }
  
}
