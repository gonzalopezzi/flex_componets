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
  
  bool _tagAdded = false;
  bool _dataHasChanged = true;

  PolymerElement attachedPolymerElement;
  
  /// Constructor used to create instance of FxItemRenderer.
  FxItemRenderer.created() : super.created() {
  }
  
  void dataChanged (dynamic oldValue) {
    _dataHasChanged = true;
    _render ();
  }
  
  void tagChanged (String oldValue) {
    _saveTag();
    _render ();
  }

  
  void _saveTag() {
    if (tag != null && tag != "") {
      attachedPolymerElement = new Element.tag(tag);
    }
  }
  
  @override
  void attached () {
    _saveTag();
    _render();
  }
  
  void _render () {
    if (!_tagAdded && attachedPolymerElement != null) {
      ($['mainFxItemRendererContent'] as DivElement).children.add(attachedPolymerElement);
      _tagAdded = true;
    }
    if (_tagAdded && _dataHasChanged) {
      (attachedPolymerElement as DataRenderer).data = data;
      _dataHasChanged = false;
    }
  }
  
}
