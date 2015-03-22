import 'package:polymer/polymer.dart';
import 'dart:html';
import 'package:flex_components/fx_base.dart';
import 'dart:async';

@CustomTag('fx-accordion-element')
class FxAccordionElement extends FxBase {
  
  @published bool showScroller = true;
  @observable bool displayScroller = true;
  @published String label = "";
  
  StreamController _accordionElementSelectDispatcher = new StreamController.broadcast();
  
  FxAccordionElement.created() : super.created() {
  }
  factory FxAccordionElement () => new Element.tag("fx-accordion-element");
  
  Stream get onAccordionElementSelect => _accordionElementSelectDispatcher.stream;
  
  void showScrollerChanged (bool oldValue) {
    displayScroller = showScroller;
    invalidateProperties();
  }
  
  void headerClickHandler (MouseEvent event) {
    _accordionElementSelectDispatcher.add({'target':this});
  }
  
  @override
  void commitProperties () {
    super.commitProperties();
    
    if (!showScroller) {
      ($['fx-accordion-content'] as Element).style.overflowY = 'hidden';
    }
    else {
      if (displayScroller) {
        ($['fx-accordion-content'] as Element).style.overflowY = 'auto';
      }
      else {
        ($['fx-accordion-content'] as Element).style.overflowY = 'hidden';
      }
    }
  }
  
}
