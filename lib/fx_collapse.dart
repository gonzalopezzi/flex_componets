import 'package:polymer/polymer.dart';
import 'package:flex_components/fx_base.dart';
import 'dart:html';
import 'dart:async';

/**
 * A Polymer fx-collapse element.
 */
@CustomTag('fx-collapse')

class FxCollapse extends FxBase {

  @published bool collapsed = false;
  num contentHeight = 0;
  
  bool _flgInitiating = true;
  
  /// Constructor used to create instance of FxCollapse.
  FxCollapse.created() : super.created() {
  }
  
  @override
  void attached () {
    super.attached();
    contentHeight = ($['fx-collapse-content'] as Element).clientHeight;
    invalidateProperties ();
  }
  
  void collapsedChanged (bool oldValue) {
    invalidateProperties();
  }
  
  void _updateCollapseContainerHeight() {
    contentHeight = ($['fx-collapse-content'] as Element).clientHeight;
    if (collapsed) {
      ($['fx-collapse-container'] as Element).style.height = "0px";
    }
    else {
      ($['fx-collapse-container'] as Element).style.height = "${contentHeight}px";
    }
  }
  
  @override
  void commitProperties () {
    super.commitProperties();
    if (_flgInitiating) {
      print ("init");
      ($['fx-collapse-container'] as Element).style.transition = "none";
      _updateCollapseContainerHeight();
      new Timer(new Duration(milliseconds:200), () {
        invalidateProperties();  
        _flgInitiating = false;
      });
    }
    else {
      print ("no init");
      ($['fx-collapse-container'] as Element).style..transition = "all"
                                                   ..transitionDuration = "0.2s" 
                                                   ..transitionTimingFunction = "ease-in-out";
      _updateCollapseContainerHeight();
    }
  }
  
}
