import 'package:polymer/polymer.dart';
import 'package:bwu_datagrid/datagrid/helpers.dart';

/**
 * A Polymer fx-datagrid-column element.
 */
@CustomTag('fx-datagrid-column')

class FxDatagridColumn extends PolymerElement {

  @published String id;
  @published String name;
  /*dom.Element nameElement;*/
  @published String field;
  @published int width;
  @published int minWidth;
  @published int maxWidth;
  @published bool resizable;
  @published bool sortable;
  @published bool focusable;
  @published bool selectable;
  @published bool defaultSortAsc;
  @published String headerCssClass; // TODO: No argument in constructor!!!
  @published bool rerenderOnResize;
  @published String toolTip;
  @published String cssClass;
  @published bool cannotTriggerInsert;
  @published String colspan;
  @published List<String> behavior;
  @published bool isMovable; 
  @published bool isDraggable; 
  
  /// Constructor used to create instance of FxDatagridColumn.
  FxDatagridColumn.created() : super.created() {
  }
  
  Column get column => new Column(
                                id:id,
                                name:name,
                                field:field,
                                width:width,
                                minWidth:minWidth,
                                maxWidth:maxWidth,
                                resizable:resizable,
                                sortable:sortable,
                                focusable:focusable,
                                selectable:selectable,
                                defaultSortAsc:defaultSortAsc,
                                rerenderOnResize:rerenderOnResize,
                                toolTip:toolTip,
                                cssClass:cssClass,
                                cannotTriggerInsert:cannotTriggerInsert,
                                colspan:colspan,
                                behavior:behavior,
                                isMovable:isMovable,
                                isDraggable:isDraggable);
                                 
  
}
