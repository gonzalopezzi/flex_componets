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

  num _pixelValue = 30;
  num _pixelWidth = 0;
  @published num value = 0;
  @published num maxValue = 100;
  @published num minValue = 0;
  
  @observable bool dragging = false;
  
  @observable int dragInitX = 0;
  
  StreamSubscription windowMouseUpSubs;
  StreamSubscription windowMouseMoveSubs;
  
  Element _thumbGraph;
  Element _thumb;
  Element _sliderFill;
  Element _mainDiv;
  
  int _mainDivOffsetX = 0;
  
  /// Constructor used to create instance of FxSlider.
  FxSlider.created() : super.created() {
  }
  
  void valueChanged (num oldValue) {
    invalidateProperties();
  }
  
  void maxValueChanged (num oldValue) {
    invalidateProperties ();
  }
  
  void minValueChanged ( num oldValue) {
    invalidateProperties();
  }
  
  @override
  void attached () {
    _thumbGraph = $['slider-thumb-graphic'];
    _thumb = $['slider-thumb'];
    _sliderFill = $['slider-fill'];
    _mainDiv = $['main-div'];
    _pixelWidth = _mainDiv.client.width;
    
    this.onMouseDown.listen((_) {
      _updateDragInitX();
    });
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
    value = (_pixelValue / _pixelWidth) * (maxValue - minValue) + minValue;
    invalidateProperties();
  }
  
  void trackHandler (Event e, var detail, Node target) {
    var touchEvent = new JsObject.fromBrowserObject(e);
    _pixelValue = dragInitX + touchEvent['dx'];
    invalidateDisplay();
  }
  
  num _restrictToMaxMin (num pixelValue) {
    if (pixelValue < 0) 
      return 0;
    else if (pixelValue > _pixelWidth) 
      return _pixelWidth;
    else 
      return pixelValue;
  }
  
  @override commitProperties () {
    super.commitProperties();
    _pixelValue = ((value - minValue) / (maxValue - minValue)) * _pixelWidth;
    _pixelValue = _restrictToMaxMin (_pixelValue);
    invalidateDisplay();
  }
  
  @override
  void updateDisplay () {
    super.updateDisplay();
    _pixelValue = _restrictToMaxMin(_pixelValue);
    _thumb.style.left = "${_pixelValue}px"; 
    _sliderFill.style.width = "${_pixelValue}px";
  }
  
}
