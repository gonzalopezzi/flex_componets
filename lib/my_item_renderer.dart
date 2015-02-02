import 'package:polymer/polymer.dart';
import 'dart:html';
import 'package:flex_components/flex_components.dart';

/**
 * A Polymer my-item-renderer element.
 */
@CustomTag('my-item-renderer')

class MyItemRenderer extends PolymerElement implements DataRenderer {
  
  @published dynamic data;

  /// Constructor used to create instance of MyItemRenderer.
  MyItemRenderer.created() : super.created() {
  }
  factory MyItemRenderer () => new Element.tag('my-item-renderer');

  /*
   * Optional lifecycle methods - uncomment if needed.
   *

  /// Called when an instance of my-item-renderer is inserted into the DOM.
  attached() {
    super.attached();
  }

  /// Called when an instance of my-item-renderer is removed from the DOM.
  detached() {
    super.detached();
  }

  /// Called when an attribute (such as  a class) of an instance of
  /// my-item-renderer is added, changed, or removed.
  attributeChanged(String name, String oldValue, String newValue) {
  }

  /// Called when my-item-renderer has been fully prepared (Shadow DOM created,
  /// property observers set up, event listeners attached).
  ready() {
  }
   
  */
  
}
