library flex_componentes.sample.fx_sample_panel;

import 'package:polymer/polymer.dart';
import 'dart:html';
import 'package:flex_components/flex_components.dart';

/**
 * A Polymer fx-sample-panel element.
 */
@CustomTag('fx-sample-panel')

class FxSamplePanel extends PolymerElement {

  @published String texto;
  
  FxSamplePanel.created() : super.created() {
  }
  factory FxSamplePanel () => new Element.tag("fx-sample-panel");

  void closeThisPanel (Event e) {
    PopUpManager.removePopUp (this);
  }
}
