import 'package:polymer/polymer.dart';
import 'dart:html';
import 'dart:async';
import 'package:flex_components/fx_base.dart';
import 'dart:js';
import 'package:animation/animation.dart' as anim;

/**
 * A Polymer fx-slider element.
 */
@CustomTag('fx-slider')

class FxSlider extends FxBase {

  num _pixelValue = 30;
  num _pixelWidth = 0;
  @published num value = 0;
  @observable String datatipValue = "";
  @published num maxValue = 100;
  @published num minValue = 0;
  
  @observable bool dragging = false;
  
  @observable int dragInitX = 0;
  
  StreamSubscription windowMouseUpSubs;
  StreamSubscription windowMouseMoveSubs;
  
  Element _thumbGraph;
  Element _thumb;
  Element _sliderFill;
  Element _sliderDataTip;
  Element _mainDiv;
  
  int _mainDivOffsetX = 0;
  
  bool _flgAnimate = false;
  
  /// Constructor used to create instance of FxSlider.
  FxSlider.created() : super.created() {
  }
  
  void valueChanged (num oldValue) {
    _flgAnimate = true;
    _updateDataTipValue();
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
    _sliderDataTip = $['slider-datatip'];
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
  
  void trackClickHandler (MouseEvent e) {
    value = minValue + (e.offset.x / _pixelWidth) * (maxValue - minValue);
  }
  
  void _showDatatip () {
    _sliderDataTip.style.opacity = "1";
  }
  
  void _hideDatatip () {
    _sliderDataTip.style.opacity = "0";
  }
  
  void trackStartHandler (Event e) {
    dragging = true;
    _showDatatip();
    _updateDragInitX ();
  }
  
  void trackEndHandler (Event e) {
    dragging =  false;
    _hideDatatip();
    _updateDragInitX();
    value = (_pixelValue / _pixelWidth) * (maxValue - minValue) + minValue;
    invalidateProperties();
  }
  
  void _updateDataTipValue () {
    datatipValue = "${((_pixelValue / _pixelWidth) * (maxValue - minValue) + minValue).round()}";
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
    _updateDataTipValue();
    if (_flgAnimate) {
      anim.animate(_thumb, duration:200, properties: {'left': _pixelValue});
      anim.animate(_sliderFill, duration:200, properties: {'width': _pixelValue});
      _flgAnimate = false;
    }
    else {
      _thumb.style.left = "${_pixelValue}px"; 
      _sliderFill.style.width = "${_pixelValue}px";
    }
  }
  
}
