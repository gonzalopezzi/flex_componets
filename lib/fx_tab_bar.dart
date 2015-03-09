import 'package:polymer/polymer.dart';
import 'package:flex_components/fx_base.dart';
import 'package:flex_components/fx_viewstack.dart';
import 'dart:html';

/**
 * A Polymer fx-tab-bar element.
 */
@CustomTag('fx-tab-bar')

class FxTabBar extends FxBase {

  @published dynamic dataProvider;
  @published int selectedIndex;
  
  @observable List<String> computedDataProvider;
  
  bool _flgDataProviderChange = false;
  
  /// Constructor used to create instance of FxTabBar.
  FxTabBar.created() : super.created() {
  }
  
  void attached () {
    _styleActiveTab ();
    invalidateProperties();
  }
  
  void dataProviderChanged (dynamic oldValue) {
    _flgDataProviderChange = true;
    invalidateProperties();
  }
  
  void selectedIndexChange (int oldValue) {
    invalidateProperties();
  }
  
  void tabClickHandler (Event e, detail) {
    Element tab = e.currentTarget;
    selectedIndex = int.parse(tab.dataset['index']);
    invalidateProperties();
  }
  
  @override
  void commitProperties () {
    super.commitProperties();
    if (_flgDataProviderChange) {
      if (dataProvider == null) {
        computedDataProvider = null;
      }
      else  if (dataProvider is List) {
        computedDataProvider = dataProvider;
      }
      else if (dataProvider is FxViewstack) {
        dataProvider.onContentReady.listen ((_) {
          computedDataProvider = dataProvider.getChildrenList();  
        });
      }
      _flgDataProviderChange = false;
    }
    _styleActiveTab();
  }
  
  void _styleActiveTab () {
    window.requestAnimationFrame((_) {  /* Request Animation Frame to fix IE not getting the tabs in time :( */
      List<Element> tabs = this.shadowRoot.querySelectorAll('.fx-tab');
      print ("Tabs: $tabs");
      tabs.forEach((Node nodo) => (nodo as Element).classes.add('inactive'));
      if (selectedIndex != null && selectedIndex >= 0 && tabs != null && selectedIndex < tabs.length) {
        tabs[selectedIndex].classes.remove('inactive');
      }  
    });
  }
  
  
}
