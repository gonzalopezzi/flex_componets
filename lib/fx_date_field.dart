import 'package:polymer/polymer.dart';
import 'dart:html';
import 'package:flex_components/fx_base.dart';
import 'package:flex_components/fx_date_chooser.dart';
import 'dart:async';
import 'package:intl/intl.dart';

/**
 * A Polymer fx-date-field element.
 */
@CustomTag('fx-date-field')

class FxDateField extends FxBase {

  @observable bool dateChooserVisible = false;
  
  FxDateChooser _dateChooser;
  
  @published DateTime selectedDate;
  @published String formatString = "yyyy-MM-dd";
  
  FxDateField.created() : super.created() {
  }
  
  void attached () {
    _dateChooser = ($['date-field-date-chooser'] as FxDateChooser);
  }
  
  void selectedDateChanged (DateTime oldValue) {
    dateChooserVisible = false;
  }
  
  void dateChooserVisibleChanged (bool oldValue) {
    invalidateProperties();
  }
  
  void toggleDateChooser (Event e) {
    dateChooserVisible = !dateChooserVisible;
    invalidateProperties();
  }
  
  String format (DateTime date) {
    var formatter = new DateFormat(formatString);
    return formatter.format(date);
  }
  
  @override commitProperties () {
    super.commitProperties();
    if (dateChooserVisible) {
      _dateChooser.style.visibility = 'visible';
      _dateChooser.style.opacity = '1';
    }
    else {
      _dateChooser.style.opacity = '0';
      new Timer(new Duration(milliseconds:400), () {
        _dateChooser.style.visibility = 'hidden';
      });
    }
  }
  
}
