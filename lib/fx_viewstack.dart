import 'package:polymer/polymer.dart';
import 'dart:html';
import 'package:flex_components/fx_base.dart';
import 'dart:async';

@CustomTag('fx-viewstack')
class FxViewstack extends FxBase {

  List<Element> currentChildren;
  
  @published int selectedIndex = 0;
  
  StreamController _contentReadyDispatcher = new StreamController.broadcast();
  Stream get onContentReady => _contentReadyDispatcher.stream;
  
  FxViewstack.created() : super.created() {
  }
  
  void selectedIndexChanged (int oldValue) {
    invalidateProperties();
  }
  
  void _syncChildren () {
    List<Element> elements = new List<Element> ();
    NodeList nodeList = (this.shadowRoot.querySelector('content') as ContentElement).getDistributedNodes();
    nodeList.forEach ((dynamic el) {
      if (!(el is Text)) {
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
  
  @override
  void commitProperties () {
    try {
      super.commitProperties();
      if (currentChildren != null && currentChildren.length > 0) {
        currentChildren.forEach((Element e) {
          print ("Elemento: ${e.className}");
          e.style.display = "none";
        });
        if (selectedIndex != null && selectedIndex >= 0 && selectedIndex < currentChildren.length)
          currentChildren[selectedIndex].style.display = "block";
      }
      _contentReadyDispatcher.add(null);
    }
    catch (e, stacktrace) {
      print (e);
      print (stacktrace);
    }
  }
}
