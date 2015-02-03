// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:polymer/polymer.dart';
import 'dart:html';
import 'package:flex_components/flex_components.dart';
import 'package:flex_components/sample/fx_sample_panel.dart';

/// A Polymer `<main-app>` element.
@CustomTag('main-app')
class MainApp extends PolymerElement {
  @observable DateTime selectedDate = new DateTime.now();

  @observable List productCategories = toObservable ([
                                            {'id':1, 'name':'Appliances'},
                                            {'id':2, 'name':'Apps & Games'},
                                            {'id':3, 'name':'Automotive'},
                                            {'id':4, 'name':'Baby'},
                                            {'id':5, 'name':'Beauty'},
                                            {'id':6, 'name':'Books'},
                                            {'id':7, 'name':'Cellphones'}]);
  
  @observable List productCategoriesObject = toObservable ([
                                            new ProductCategory (1, 'Appliances'),
                                            new ProductCategory (2, 'Apps & Games'),
                                            new ProductCategory (3, 'Automotive'),
                                            new ProductCategory (4, 'Baby'),
                                            new ProductCategory (5, 'Beauty'),
                                            new ProductCategory (6, 'Books'),
                                            new ProductCategory (7, 'Cellphones')]);
  
  @observable ProductCategory selectedProductCategory;
  @observable List<ProductCategory> selectedProductCategories;
  
  @observable List<Country> stores = toObservable ([
                                       (new Country ('ES', 'Spain'))
                                            ..regions = toObservable ([
                                                            new Region ("R01", "North")
                                                                ..stores = toObservable ([
                                                                     new Store(1, "Food for you"),
                                                                     new Store(2, "Market Me"),
                                                                     new Store(3, "Super Precio")
                                                               ]),
                                                            new Region ("R02", "South")
                                                              ..stores = toObservable ([
                                                                             new Store(1, "Food for you"),
                                                                             new Store(2, "Market Me"),
                                                                             new Store(3, "Super Precio")
                                                                       ])
                                                        ]),
                                       (new Country ('UK', 'United Kingdom'))
                                           ..regions = toObservable ([
                                                         new Region ("R01", "North")
                                                            ..stores = toObservable ([
                                                                            new Store(4, "Fruit King"),
                                                                            new Store(5, "Supermarket Now")
                                                                       ])
                                                      ])
                                   ]);
  
  @observable dynamic selectedTreeItem;
  
  /// Constructor used to create instance of MainApp.
  MainApp.created() : super.created();
  
  void alertChange (CustomEvent e) {
    //window.alert("Change: ${e.detail}");
  }
  
  void openModalPopup () {
    FxSamplePanel fxSamplePanel = new FxSamplePanel();
    fxSamplePanel.style.setProperty("width", "300px");
    fxSamplePanel.style.setProperty("height", "400px");
    PopUpManager.addPopUp (fxSamplePanel, modal:true); 
  }
  
  void openPopup (MouseEvent event) {
    int top = event.client.y;
    int left = event.client.x;
    FxSamplePanel fxSamplePanel = new FxSamplePanel();
    fxSamplePanel.style.setProperty("width", "400px");
    fxSamplePanel.style.setProperty("height", "400px");
    PopUpManager.addPopUp (fxSamplePanel, modal:false, top:top, left:left); 
  }

}

class Country implements TreeNode {
  String code;
  String name;
  List<Region> regions;
  
  Country (this.code, this.name);
  
  List<dynamic> get children => regions;
  
  @override
  String toString () => "$name";
}

class Region implements TreeNode {
  String code;
  String name;
  List<Store> stores;
  
  Region (this.code, this.name);
  
  List<dynamic> get children => stores;
  
  @override
  String toString () => "$name";
}

class Store {
  int code;
  String name;
  
  Store (this.code, this.name);
  
  @override
  String toString () => "$name";
}

class ProductCategory {
  int id; 
  String name;
  
  ProductCategory (this.id, this.name);
  
  String toString () {
    return "$name";
  }
}
