import 'package:polymer/polymer.dart';
import 'dart:html';
import 'dart:js';
import 'package:browser_detect/browser_detect.dart';

@CustomTag('fx-resize-aware')
class FxResizeAware extends PolymerElement {

  JsObject defaultView;
  
  FxResizeAware.created() : super.created() {
  }
  
  void resizeHandler (var functionThis) {
    this.fire("resize");
  }

  attached() {
    super.attached();
    var resizeDetectorObject = new JsObject.fromBrowserObject($['resize-detector']);
    if (browser.isIe || browser.isFirefox) {
      async ((_) {
        resizeDetectorObject['data'] = 'about:blank';
      });
    }
  }
  
  void loaded (Event e) {
    var resizeDetectorObject = new JsObject.fromBrowserObject(e.target);
    defaultView = resizeDetectorObject['contentDocument']['defaultView'] as JsObject;
    defaultView.callMethod('addEventListener', ['resize', resizeHandler]);  
  }
}
