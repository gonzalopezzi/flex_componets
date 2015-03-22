import 'package:polymer/polymer.dart';
import 'package:flex_components/fx_base.dart';

@CustomTag('fx-block')
class FxBlock extends FxBase {
  
  @published int xsCols = 12;
  @published int smCols;
  @published int mdCols;
  @published int lgCols;
  
  @observable bool extraSmall = true;
  @observable bool small = false;
  @observable bool medium = false;
  @observable bool large = false;
  
  FxBlock.created() : super.created() {
  }
  
  void smallChanged   (bool oldValue) => invalidateProperties();
  void mediumChanged  (bool oldValue) => invalidateProperties();
  void largeChanged   (bool oldValue) => invalidateProperties();
  
  @override
  void attached () {
    invalidateProperties();
  }
  
  @override
  void commitProperties () {
    super.commitProperties();
    List<int> colSizes = [xsCols, smCols, mdCols, lgCols];
    List<bool> sizes = [extraSmall, small, medium, large];
    bool size = false;
    int i = sizes.length - 1;
    while ((!size) && (i >= 0)) {
      size = sizes[i];
      if (!size) i--;
    }
    int colSize;
    int j = i;
    while ((colSize == null) && (j >= 0)) {
      colSize = colSizes[j];
      if (colSize == null) j--;
    }
    this.style.width = "${100.0 * colSize/12}%";
  }
}
