// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:polymer/polymer.dart';
import 'dart:html';
import 'package:flex_components/flex_components.dart';
import 'package:flex_components/sample/fx_sample_panel.dart';
import 'package:quiver/core.dart';

/// A Polymer `<main-app>` element.
@CustomTag('main-app')
class MainApp extends PolymerElement {
  @observable DateTime selectedDate = new DateTime.now();

  @observable List productCategories = toObservable ([
                                            {'id':1, 'name':'Appliances', 'department':'Tech'},
                                            {'id':2, 'name':'Apps & Games', 'department':'Tech'},
                                            {'id':3, 'name':'Automotive', 'department':'Tech'},
                                            {'id':4, 'name':'Baby', 'department':'Home'},
                                            {'id':5, 'name':'Beauty', 'department':'Home'},
                                            {'id':6, 'name':'Books', 'department':'Home'},
                                            {'id':7, 'name':'Cellphones', 'department':'Tech'}]);
  
  @observable List productCategoriesFiltered = toObservable ([
                              {'id':5, 'name':'Appliances', 'department':'Tech'},
                              {'id':6, 'name':'Apps & Games', 'department':'Tech'},
                              {'id':7, 'name':'Automotive', 'department':'Tech'}]);
  
  @observable List productCategoriesDatagrid;
  
  @observable List productCategoriesObject = toObservable ([
                                            new ProductCategory (1, 'Appliances'),
                                            new ProductCategory (2, 'Apps & Games'),
                                            new ProductCategory (3, 'Automotive'),
                                            new ProductCategory (4, 'Baby'),
                                            new ProductCategory (5, 'Beauty'),
                                            new ProductCategory (6, 'Books'),
                                            new ProductCategory (7, 'Cellphones')]);
  
  @observable List otherProductCategoriesObject = toObservable ([
                                            new ProductCategory (8,  'Garden'), 
                                            new ProductCategory (9,  'Sports'),
                                            new ProductCategory (10, 'Travel'),
                                            new ProductCategory (11, 'Lifestyle'),
                                            new ProductCategory (12, 'Toys and enterntainment')
                                            ]);
  
  @observable List tabDropDownProductCategoriesObject;
  @observable List tabSingleSelectProductCategoriesObject;
  @observable List tabMultiSelectProductCategoriesObject;
  
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
  
  @observable List<num> sliderValue = [300,500];
  @observable Function sliderDataTipFormatter = (num val) => "${val}";
  
  @observable String textAreaText = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Suspendisse eleifend dignissim sodales. Donec id ex ut sapien egestas dictum. In finibus tristique risus et rhoncus. Suspendisse potenti. Aenean tristique felis ut lectus porta, eu tincidunt erat commodo. Maecenas laoreet metus ac mattis eleifend. Duis nisi sem, maximus in nisl at, vestibulum tincidunt odio. Aliquam non leo ut ligula feugiat facilisis. Donec hendrerit rutrum elit. In hac habitasse platea dictumst.";
  
  @observable int viewStackSelectedIndex = 0;
  
  @observable List<Album> albums = toObservable([
              new Album("12 x 5", "http://akamai-b.cdn.cddbp.net/cds/2.0/cover/615F/84D5/EA9C/843D_medium_front.jpg?cid=12102912"),
              new Album("England's newest hit makers", "http://akamai-b.cdn.cddbp.net/cds/2.0/cover/3727/8931/13A9/094E_medium_front.jpg?cid=12102912"),
              new Album("The Rolling Stones", "http://akamai-b.cdn.cddbp.net/cds/2.0/cover/0152/A0F0/1611/E72D_medium_front.jpg?cid=12102912"),
              new Album("December's Children", "http://akamai-b.cdn.cddbp.net/cds/2.0/cover/9ED9/DFD6/CE0D/564F_medium_front.jpg?cid=12102912"),
              new Album("Out of our heads", "http://akamai-b.cdn.cddbp.net/cds/2.0/cover/4C15/4899/3F51/CB33_medium_front.jpg?cid=12102912"),
              new Album("The Rolling Stones, Now!", "http://akamai-b.cdn.cddbp.net/cds/2.0/cover/7D9C/4267/17B2/58E8_medium_front.jpg?cid=12102912"),
              new Album("Aftermath", "http://akamai-b.cdn.cddbp.net/cds/2.0/cover/D7E4/45CB/ACAB/0D8A_medium_front.jpg?cid=12102912"),
              new Album("Between the Buttons", "http://akamai-b.cdn.cddbp.net/cds/2.0/cover/A49B/705A/5411/1EA0_medium_front.jpg?cid=12102912"),
              new Album("Their Satanic Majesties Request", "http://akamai-b.cdn.cddbp.net/cds/2.0/cover/2637/A032/1D20/C231_medium_front.jpg?cid=12102912"),
              new Album("Beggars Banquet", "http://akamai-b.cdn.cddbp.net/cds/2.0/cover/BB70/AF1E/47D2/C0D9_medium_front.jpg?cid=12102912"),
              new Album("Let It Bleed", "http://akamai-b.cdn.cddbp.net/cds/2.0/cover/7791/73F6/D9CA/9FE3_medium_front.jpg?cid=12102912")
            ]);
  @observable List<Album> albumsFiltered = toObservable([
              new Album("12 x 5", "http://akamai-b.cdn.cddbp.net/cds/2.0/cover/615F/84D5/EA9C/843D_medium_front.jpg?cid=12102912"),
              new Album("The Rolling Stones", "http://akamai-b.cdn.cddbp.net/cds/2.0/cover/0152/A0F0/1611/E72D_medium_front.jpg?cid=12102912"),
              new Album("December's Children", "http://akamai-b.cdn.cddbp.net/cds/2.0/cover/9ED9/DFD6/CE0D/564F_medium_front.jpg?cid=12102912"),
              new Album("The Rolling Stones, Now!", "http://akamai-b.cdn.cddbp.net/cds/2.0/cover/7D9C/4267/17B2/58E8_medium_front.jpg?cid=12102912"),
              new Album("Aftermath", "http://akamai-b.cdn.cddbp.net/cds/2.0/cover/D7E4/45CB/ACAB/0D8A_medium_front.jpg?cid=12102912"),
              new Album("Beggars Banquet", "http://akamai-b.cdn.cddbp.net/cds/2.0/cover/BB70/AF1E/47D2/C0D9_medium_front.jpg?cid=12102912")
            ]);
  
  @observable List<Album> currentAlbums;
  
  void switchAlbumsDataProvider () {
    currentAlbums = currentAlbums == albums ? albumsFiltered : albums;
  }
  
  /// Constructor used to create instance of MainApp.
  MainApp.created() : super.created();
  
  @override
  void attached () {
    super.attached();
    currentAlbums = albums;
    productCategoriesDatagrid = productCategories;
    
    tabDropDownProductCategoriesObject      = productCategoriesObject;
    tabSingleSelectProductCategoriesObject  = productCategoriesObject;
    tabMultiSelectProductCategoriesObject   = productCategoriesObject;
  }
  
  void switchTabDropDown (Event e) {
    tabDropDownProductCategoriesObject = (tabDropDownProductCategoriesObject == productCategoriesObject ? 
                                          otherProductCategoriesObject : 
                                          productCategoriesObject);
  }
  
  void switchTabSingleSelectList (Event e) {
    tabSingleSelectProductCategoriesObject = (tabSingleSelectProductCategoriesObject == productCategoriesObject ? 
                                          otherProductCategoriesObject : 
                                          productCategoriesObject);
  }
  
  void switchTabMultiSelectList (Event e) {
    tabMultiSelectProductCategoriesObject = (tabMultiSelectProductCategoriesObject == productCategoriesObject ? 
                                          otherProductCategoriesObject : 
                                          productCategoriesObject);
  }
  
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
    int top = event.page.y;
    int left = event.page.x;
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


class Album {
  String name;
  String cover;
  
  Album (this.name, this.cover);
  
  bool operator ==(o) => o is Album && 
                         o.name == this.name && 
                         o.cover == this.cover;
  
  int get hashCode => hash2(name, cover);
  
}
