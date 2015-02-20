import 'package:polymer/polymer.dart';
import 'dart:html';
import 'dart:async';
import 'package:flex_components/fx_base.dart';
import 'dart:js';

/**
 * A Polymer fx-slider element.
 */
@CustomTag('fx-slider')

class FxSlider extends FxBase {

  @observable num pixelValue = 30;
  @published num value = 0;
  
  @observable bool dragging = false;
  
  @observable int dragInitX = 0;
  
  StreamSubscription windowMouseUpSubs;
  StreamSubscription windowMouseMoveSubs;
  
  Element _thumbGraph;
  Element _thumb;
  Element _mainDiv;
  
  int _mainDivOffsetX = 0;
  
  /// Constructor used to create instance of FxSlider.
  FxSlider.created() : super.created() {
  }
  
  @override
  void attached () {
    _thumbGraph = $['slider-thumb-graphic'];
    _thumb = $['slider-thumb'];
    _mainDiv = $['main-div'];
    
    this.onMouseDown.listen((_) {
      _updateDragInitX();
    });
    
    /*
    _thumbGraph.onMouseDown.listen((_) {
      dragging = true;
      windowMouseUpSubs = window.onMouseUp.listen((_) {
        dragging = false;
        windowMouseUpSubs.cancel();
        windowMouseMoveSubs.cancel();
      });
      windowMouseMoveSubs = this.onMouseMove.listen((MouseEvent event) {
        if (dragging) {
          if (event.currentTarget == this) {
            pixelValue = event.offset.x;
            _thumb.style.transform = "translate(${pixelValue}px, 0px)";
          }
        }
      });
    });
    */
  }
  
  void _updateDragInitX () {
    if (_thumb.style.left != null && _thumb.style.left != "") { 
      String leftStr = _thumb.style.left;
      dragInitX = num.parse(leftStr.substring(0, leftStr.length -2)).toInt();
    }
  }
  
  void trackStartHandler (Event e) {
    dragging = true;
    _updateDragInitX ();
  }
  
  void trackEndHandler (Event e) {
    dragging =  false;
    _updateDragInitX();
  }
  
  void trackHandler (Event e, var detail, Node target) {
    var touchEvent = new JsObject.fromBrowserObject(e);
    pixelValue = dragInitX + touchEvent['dx'];
    invalidateDisplay();
  }
  
  @override
  void updateDisplay () {
    super.updateDisplay();
    _thumb.style.left = "${pixelValue}px"; 
  }
  
}
