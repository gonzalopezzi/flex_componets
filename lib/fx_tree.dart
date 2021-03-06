import 'package:polymer/polymer.dart';
import 'package:flex_components/fx_list.dart';
import 'dart:html';

/**
 * A Polymer fx-tree element.
 */
@CustomTag('fx-tree')
class FxTree extends FxList {

  String _lstId = "lst";
  
  /// Constructor used to create instance of FxTree.
  FxTree.created() : super.created() {
  }
  factory FxTree () => new Element.tag('fx-tree');
  
  @override
  void attached () {
    super.attached();
    this.addEventListener("selection-change", selectionChangeHandler);
  }
  
  void queryLstDiv () {
    lstDiv = $['treeLst'] as DivElement;
  }
  
  void selectionChangeHandler (CustomEvent e) {
    this.selectedItem = e.detail;
  }
  
  @override
  void clickItem (Event e) {
    /*int index = int.parse((e.target as Element).dataset['index']);
    selectedIndex = index;
    selectedItem = dataProvider[index];
    fire("selection-change", detail: selectedItem);*/
  }
  
}
