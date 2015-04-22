import 'package:polymer/polymer.dart';
import 'package:flex_components/fx_base.dart';
import 'package:intl/intl.dart';
import 'dart:html';
import 'package:animation/animation.dart' as anim;

@CustomTag('fx-label')
class FxLabel extends FxBase {
  
  static final int HEIGHT = 30;
  
  @published dynamic text;
  @published NumberFormat numberFormat;
  @observable String formattedText;

  bool _flgAttached;
  
  FxLabel.created() : super.created() {
  }
  
  void numberFormatChanged (NumberFormat oldValue) {
    invalidateProperties();
  }
  
  void textChanged (dynamic oldValue) {
    invalidateProperties ();
  }
  
  void attached () {
    _flgAttached = true;
    invalidateProperties ();
  }
  
  void commitProperties () {
    super.commitProperties();
    formattedText = (numberFormat != null ? numberFormat.format(text) : "$text");
    if (_flgAttached) {
      ($['label-commited-value'] as DivElement).text = formattedText;
      _flgAttached = false;
    }
    else {
      ($['label-new-value'] as DivElement).text = formattedText;
      new anim.AnimationQueue ()
                  ..addAll([
                    new anim.ElementAnimation (this)
                          ..duration = 200
                          ..properties = {'scrollTop': HEIGHT}
                          ..easing = anim.Easing.QUADRATIC_EASY_IN_OUT
                          ..onComplete.listen((_) {
                            ($['label-commited-value'] as DivElement).text = formattedText;
                            this.scrollTop = 0;
                          })
                  ])
                  ..run();
    }
    
  }
  
}
