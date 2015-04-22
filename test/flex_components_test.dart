library flex_components.test;

import 'package:unittest/unittest.dart';
import 'dart:html';
import 'package:unittest/html_config.dart';
import 'dart:async';
import 'package:polymer/polymer.dart';

import 'package:flex_components/fx_button.dart';
import 'package:flex_components/fx_dropdown_list.dart';
/*export 'package:polymer/init.dart';*/

void main() {
  initPolymer();
  useHtmlConfiguration();
  
  List productCategories = toObservable ([
                            {'id':1, 'name':'Appliances'},
                            {'id':2, 'name':'Apps & Games'},
                            {'id':3, 'name':'Automotive'},
                            {'id':4, 'name':'Baby'},
                            {'id':5, 'name':'Beauty'},
                            {'id':6, 'name':'Books'},
                            {'id':7, 'name':'Cellphones'}]);
  
  FxButton fxButton;
  Function fxButtonClickHandler = (MouseEvent me) {
    expect (me.target, fxButton);
  };
  
  FxDropdownList fxDropdownList;
  
  setUp(() {
    /* fx-button */
    fxButton = createElement(r'<fx-button label="Button Test"></fx-button>');
    fxButton.onClick.listen(fxButtonClickHandler);
    
    /* fx-dropdown-list */
    fxDropdownList = createElement (r'<fx-dropdown-list prompt="Select a category"' +
                                    r'selectedItem="{{selectedProductCategory}}" ' + 
                                    r'listHeight="150" labelField="name" ' +
                                    r'on-selection-change="{{alertChange}}"></fx-dropdown-list>');
    fxDropdownList.dataProvider = productCategories;
    
  });
  
  test ('fx-button initialization', () {
    expect (fxButton, isNotNull);
    expect (fxButton, new isInstanceOf<FxButton>());
    expect (fxButton.shadowRoot.querySelector("#mainButton"), isNotNull);
    expect (fxButton.shadowRoot.querySelector("#btnContent").text.trim(), "Button Test");
    fxButton.click();
  });
  
  test ('fx-dropdown-list init', () async {
    bool selectionHasChanged = false;
    expect (fxDropdownList, isNotNull);
    expect (fxDropdownList, new isInstanceOf<FxDropdownList>());
    fxDropdownList.addEventListener("selection-change", (_) {
      selectionHasChanged = true;
    });
    fxDropdownList.shadowRoot.querySelector("#placeholder").click();
    expect(fxDropdownList.shadowRoot.querySelector("#fxlst").classes.contains("deployed"), false);
    await new Future.delayed(new Duration(milliseconds:400));
    expect(fxDropdownList.shadowRoot.querySelector("#fxlst").classes.contains("deployed"), true);
    await new Future.delayed(new Duration(milliseconds:400));
    var item = fxDropdownList.shadowRoot.querySelector("#fxlst").shadowRoot.querySelectorAll(".item-holder")[0];
    expect (item, isNotNull);
    // Simulate click
    (item as Element).dispatchEvent(new MouseEvent("click"));
    expect (selectionHasChanged, true);
  });
}

createElement(String html) => new Element.html(html, treeSanitizer: new NullTreeSanitizer()); 
class NullTreeSanitizer implements NodeTreeSanitizer { 
  void sanitizeTree(node) {} 
}

