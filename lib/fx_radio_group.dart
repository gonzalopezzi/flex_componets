import 'package:polymer/polymer.dart';
import 'package:flex_components/fx_base.dart';
import 'package:flex_components/fx_radio_button.dart';
import 'dart:html';

@CustomTag('fx-radio-group')
class FxRadioGroup extends FxBase {

  @published dynamic value;
  List<Element> currentChildren;
  bool _flgChildrenDirty = false;
  
  /// Constructor used to create instance of FxRadioGroup.
  FxRadioGroup.created() : super.created() {
  }
  
  void valueChanged (dynamic oldValue) {
    invalidateProperties();
  }

  @override
  void attached () {
    super.attached();
    _syncChildren();
    _flgChildrenDirty = true;
    invalidateProperties();
  }
  
  void _syncChildren () {
    List<Element> elements = new List<Element> ();
    NodeList nodeList = (this.shadowRoot.querySelector('content') as ContentElement).getDistributedNodes();
    nodeList.forEach ((dynamic el) {
      if (!(el is Text)) {
        elements.add(el);
      }
    });
    this.currentChildren = elements;    
  }
  
  void selectionHandler (dynamic val) {
    value = val;
    invalidateProperties();
  }
  
  @override
  void commitProperties () {
    try {
      super.commitProperties();
      if (_flgChildrenDirty) {
        if (currentChildren != null && currentChildren.length > 0) {
          currentChildren.forEach((Element e) {
            if (e is FxRadioButton) {
              e.onSelection.listen (selectionHandler);
            }
          });
        }
      }
      if (currentChildren != null && currentChildren.length > 0) {
        currentChildren.forEach((Element e) {
          if (e is FxRadioButton) {
            e.selected = e.value == this.value;
          }
        });
      }
    }
    catch (e, stacktrace) {
      print (e);
      print (stacktrace);
    }
  }
    
}
