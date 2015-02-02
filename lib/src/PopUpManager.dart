part of flex_components;

class PopUpManager {
  
  static FxOverlay fxOverlay;
  static Element popUpContainer;
  
  static Element currentModalPopup;
  static List<Element> currentPopups  = new List<Element> ();
  
  static addPopUp (Element element, {bool modal, int top, int left}) {
    if (modal) {
      if (currentModalPopup != null) {
        throw new UnsupportedError ("Only one modal popup is allowed");
      }
      else {
        doAddModalPopUp (element);
        currentModalPopup = element;  
      }
    }
    else {
      doAddPopUp(element, top, left);
    }
  }
  
  static doAddPopUp (Element element, int top, int left) {
    BodyElement body = querySelector('body');
    body.style.setProperty("position", "relative");
    popUpContainer = new DivElement();
    popUpContainer..style.setProperty("display", "inline-block")
                  ..style.setProperty("position", "absolute")
                  ..style.setProperty("top", "${top}px")
                  ..style.setProperty("left", "${left}px");
    popUpContainer.children.add(element);
    body.children.add(popUpContainer);
    currentPopups.add(popUpContainer);
  }
  
  static doAddModalPopUp (Element element) {
    BodyElement body = querySelector('body');
    body.style.setProperty("overflow-x", "hidden");
    body.style.setProperty("overflow-y", "hidden");
    body.style.setProperty("position", "relative");
    
    popUpContainer = new DivElement();
    popUpContainer..style.setProperty("display", "block")
                  ..style.setProperty("position", "fixed")
                  ..style.setProperty("width", "100%")
                  ..style.setProperty("height", "100%");
    
    element.style..setProperty("display", "inline-block")
                  ..setProperty("margin", "5% 5% 5% 5%");
    
    fxOverlay = new FxOverlay();
    popUpContainer.children.add(fxOverlay);
    fxOverlay.content = element;
    
    fxOverlay.addEventListener("closeOverlay", closeOverlayHandler);
    
    body.children.add(popUpContainer);
  }
  
  static void closeOverlayHandler (Event e) {
    doCloseModalPopUp();
  }
  
  static void removePopUp (Element element) {
    if (element == currentModalPopup) {
      fxOverlay.performCloseAnimation().then((_) {
        doCloseModalPopUp();  
      });
    }
    else {
      Element popUpContainer = currentPopups.where((Element e) => e.children[0] == element).first; 
      if (popUpContainer != null) {
        BodyElement body = querySelector('body');
        body.children.remove(popUpContainer);
        currentPopups.remove(popUpContainer);
      }
    }
  }
  
  static void doCloseModalPopUp () {
    fxOverlay.removeEventListener("closeOverlay", closeOverlayHandler);
    BodyElement body = querySelector('body');
    body.style.setProperty("overflow-x", "auto");
    body.style.setProperty("overflow-y", "auto");
    popUpContainer.children.remove(fxOverlay);
    body.children.remove(popUpContainer);
    currentModalPopup = null;
  }
}