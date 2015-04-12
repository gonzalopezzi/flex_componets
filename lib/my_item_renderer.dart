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
  
}
