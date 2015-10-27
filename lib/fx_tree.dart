import 'package:polymer/polymer.dart';
import 'package:flex_components/fx_list.dart';
import 'package:flex_components/flex_components.dart';
import 'dart:html';

/**
 * A Polymer fx-tree element.
 */
@CustomTag('fx-tree')
class FxTree extends FxList {

  @published dynamic selectedMultipleItems;
  
  /// Constructor used to create instance of FxTree.
  FxTree.created() : super.created() {
  }
  factory FxTree () => new Element.tag('fx-tree');
  
  @override
  void attached () {
    super.attached();
    this.addEventListener("selection-change", selectionChangeHandler);
    
    selectedItems = toObservable(new List());
  }
  
  
  selectedMultipleItemsChanged(dynamic valor){
      this.selectedItems = selectedMultipleItems;
      
      if(selectedItems != null){
        selectedItems.forEach((TreeNode tn) {
          _agregarSeleccionados(tn);
        });     
      }
  }
  
  
  
  void queryLstDiv () {
    lstDiv = $['treeLst'] as DivElement;
  }
  
  void selectionChangeHandler (CustomEvent e) {
    this.selectedItem = e.detail;  //monoseleccion
    
    if(selectedItem != null && selectedItem is Selectable)
      selectedItem.selected = !selectedItem.selected;
    //updateSelectedItems();  
    
    selectedItem is TreeNode && selectedItem.selected == true ? _agregarSeleccionados(selectedItem) : _eliminarSeleccionados(selectedItem);
    
    fire("selected-items-change", detail: selectedItems);
  }
  
 
  
  /*
  updateSelectedItems(){
    selectedItems = toObservable(new List());
    
    
   dataProvider.forEach((dynamic tn) {
      if(tn is Selectable && tn.selected)
        selectedItems.add(tn);
    });
  } 
  */
  
  void _eliminarSeleccionados(TreeNode nodo){
     (nodo as Selectable).selected = false;
     selectedItems.remove(nodo);
     if(nodo.children!=null &&  !nodo.children.isEmpty){
        List children = nodo.children;
        children.forEach((c)=>_eliminarSeleccionados(c));          
      }        
  }
  
  void _agregarSeleccionados(TreeNode nodo){
     if(!selectedItems.contains(nodo)){        
       if(nodo.children!=null && !nodo.children.isEmpty){
                List children = nodo.children;
                children.forEach((c)=>_agregarSeleccionados(c));          
              }
       (nodo as Selectable).selected = true;
       selectedItems.add(nodo);   
     }    
  }
  
  
  
  
  
  @override
  void clickItem (Event e) {
    print("eo");
    /*int index = int.parse((e.target as Element).dataset['index']);
    selectedIndex = index;
    selectedItem = dataProvider[index];
    fire("selection-change", detail: selectedItem);*/
  }
  
}
