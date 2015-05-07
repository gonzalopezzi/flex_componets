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

  List<num> _pixelValue = toObservable([0, 0]);
  @published dynamic value; /* The user can set a String, int or List (with two items) */
  @observable List<num> computedValue = toObservable([0, 0]);
  @observable List<String> datatipValue = toObservable(["", ""]);
  @published num maxValue = 100;
  @published num minValue = 0;
  @published num stepSize = 0;
  @published bool animateStepSize = true;
  @published bool doubleThumb = false;
  @published bool showSliderFill = true;
  
  @published Function dataTipFormatter = (num dataTipValue) => "$dataTipValue";
  
  @observable List<bool> dragging = toObservable([false, false]);
  
  @observable int dragInitX = 0;
  
  StreamSubscription windowMouseUpSubs;
  StreamSubscription windowMouseMoveSubs;
  
  Element _thumb0;
  Element _thumb1;
  Element _sliderFill;
  Element _sliderDataTip0;
  Element _sliderDataTip1;
  Element _mainDiv;
  
  bool _flgAnimate = false;
  
  FxSlider.created() : super.created() {
  }
  
  num parseValue (dynamic val) {
    if (val is String) {
      return num.parse(val);
    }
    return (val as num);
  }
  
  void valueChanged (dynamic oldValue) {
    if (value is List) {
      if (!doubleThumb) {
        throw new ArgumentError("If doubleThumb is false, value should be a num");
      }
      computedValue[0] = parseValue(value[0]);
      computedValue[1] = parseValue(value[1]);
    }
    else {
      if (doubleThumb) {
        throw new ArgumentError("If doubleThumb is true, value should be a List<num> with two elements. Example: [120, 240]");
      }
      dynamic newValue = value;
      computedValue = toObservable([minValue, minValue]);
      computedValue[1] = parseValue(newValue);
    }
    _flgAnimate = true;
    _updateDataTipValue();
    invalidateProperties();
  }
  
  void computedValueChanged (List oldValue) {
    if (doubleThumb) {
      value = computedValue;
    }
    else {
      value = computedValue[1];
    }
  }
  
  void maxValueChanged (num oldValue) {
    invalidateProperties ();
  }
  
  void minValueChanged ( num oldValue) {
    invalidateProperties();
  }
  
  @override
  void attached () {
    _thumb0 = $['slider-thumb-0'];
    _thumb1 = $['slider-thumb-1'];
    _sliderFill = $['slider-fill'];
    _sliderDataTip0 = $['slider-datatip-0'];
    _sliderDataTip1 = $['slider-datatip-1'];
    _mainDiv = $['main-div'];
    
    _thumb0.onMouseDown.listen(mouseDownHandler);
    _thumb1.onMouseDown.listen(mouseDownHandler);
  }
  
  num get _pixelWidth => _mainDiv.client.width;
  
  void mouseDownHandler (Event e) {
    int index = _dragIndexByTarget(e.target);
    if (index >= 0) {
      dragging[index] = true;
      _updateDragInitX();
    }
  }
  
  void _updateDragInitX () {
    Element thumb = _dragIndex == 0 ? _thumb0 : _thumb1;
    if (thumb.style.left != null && thumb.style.left != "") { 
      String leftStr = thumb.style.left;
      dragInitX = (num.parse(leftStr.substring(0, leftStr.length - "%".length)) / 100 * _pixelWidth).round();
    }
  }
  
  int _findClosestThumb (num mouseX) {
    if (!doubleThumb) {
      return 1;
    }
    else {
      num dist0 = (mouseX - _pixelValue[0]).abs();
      num dist1 = (mouseX - _pixelValue[1]).abs();
          
      if (dist0 < dist1) 
        return 0;
      else 
        return 1;
    }
  }
  
  void trackClickHandler (MouseEvent e) {
    num mouseX = (e.offset.x + (e.target as Element).offsetLeft);
    int index = _findClosestThumb (mouseX);
    num val = minValue + (mouseX / _pixelWidth) * (maxValue - minValue);
    if (stepSize > 0) {
      val = minValue + ((val - minValue) / stepSize).round() * stepSize;
    }
    computedValue[index] = val;
  }
  
  void _showDatatip () {
    Element sliderDataTip = _dragIndex == 0 ? _sliderDataTip0 : _sliderDataTip1;
    sliderDataTip.style.opacity = "1";
  }
  
  void _hideDatatip () {
    Element sliderDataTip = _dragIndex == 0 ? _sliderDataTip0 : _sliderDataTip1;
    sliderDataTip.style.opacity = "0";
  }
  
  int _dragIndexByTarget (Element target) {
    if (target.id == "circle-0")
      return 0;
    else if (target.id == "circle-1")
      return 1;
    else 
      return -1;
  }
  
  void trackStartHandler (Event e) {
    int index = _dragIndexByTarget(e.target);
    if (index >= 0) {
      dragging[_dragIndexByTarget(e.target)] = true;
      _showDatatip();
      _updateDragInitX ();
    }
  }
  
  num _convertPixelValueToValue (num pixelValue) {
    return (pixelValue / _pixelWidth) * (maxValue - minValue) + minValue;
  }
  
  num _convertValueToPixelValue (num val) {
    return ((val - minValue) / (maxValue - minValue)) * _pixelWidth;
  }
  
  void trackEndHandler (Event e) {
    if (_dragIndex >= 0) {
      _hideDatatip();
      _updateDragInitX();
      computedValue[_dragIndex] = _convertPixelValueToValue (_pixelValue[_dragIndex]);
      dragging[0] =  false;
      dragging[1] =  false;
      invalidateProperties();
    }
  }
  
  void _updateDataTipValue () {
    datatipValue[0] = dataTipFormatter(((_pixelValue[0] / _pixelWidth) * (maxValue - minValue) + minValue).round());
    datatipValue[1] = dataTipFormatter(((_pixelValue[1] / _pixelWidth) * (maxValue - minValue) + minValue).round());
  }
  
  int get _dragIndex => dragging[0] ? 0 : dragging[1] ? 1 : -1;
  
  void _doTrackHandlerByStepSize(num dx) {
    if (animateStepSize)
      _flgAnimate = true;
    
    num prevPixelValue = _pixelValue[_dragIndex];
    
    _pixelValue[_dragIndex] = dragInitX + dx;
    num val = _convertPixelValueToValue(_pixelValue[_dragIndex]);
    val = minValue + ((val - minValue) / stepSize).round() * stepSize;
    _pixelValue[_dragIndex] = _convertValueToPixelValue(val);
    if (prevPixelValue != _pixelValue[_dragIndex]) {
      invalidateDisplay();
    }
  }
  
  void _doTrackHandlerNormal (num dx) {
    _pixelValue[_dragIndex] = dragInitX + dx;
    invalidateDisplay();
  }
  
  bool _trackHandlerTargetOk () => _dragIndex >= 0; 
  
  void trackHandler (Event e, var detail, Node target) {
    var touchEvent = new JsObject.fromBrowserObject(e);
    num dx = touchEvent['dx'];
    if (_trackHandlerTargetOk ()) {
      if (stepSize > 0) {
        _doTrackHandlerByStepSize (dx);
      }
      else {
        _doTrackHandlerNormal (dx);
      }
    }
  }
  
  List<num> _calculatePixelRestrictions (int index) {
    num restrictMin = 0;
    num restrictMax = _pixelWidth;
    if (index == 1) {
      restrictMin = _pixelValue[0];
    }
    if (index == 0) {
      restrictMax = _pixelValue[1];
    }
    return [restrictMin, restrictMax];
  }
  
  num _restrictToMaxMin (num pixelValue, int index) {
    List<num> restrictions = _calculatePixelRestrictions (index);
    num restrictMin = restrictions[0];
    num restrictMax = restrictions[1];
    
    if (pixelValue < restrictMin) 
        return restrictMin;
    else if (pixelValue > restrictMax)  
      return restrictMax;
    else 
      return pixelValue;
  }
  
  @override commitProperties () {
    super.commitProperties();
    _pixelValue[0] = _convertValueToPixelValue (computedValue[0]);
    _pixelValue[1] = _convertValueToPixelValue (computedValue[1]);
    _pixelValue[0] = _restrictToMaxMin (_pixelValue[0], 0);
    _pixelValue[1] = _restrictToMaxMin (_pixelValue[1], 1);
    invalidateDisplay();
  }
  
  void _applyPixelValueRestrictions (int dragIndex) {
    if (dragIndex == 0) {
      _pixelValue[0] = _restrictToMaxMin(_pixelValue[0], 0);
      _pixelValue[1] = _restrictToMaxMin(_pixelValue[1], 1);
    }
    else {
      _pixelValue[1] = _restrictToMaxMin(_pixelValue[1], 1);
      _pixelValue[0] = _restrictToMaxMin(_pixelValue[0], 0);
    }
  }
  
  @override
  void updateDisplay () {
    super.updateDisplay();
    _applyPixelValueRestrictions (_dragIndex);
    _updateDataTipValue();
    if (_flgAnimate) {
      anim.animate(_thumb0, duration:100, properties: {'left': "${_pixelValue[0]/_pixelWidth*100}%"});
      anim.animate(_thumb1, duration:100, properties: {'left': "${_pixelValue[1]/_pixelWidth*100}%"});
      anim.animate(_sliderFill, duration:100, properties: {'margin-left': "${_pixelValue[0]/_pixelWidth*100}%"});
      anim.animate(_sliderFill, duration:100, properties: {'width': "${(_pixelValue[1] - _pixelValue[0])/_pixelWidth*100}%"});
      _flgAnimate = false;
      
    }
    else {
      _thumb0.style.left = "${_pixelValue[0]/_pixelWidth*100}%";
      _thumb1.style.left = "${_pixelValue[1]/_pixelWidth*100}%"; 
      _sliderFill.style.marginLeft = "${_pixelValue[0]/_pixelWidth*100}%";
      _sliderFill.style.width = "${(_pixelValue[1] - _pixelValue[0])/_pixelWidth*100}%";
    }
  }
  
}
