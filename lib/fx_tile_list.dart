import 'package:polymer/polymer.dart';
import 'package:flex_components/fx_base.dart';
import 'package:flex_components/fx_item_renderer.dart';
import 'dart:html';
import 'dart:async';
import 'package:animation/animation.dart' as anim;

/**
 * A Polymer fx-tile-list element.
 */
@CustomTag('fx-tile-list')

class FxTileList extends FxBase {

  @published int rowHeight = 200;
  @published int columnWidth = 200;
  
  @published List dataProvider;
  @published String itemRenderer;
  
  bool _flgDataProviderDirty = true;
  
  int _columns = 0; // Number of columns that fit in this tile list
  
  Map<dynamic,FxItemRenderer> _rendererDictionary = new Map<dynamic, FxItemRenderer> ();
  
  FxTileList.created() : super.created() {
  }
  
  void dataProviderChanged (List oldValue) {
    _flgDataProviderDirty = true;
    _computeColumns();
    invalidateProperties();
  }

  attached() {
    _computeColumns();
    window.onResize.listen(resizeHandler);
    super.attached();
  }
  
  void resizeHandler (Event e) {
    _computeColumns();
  }
  
  void _computeColumns () {
    int newColumns = (this.clientWidth / columnWidth).floor();
    if (newColumns != _columns) {
      _columns = newColumns;
      invalidateProperties();
    }
  }
  
  void _clearItemRenderers() {
    List<Element> deleteElements = new List<Element>();
    this.shadowRoot.children.forEach((Element element) {
      if (element is FxItemRenderer && 
           (dataProvider == null || !dataProvider.contains(element.data))) {
        element.style.opacity = '0';
        _rendererDictionary[element.data] = null;
        deleteElements.add(element);
      }
    });
    if (deleteElements.length > 0) {
      new Timer(new Duration(milliseconds:400), () {
        deleteElements.forEach((Element e) {
          this.shadowRoot.children.remove(e);
        });
      });
    }
  }
  
  FxItemRenderer _findItemRenderer (dynamic item) {
    return _rendererDictionary [item];
  }
  
  void _renderItems (int cols) {
    if (_flgDataProviderDirty) {
      _clearItemRenderers();
    }
    if (dataProvider != null) {
      int i = 0;
      dataProvider.forEach((dynamic item) {
        FxItemRenderer renderer;
        // Maybe we already had this item. We just have to move this renderer
        renderer = _findItemRenderer (item);
        if (renderer == null) { // We have to create a new item renderer
          if (_flgDataProviderDirty) { // If dataProvider is not dirty, we should not create new items
            renderer = new Element.tag('fx-item-renderer');
            renderer.tag = itemRenderer;
            renderer.style.opacity = '0';
            renderer.style.position = 'absolute';
            renderer.style.transition = 'all 0.4s ease-in-out';
            _rendererDictionary[item] = renderer;
            this.shadowRoot.children.add(renderer);
            async((_) {
              renderer.style.opacity = '1';
            });
          }
        }
        renderer.style.left = '${(i % cols)*columnWidth}px';
        renderer.style.top = '${((i / cols).floor())*rowHeight}px';
        renderer.style.width = '${columnWidth}px';
        renderer.style.height = '${rowHeight}px';
        renderer.data = item;
        i++;
      });
    }
    _flgDataProviderDirty = false;
  }
  
  int _roundUp (num n) {
    if (n - n.floor() > 0)
      return n.floor() + 1;
    else {
      return n.floor();
    }
  }
  
  @override
  void commitProperties () {
    super.commitProperties ();
    
    int newHeight = (_roundUp(dataProvider.length / _columns)) * rowHeight;
    
    if (newHeight == this.clientHeight) {
      _renderItems (_columns);
    }
    else { // Animate height before rendering
      if (newHeight > this.clientHeight) {
        // Animate height and then render items
        new anim.AnimationQueue ()
          ..addAll([
            new anim.ElementAnimation (this)
                  ..duration = 200
                  ..properties = {'height': newHeight}
                  ..easing = anim.Easing.QUADRATIC_EASY_IN_OUT
                  ..onComplete.listen((_) {
                    _renderItems(_columns);              
                  })
          ])
          ..run();
      }
      else {
        // Render Items and then, animate height
        _renderItems(_columns);
        new anim.AnimationQueue ()
          ..addAll([
            new anim.ElementAnimation (this) // Wait 0.4s
                  ..duration = (0.4 * 1000).floor(),
            new anim.ElementAnimation (this)
                  ..duration = 200
                  ..properties = {'height': newHeight}
                  ..easing = anim.Easing.QUADRATIC_EASY_IN_OUT
                  ..onComplete.listen((_) {
                    _renderItems(_columns);              
                  })
          ])
          ..run();
      }
    }
  }
  
}
