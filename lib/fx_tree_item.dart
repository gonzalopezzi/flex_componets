import 'package:polymer/polymer.dart';
import 'dart:html';
import 'package:flex_components/flex_components.dart';
import 'package:animation/animation.dart' as anim;

/**
 * A Polymer fx-tree-item element.
 */
@CustomTag('fx-tree-item')
class FxTreeItem extends PolymerElement {
  
  final int SPACER_WIDTH = 40;

  @published dynamic value; //el valor de este nodo
  @published String itemRenderer;
  @observable bool seleccionado = false;
  
  @published dynamic selectedItem; //el valor de todo el tree seleccionado en mono seleccion
  @published dynamic selectedItems; 
  
  
  @published int level = 0;
  @observable bool deployed = false;
  
  /// Constructor used to create instance of FxTreeItem.
  FxTreeItem.created() : super.created() {
  }
  factory FxTreeItem () => new Element.tag('fx-tree-item');
  
  void treeItemClick (Event e, dynamic detail) {    
    fire("selection-change", detail: this.value, canBubble: true);
  }
  
  /*
  selectedItemsChanged(dynamic items){
    if(value != null)
      print("---");         
       print("Yo " + this.value.name + " " + this.value.selected.toString());
    
    if(items != null && items is List){
      selectedItems.forEach((TreeNode tn) {
        print(tn.name + " " + tn.selected.toString());
      });
    }
  }
  */
  
  void selectedItemsChanged([_]){
      var i = 0;
      bool found = false;
      
      if(selectedItems != null){
        while(i < selectedItems.length && !found){
          found = selectedItems.elementAt(i) == value;
           i++;       
        }
      }
      seleccionado = found;
    }
  
  void toggleDeployed (Event e) {
    e.stopImmediatePropagation();
    e.preventDefault();
    deployed = !deployed;
  }
  
  void levelChanged (int oldValue) {
    ($['spacer'] as Element).style.width = '${SPACER_WIDTH * level}px';
  }
  
  int getChildHeight () {
    return (shadowRoot.querySelectorAll('fx-tree-item')[0] as Element).clientHeight;
  }
  
  void deployedChanged (bool oldValue) {
    if (isTreeNode(value)) {
      if (deployed) {
        int childHeight = getChildHeight();
        anim.animate($['treeItemLst'] as Element, duration:200, easing:anim.Easing.QUADRATIC_EASY_IN_OUT, 
                  properties:{'height': childHeight * (value as TreeNode).children.length } ).onComplete.listen((_) => ($['treeItemLst'] as Element).style.setProperty("height",  "auto"));
      }
      else {
        anim.animate($['treeItemLst'] as Element, duration:200, easing:anim.Easing.QUADRATIC_EASY_IN_OUT, 
         properties:{'height': 0 } );
        
      }
      
    }
  }
  
  //bool isTreeNode (dynamic value) => value is TreeNode;
  
  bool isTreeNode (dynamic value) {
    bool response= false;
    if(value is TreeNode){
      response = (value as TreeNode).children != null && (value as TreeNode).children.length > 0; 
    }
    return response;
  }
  
  String render(dynamic item) => "$item";
  
}
