import 'package:polymer/polymer.dart';
import 'dart:html';

/**
 * A Polymer fx-panel element.
 */
@CustomTag('fx-panel')

class FxPanel extends PolymerElement {

  /// Constructor used to create instance of FxPanel.
  FxPanel.created() : super.created() {
  }
  
  @override
  void attached () {
    super.attached();
    /*
    Element panelFooter = this.querySelector('fx-panel-footer');
    if (panelFooter != null) { 
      this.children.remove(panelFooter);
      ($['footer'] as Element).children.add(panelFooter);
    }
    Element panelTitle = this.querySelector('fx-panel-title');
    if (panelTitle != null) { 
      this.children.remove(panelTitle);
      ($['title'] as Element).children.add(panelTitle);
    }
    */
  }
    
}
