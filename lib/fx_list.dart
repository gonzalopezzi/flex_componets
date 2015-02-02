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
  @published String labelField;
  @published String prompt = "";
  
  @published bool focusEnabled = true;
  
  @published dynamic selectedItem;
  @published int selectedIndex = -1;
  bool _selectedItemDirty = false;
  
  @published String itemRenderer;
  
  @published bool focused = false;
  @observable int focusedIndex;
  
  StreamSubscription keyboardStreamSubs;
  
  /// Constructor used to create instance of FxDropdownList.
  FxList.created() : super.created() {
  }
  factory FxList () => new Element.tag('fx-list');

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
  
  void dataProviderChanged (List oldValue) {
    invalidateProperties;
  }
  
  void selectedIndexChanged (int oldValue) {
    if (dataProvider != null && selectedIndex >= 0)
      selectedItem = dataProvider[selectedIndex];
  }
  
  void selectedItemChanged (dynamic oldValue) {
    _selectedItemDirty = true;
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
    Element lst = $["list"];
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
    Element lst = $["list"];
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
    selectedIndex = index;
    selectedItem = dataProvider[index];
    fire("selection-change", detail: selectedItem);
  }
  
  @override 
  void commitProperties () {
    super.commitProperties();
    Element listDiv = $['list'] as Element;
    if (_selectedItemDirty) {
      List<Element> lst = this.shadowRoot.querySelectorAll(".item-holder");
      for (int i = 0; i < dataProvider.length; i++) {
        dynamic item = dataProvider[i];
        if (item == selectedItem) {
          selectedIndex = i;
        }
      }
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
