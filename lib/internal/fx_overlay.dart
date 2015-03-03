import 'package:polymer/polymer.dart';
import 'dart:html';
import 'dart:async';

/**
 * A Polymer fx-overlay element.
 */
@CustomTag('fx-overlay')

class FxOverlay extends PolymerElement {

  @observable bool isAttached = false;
  @published Element content;
  
  /// Constructor used to create instance of FxOverlay.
  FxOverlay.created() : super.created() {
  }
  factory FxOverlay () => new Element.tag('fx-overlay');
  
  void overlayClickHandler (Event e) {
    /*PopUpManager.removePopUp(content);*/ //TODO: Do we want the popup to be closed when clicking the overlay???
  }
  
  Future performCloseAnimation () {
    isAttached = false;
    Completer completer = new Completer();
    new Timer(new Duration(milliseconds: 800), () {
      completer.complete();
    });
    return completer.future;
  }
  
  void contentChanged (Element oldContent) {
    ($['contentDiv'] as Element).children.clear();
    ($['contentDiv'] as Element).children.add(content);
  }
  
  attached () {
    new Timer(new Duration(milliseconds: 200), () {
      isAttached = true;
    });
    if (content != null) {
      ($['contentDiv'] as Element).children.add(content);
    }
  }
  
  detached () {
    isAttached = false;
  }
}
