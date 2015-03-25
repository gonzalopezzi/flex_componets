import 'package:polymer/polymer.dart';
import 'package:flex_components/fx_base.dart';

@CustomTag('fx-row')
class FxRow extends FxBase {
  @published bool verticalFit = false;
  
  FxRow.created() : super.created() {
  }
  
}
