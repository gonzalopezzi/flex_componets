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
  @published dynamic value = 0;
  @observable String datatipValue = "";
  @published num maxValue = 100;
  @published num minValue = 0;
  @published num stepSize = 0;
  
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
  
  void valueChanged (dynamic oldValue) {
    if (value is String) {
      value = num.parse(value);
    }
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
    if (stepSize > 0) {
      value = minValue + ((value - minValue) / stepSize).round() * stepSize;
    }
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
  
  num _convertPixelValueToValue (num pixelValue) {
    return (pixelValue / _pixelWidth) * (maxValue - minValue) + minValue;
  }
  
  num _convertValueToPixelValue (num val) {
    return ((val - minValue) / (maxValue - minValue)) * _pixelWidth;
  }
  
  void trackEndHandler (Event e) {
    dragging =  false;
    _hideDatatip();
    _updateDragInitX();
    value = _convertPixelValueToValue (_pixelValue);
    invalidateProperties();
  }
  
  void _updateDataTipValue () {
    datatipValue = "${((_pixelValue / _pixelWidth) * (maxValue - minValue) + minValue).round()}";
  }
  
  void trackHandler (Event e, var detail, Node target) {
    var touchEvent = new JsObject.fromBrowserObject(e);
    if (stepSize > 0) {
      _flgAnimate = true;
      num prevPixelValue = _pixelValue;
      
      _pixelValue = dragInitX + touchEvent['dx'];
      num val = _convertPixelValueToValue(_pixelValue);
      val = minValue + ((val - minValue) / stepSize).round() * stepSize;
      _pixelValue = _convertValueToPixelValue(val);
      if (prevPixelValue != _pixelValue) {
        invalidateDisplay();
      }
    }
    else {
      _pixelValue = dragInitX + touchEvent['dx'];
      invalidateDisplay();
    }
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
    _pixelValue = _convertValueToPixelValue (value);
    _pixelValue = _restrictToMaxMin (_pixelValue);
    invalidateDisplay();
  }
  
  @override
  void updateDisplay () {
    super.updateDisplay();
    _pixelValue = _restrictToMaxMin(_pixelValue);
    _updateDataTipValue();
    if (_flgAnimate) {
      anim.animate(_thumb, duration:100, properties: {'left': _pixelValue});
      anim.animate(_sliderFill, duration:100, properties: {'width': _pixelValue});
      _flgAnimate = false;
    }
    else {
      _thumb.style.left = "${_pixelValue}px"; 
      _sliderFill.style.width = "${_pixelValue}px";
    }
  }
  
}
