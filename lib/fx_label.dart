import 'package:polymer/polymer.dart';
import 'package:flex_components/fx_base.dart';

@CustomTag('fx-label')
class FxLabel extends FxBase {
  
  @published String text;
  
  FxLabel.created() : super.created() {
  }
  
}
