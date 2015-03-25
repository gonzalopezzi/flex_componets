import 'package:polymer/polymer.dart';
import 'package:flex_components/fx_base.dart';
import 'package:flex_components/fx_row.dart';
import 'dart:html';

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
  
  @observable bool verticalFit = false;
  
  FxRow fxRow = null;
  
  FxBlock.created() : super.created() {
  }
  
  void smallChanged   (bool oldValue) => invalidateProperties();
  void mediumChanged  (bool oldValue) => invalidateProperties();
  void largeChanged   (bool oldValue) => invalidateProperties();
  
  @override
  void attached () {
    invalidateProperties();
    if (this.parent is FxRow) {
      fxRow = (this.parent as FxRow);
      verticalFit = fxRow.verticalFit;
    }
    else {
      throw new ArgumentError("fx-block must by a child of fx-row");
    }
  }
  
  num computeColSize () {
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
    return colSize;
  }
  
  num get contentHeight => ($['fx-block-content'] as Element).clientTop + ($['fx-block-content'] as Element).clientHeight;
  
  void backToRelative () {
    this.style.position = "relative";
    this.style.top     = "0";
    this.style.bottom  = "0";
    $['fx-block-content'].style.position = "relative";
    $['fx-block-content'].style.top     = "0";
    $['fx-block-content'].style.bottom  = "0";
    $['fx-block-content'].style.left    = "0";
    $['fx-block-content'].style.right   = "0";
  }
  
  @override
  void commitProperties () {
    super.commitProperties();
    int colSize = computeColSize();
    this.style.width = "${100.0 * colSize / 12}%";
    if (verticalFit) {
      Element fxBlockContent = this.shadowRoot.querySelector("#fx-block-content");
      
      this.style.position = "absolute";
      this.style.top     = "0";
      this.style.bottom  = "0";
      fxBlockContent.style.position = "absolute";
      fxBlockContent.style.top     = "10px";
      fxBlockContent.style.bottom  = "10px";
      fxBlockContent.style.left    = "10px";
      fxBlockContent.style.right   = "10px";
      List<Element> blocks = fxRow.children;
      bool found = false;
      int i = 0;
      FxBlock block;
      num leftAccum = 0;
      while (!found && i < blocks.length) {
        block = blocks[i];
        found = block == this;
        if (!found) {
          leftAccum += block.computeColSize();
          i++;
        }
      }
      if (leftAccum >= 12) { 
        // Vertical fit cannot be applied,  all children will go position:initial again
        fxRow.children.forEach((FxBlock e) {
          e.backToRelative();
        });
      }
      this.style.left = "${100.0 * (leftAccum % 12) / 12}%";
    }
  }
}
