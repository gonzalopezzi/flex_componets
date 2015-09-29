import 'package:polymer/polymer.dart';
import 'dart:html';
import 'dart:async';
import 'package:flex_components/fx_base.dart';
import 'package:animation/animation.dart' as anim;

/**
 * A Polymer fx-list element.
 */
@CustomTag('fx-list')

class FxList extends FxBase {
  
  @published List dataProvider;
  @observable List wrappedDataProvider;
  @published String labelField;
  @published String prompt = "";
  @published bool allowMultipleSelection = false;
  
  @published bool focusEnabled = true;
  
  @published dynamic selectedItem;
  @published List selectedItems = toObservable ([]);
  @published int selectedIndex = -1;
  @published List<int> selectedIndices = toObservable ([]);
  bool _selectedItemDirty = false;
  
  bool _selectedIndexAndIndicesInSync = true;
  
  @published String itemRenderer;
  
  @published bool focused = false;
  @observable int focusedIndex;
  
  @published int listHeight = 250;
  @published bool autoHeight = false;
  
  bool _flgDataProviderDirty = false;
  
  StreamSubscription keyboardStreamSubs;
  
  DivElement lstDiv;
  int scrollPosition;
  
  /// Constructor used to create instance of FxDropdownList.
  FxList.created() : super.created() {
  }
  factory FxList () => new Element.tag('fx-list');

  @override
  void attached () {
    queryLstDiv();
    lstDiv.onScroll.listen((Event event) {
      scrollPosition = lstDiv.scrollTop;
    });
    _setLstHeight();
  }
  
  void queryLstDiv () {
    lstDiv = $['lst'] as DivElement;
  }
  
  void listHeightChanged (int oldValue) {
    _setLstHeight();
  }
  
  void _setLstHeight() {
    if (lstDiv != null) {
      if(!autoHeight)
        lstDiv.style.height = "${listHeight}px";
      else
        lstDiv.style.height = "auto";
          
    }
  }
  
  void focusedChanged (bool oldValue) {
    if (!focusEnabled) {
      if (focused) {
        keyboardStreamSubs = window.onKeyDown.listen(keyDownHandler);
      }
      else {
        keyboardStreamSubs.cancel();
      }
    }
    invalidateProperties();
  }
  
  void _wrapDataProvider () {
    List<WrappedItem> wrapped = new List<WrappedItem> ();
    for (int i = 0; i < dataProvider.length; i++) {
      dynamic item = dataProvider[i];
      wrapped.add(new WrappedItem (item)..selected = false
                                        ..index = i);
    }
    _setSelectionsInWrappedDataProvider(wrapped);
    wrappedDataProvider = wrapped;
  }
  
  
  void _updateSelectedInDataProvider() {
    wrappedDataProvider.forEach((WrappedItem item) {
      item.selected = false;
    });
    _setSelectionsInWrappedDataProvider (wrappedDataProvider);
  }
  
  void _setSelectionsInWrappedDataProvider (List<WrappedItem> wrapped) {
    _syncSelectedIndexAndIndices();
    if (allowMultipleSelection) {
      selectedIndices.forEach((int i) {
        wrapped[i].selected = true;
      });
    }
    else {
      if (selectedIndex >= 0) 
        wrapped[selectedIndex].selected = true;
    }
  }
  
  void dataProviderChanged (List oldValue) {
    _flgDataProviderDirty = true;
    _selectedIndexAndIndicesInSync = false;
    invalidateProperties();
  }
  
  void selectedIndexChanged (int oldValue) {
    if (dataProvider != null && selectedIndex >= 0)
      selectedItem = dataProvider[selectedIndex];
  }
  
  void selectedItemChanged (dynamic oldValue) {
    _selectedItemDirty = true;
    _selectedIndexAndIndicesInSync = false;
    invalidateProperties();
  }
  
  void selectedItemsChanged (List oldValue) {
    _selectedItemDirty = true;
    _selectedIndexAndIndicesInSync = false;
    invalidateProperties();
  }
  
  void focusHandler (Event e) {
    focused = true;
    keyboardStreamSubs = window.onKeyDown.listen(keyDownHandler);
  }
  
  /** Flecha Abajo: 40
   *  Flecha arriba: 38
   *  Intro: 13
   */
  void keyDownHandler (KeyboardEvent event) {
    switch (event.keyCode) {
      case 40:
        event.preventDefault();
        event.stopImmediatePropagation();
        _incrementFocusedIndex();
        break;
      case 38:
        event.preventDefault();
        event.stopImmediatePropagation();
        _decrementFocusedIndex();
        break;
      case 13: 
        selectedIndex = focusedIndex;
        focusedIndex = -1;
        break;
      case 27: 
        invalidateProperties();
        break;
    }
  }
  
  void _incrementFocusedIndex () {
    if (dataProvider != null) {
      if (focusedIndex == null) {
        focusedIndex = 0;
        _updateListScrollToFocusedItem();
      }
      else if (focusedIndex < dataProvider.length -1) {
        focusedIndex++;
        _updateListScrollToFocusedItem();
      }
    }
  }
  
  void _decrementFocusedIndex () {
    if (dataProvider != null) {
      if (focusedIndex > 0) {
        focusedIndex--;
        _updateListScrollToFocusedItem();
      }
    }
  }
  
  void _updateListScrollToFocusedItem () {
    Element lst = $["lst"];
    Element item = this.shadowRoot.querySelectorAll(".item-holder")[focusedIndex];
    if (item.offsetTop < lst.scrollTop) {
      anim.animate(lst, duration:200, easing:anim.Easing.QUADRATIC_EASY_IN_OUT, 
          properties:{'scrollTop': item.offsetTop});
    }
    if ((item.offsetTop + item.clientHeight - lst.scrollTop) > lst.clientHeight) {
      anim.animate(lst, duration:200, easing:anim.Easing.QUADRATIC_EASY_IN_OUT, 
          properties:{'scrollTop': item.offsetTop - (lst.clientHeight - item.clientHeight)});
    }
  }
  
  void _updateListScrollToFocusedItemUp () {
    Element lst = $["lst"];
    Element item = this.shadowRoot.querySelectorAll(".item-holder")[focusedIndex];
    if (item.offsetTop < lst.scrollTop) {
      anim.animate(lst, duration:200, easing:anim.Easing.QUADRATIC_EASY_IN_OUT, 
          properties:{'scrollTop': item.offsetTop});
    }
  }
  
  void blurHandler (Event e) {
    focused = false;
    focusedIndex = -1;
    keyboardStreamSubs.cancel();
  }
  
  void clickItem (Event e) {
    print ("clickItem");
    int index = int.parse((e.target as Element).dataset['index']);
    if (allowMultipleSelection) {
      if (selectedIndices.contains(index)) {
        selectedIndices.remove(index);        
        selectedItems.remove(dataProvider[index]);
      }
      else {
        selectedIndices.add(index);
        if(selectedItems == null){
            selectedItems = toObservable ([]);
        }
        selectedItems.add(dataProvider[index]);
      }
      
      fire("selection-change", detail: selectedItems);
    }
    else {
      if (selectedIndex != index) {
        selectedIndex = index;
        selectedItem = dataProvider[index];
        fire("selection-change", detail: selectedItem);
      }
      
      
    }
    
   
  }
  
  bool isIndexSelected (int index, List<int> selectedIndices) {
    return selectedIndices.contains(index);
  }
  
  void _syncSelectedIndexAndIndices () {
    if (!_selectedIndexAndIndicesInSync) {
      if (allowMultipleSelection) {
        selectedIndices.clear();
      }
      else {
        selectedIndex = -1;
      }
      for (int i = 0; i < dataProvider.length; i++) {
        dynamic item = dataProvider[i];
        if (allowMultipleSelection) {
          if (selectedItems != null && selectedItems.contains(item)) {
            selectedIndices.add(i);
          }
        }
        else {
          if (item == selectedItem) {
            selectedIndex = i;
          }
        }
      }
      _selectedIndexAndIndicesInSync = true;
    }
  }
  
  @override 
  void commitProperties () {
    super.commitProperties();
    if (_flgDataProviderDirty) {
      _wrapDataProvider();
      _flgDataProviderDirty = false;
    }
    if (_selectedItemDirty) {
      _syncSelectedIndexAndIndices();
      _updateSelectedInDataProvider();
      _selectedItemDirty = false;
    }
  }
  
  String render (dynamic value) {
    String rendered = "";
    if (value is String) {
      rendered = renderString (value);
    }
    if (value is Map) {
      rendered = renderMap (value);
      if (labelField != null)
        rendered = value[labelField];
    }
    else { // Object
      rendered = renderObject (value);
    }
    return rendered;
  }
  
  String renderString (String value) {
    return value;
  }
  
  String renderMap (Map value) {
    if (labelField != null) {
      return value[labelField];
    }
    else {
      return "$value";
    }
  }
  
  String renderObject (Object value) {
    return "$value";
  }
  
}

class WrappedItem extends Observable {
  dynamic listItem;
  @observable int index;
  @observable bool selected;
  WrappedItem (this.listItem);
}
