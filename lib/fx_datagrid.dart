import 'package:polymer/polymer.dart';
import 'package:flex_components/fx_datagrid_column.dart';
import 'package:flex_components/fx_base.dart';
import 'package:bwu_datagrid/bwu_datagrid.dart';
import 'package:bwu_datagrid/datagrid/helpers.dart';
import 'package:bwu_datagrid/groupitem_metadata_providers/groupitem_metadata_providers.dart';
import 'package:bwu_datagrid/core/core.dart' as core;
import 'dart:html';

class CustomMapDataItemProvider extends DataProvider {
  Function _getItem;
  Function _getLength;

  CustomMapDataItemProvider(this._getItem, this._getLength) : super([]);

  @override
  int get length => _getLength();

  @override
  DataItem getItem(int index) => _getItem(index);

  @override
  RowMetadata getItemMetadata(int index) => null;
}

/**
 * A Polymer fx-datagrid element.
 */
@CustomTag('fx-datagrid')
class FxDatagrid extends FxBase {

  List<Column> _columns;
  BwuDatagrid _grid;
  
  @published List<Map> dataProvider;
  MapDataItemProvider _commitedData;
  
  bool _flgDataproviderDirty = false;
  bool _flgColumnsDirty = false;
  
  bool isAsc = true;
  Column currentSortCol;
  
  var gridOptions = new GridOptions(enableCellNavigation: true, enableColumnReorder: false);

  
  void dataProviderChanged (List<ChangeRecord> changes) {
    _flgDataproviderDirty = true;
    invalidateProperties();
  }
  
  /// Constructor used to create instance of FxDatagrid.
  FxDatagrid.created() : super.created() {
  }
  
  void attached() {
    _fetchColumns ();
    _grid = $['bwudatagrid'];
    this.addEventListener('fx-datagrid-column-change', (_) {
      _flgColumnsDirty = true;
      invalidateProperties();
    });
    invalidateProperties();
  }
  
  void _fetchColumns () {
    _columns = _findDatagridColumnsInDOM ();
  }
  
  List<Column> _findDatagridColumnsInDOM () {
    List<Column> out = new List<Column> ();
    List<Element> elements = this.querySelectorAll('fx-datagrid-column');
    elements.forEach((Element e) {
      out.add((e as FxDatagridColumn).column);
    });
    return out;
  }
  
  void _commitDataProvider () {
    var data = new MapDataItemProvider();
    dataProvider.forEach((Map m) {
      data.items.add(new MapDataItem(m));
    });
    _commitedData = data;
  }
  
  @override
  void commitProperties () {
    super.commitProperties();
    
    if (_flgDataproviderDirty || _flgColumnsDirty) {
      if (_flgColumnsDirty) {
        _fetchColumns();
        _flgColumnsDirty = false;
      }
      _commitDataProvider();
      _flgDataproviderDirty = false;
      _grid.setup(dataProvider: _commitedData, columns: _columns, gridOptions: gridOptions);
      _grid.onBwuSort.listen((core.Sort args) {
        currentSortCol = args.sortColumn;
        isAsc = args.sortAsc;
        _commitedData.items.sort((core.ItemBase i1, core.ItemBase i2) => (isAsc ? 1 : -1) * i1[currentSortCol.field].compareTo(i2[currentSortCol.field]));
        _grid.invalidateAllRows();
        _grid.render();
      });
    }
  }
  
}
