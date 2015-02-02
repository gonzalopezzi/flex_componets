import 'package:polymer/polymer.dart';
import 'dart:html';
import 'package:flex_components/flex_components.dart';

/**
 * A Polymer fx-item-renderer element.
 */
@CustomTag('fx-item-renderer')

class FxItemRenderer extends PolymerElement {

  @published String tag;
  @published dynamic data;

  PolymerElement attachedPolymerElement;
  
  /// Constructor used to create instance of FxItemRenderer.
  FxItemRenderer.created() : super.created() {
  }
  
  void dataChanged (dynamic oldValue) {
    (attachedPolymerElement as DataRenderer).data = data;
  }

  
  @override
  void attached () {
    if (tag != null && tag != "") {
      attachedPolymerElement = new Element.tag(tag);
      (attachedPolymerElement as DataRenderer).data = data;
      ($['mainContent'] as DivElement).children.add(attachedPolymerElement);
    }
  }
  
}
