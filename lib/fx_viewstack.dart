import 'package:polymer/polymer.dart';
import 'dart:html';
import 'package:flex_components/fx_base.dart';

@CustomTag('fx-viewstack')
class FxViewstack extends FxBase {

  List<Element> children;
  
  @published int selectedIndex = 0;
  
  FxViewstack.created() : super.created() {
  }
  
  void selectedIndexChanged (int oldValue) {
    invalidateProperties();
  }

  attached() {
    super.attached();
    NodeList nodeList = (this.shadowRoot.querySelector('content') as ContentElement).getDistributedNodes();
    List<Element> elements = new List<Element> ();
    nodeList.forEach ((dynamic el) {
      if (!(el is Text)) {
        elements.add(el);
      }
    });
    this.children = elements;
    invalidateProperties ();
  }
  
  @override
  void commitProperties () {
    super.commitProperties();
    if (children != null && children.length > 0) {
      children.forEach((Element e) {
        e.style.display = "none";
      });
      if (selectedIndex >= 0 && selectedIndex < children.length)
        children[selectedIndex].style.display = "block";
    }
  }
}
