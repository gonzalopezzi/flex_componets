import 'package:polymer/polymer.dart';
import 'dart:html';
import 'package:flex_components/fx_base.dart';
import 'package:flex_components/fx_accordion_element.dart';
import 'dart:async';

@CustomTag('fx-accordion')
class FxAccordion  extends FxBase {
  
  List<Element> currentChildren;
  @published int selectedIndex = 0;
  List<StreamSubscription> _listeners = new List ();
  
  Map<Element, int> _indexDictionary = new Map<Element, int> ();
  
  StreamController _contentReadyDispatcher = new StreamController.broadcast();
  Stream get onContentReady => _contentReadyDispatcher.stream;
  

  /// Constructor used to create instance of FxAccordion.
  FxAccordion.created() : super.created() {
  }
  
  void selectedIndexChanged (int oldValue) {
    invalidateProperties();
  }
  
  void _syncChildren () {
    _clearEventListeners();
    _indexDictionary = new Map<Element, int> ();
    List<Element> elements = new List<Element> ();
    NodeList nodeList = (this.shadowRoot.querySelector('content') as ContentElement).getDistributedNodes();
    int i = 0;
    nodeList.forEach ((dynamic el) {
      if (el is FxAccordionElement) {
        _indexDictionary[el] = i++;
        _listeners.add(el.onAccordionElementSelect.listen(_elementSelectHandler));
        /*_listeners.add(el.onClick.listen(_elementClickHandler));*/
        elements.add(el);
      }
    });
    this.currentChildren = elements;    
  }
  
  @override
  void bindFinished () {
    super.bindFinished();
    _syncChildren();
    invalidateProperties();
  }

  attached() {
    super.attached();
    _syncChildren ();
    invalidateProperties ();
  }
  
  List<String> getChildrenList () {
    List<String> childrenList = [];
    currentChildren.forEach((Element element) {
      childrenList.add(element.dataset['label']);
    });
    return childrenList;
  }
  
  void _elementSelectHandler (Map data) {
    selectedIndex = _indexDictionary[data['target']];
    invalidateProperties();
    new Timer(new Duration(milliseconds: 400), () {
      currentChildren.forEach((Element e) {
        (e as FxAccordionElement).displayScroller = true;
      });
    });
  }
  
  void _clearEventListeners () {
    _listeners.forEach((StreamSubscription subs) {
      subs.cancel();
    });
  }
  
  @override
  void commitProperties () {
    try {
      super.commitProperties();
      if (currentChildren != null && currentChildren.length > 0) {
        for (int i = 0; i < currentChildren.length; i++) {
          Element e = currentChildren[i];
          (e as FxAccordionElement).displayScroller = false;
          if (i == selectedIndex) {
            e.style.height = "${this.clientHeight - 40 * (currentChildren.length - 1)}px";
          }
          else {
            e.style.height = "40px";
          }
        }
        _contentReadyDispatcher.add(null);
      }
    }
    catch (e, stacktrace) {
      print (e);
      print (stacktrace);
    }
  }
}
