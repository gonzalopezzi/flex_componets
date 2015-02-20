import 'package:polymer/polymer.dart';
import 'dart:html';
import 'dart:async';
import 'package:flex_components/fx_base.dart';
import 'package:browser_detect/browser_detect.dart';

/**
 * A Polymer fx-dropdown-list element.
 */
@CustomTag('fx-dropdown-list')

class FxDropdownList extends FxBase {
  
  @published List dataProvider;
  @published String labelField;
  @published String prompt = "";
  @published int listHeight = 150;
  
  @observable bool deployed = false;
  
  @published dynamic selectedItem;
  @published int selectedIndex = -1;
  bool _selectedItemDirty = false;
  
  @published String itemRenderer;
  
  @observable bool focused = false;
  @observable int focusedIndex;
  
  StreamSubscription keyboardStreamSubs;
  
  /// Constructor used to create instance of FxDropdownList.
  FxDropdownList.created() : super.created() {
  }
  factory FxDropdownList () => new Element.tag('fx-dropdown-list');

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
  
  void toggleDeployed (Event e) {
    e.stopImmediatePropagation();
    this.deployed = !deployed;
    print ("toggleDeployed. Deployed: $deployed");
    invalidateProperties();
  }
  
  void focusHandler (Event e) {
    print("focusHandler");
    focused = true;
    keyboardStreamSubs = window.onKeyDown.listen(keyDownHandler);
  }
  
  /** Arrow key down: 40
   *  Arrow key up: 38
   *  Intro: 13
   */
  void keyDownHandler (KeyboardEvent event) {
    switch (event.keyCode) {
      case 40:
        if (!deployed) {
          deployed = true;
          invalidateProperties();
        }
        break;
      case 27: 
        deployed = false;
        invalidateProperties();
        break;
    }
  }
  
  void blurHandler (Event e) {
    focused = false;
    if (deployed && !browser.isIe) {
      deployed = false;
      invalidateProperties();
    }
    keyboardStreamSubs.cancel();
  }
  
  void clickItem (Event e) {
    print ("clickItem");
    int index = int.parse((e.target as Element).dataset['index']);
    selectedIndex = index;
    selectedItem = dataProvider[index];
    fire("selection-change", detail: selectedItem);
  }
  
  void onSelectionChangeHandler (Event e) {
    fire("selection-change", detail: selectedItem);
  }
  
  @override 
  void detached() {
    super.detached();
    window.removeEventListener("click", windowClickHandler);
  }
  
  @override 
  void commitProperties () {
    print ("CommitProperties Dropdown");
    super.commitProperties();
    Element listDiv = $['fxlst'] as Element;
    if (_selectedItemDirty) {
      List<Element> lst = this.shadowRoot.querySelectorAll(".item-holder");
      if (selectedItem == null) {
        selectedIndex = -1;
      }
      else {
        for (int i = 0; i < dataProvider.length; i++) {
          dynamic item = dataProvider[i];
          if (item == selectedItem) {
            selectedIndex = i;
          }
        }
      }
      _selectedItemDirty = false;
    }
    if (deployed) {
      print ("Deployed!");
      listDiv.classes.add('deployed');
      listDiv.scrollTop = 0;
      window.addEventListener("click", windowClickHandler);
    }
    else {
      print ("Undeployed!");
      listDiv.classes.remove('deployed');
      window.removeEventListener("click", windowClickHandler);
    }
  }
  
  void windowClickHandler (Event e) {
    if (this.deployed) { 
      print ("windowClickHandler. Deployed: $deployed");
      this.deployed = false;
      invalidateProperties();
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
