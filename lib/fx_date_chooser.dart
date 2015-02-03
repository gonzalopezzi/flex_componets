import 'package:polymer/polymer.dart';
import 'package:flex_components/fx_base.dart';
import 'dart:html';

/**
 * A Polymer fx-date-chooser element.
 */
@CustomTag('fx-date-chooser')

class FxDateChooser extends FxBase {

  /// Constructor used to create instance of FxDateChooser.
  FxDateChooser.created() : super.created() {
  }

  bool _weekDaysDirty = true;
  
  Function _changeCallback;
  void set changeCallback (Function f) {
    this._changeCallback = f;
  }
  
  @published DateTime selectedDate;
  DateTime truncatedSelectedDate;
  
  void selectedDateChanged (DateTime oldValue) {
    bool change = selectedDate != oldValue;
    truncatedSelectedDate = new DateTime(selectedDate.year, selectedDate.month, selectedDate.day, 0, 0, 0, 0);
    if (selectedDate != null) 
      _displayedDate = selectedDate;
    if (change) {
      if (_changeCallback != null) {
        _changeCallback({'selectedDate':selectedDate});
      }
      invalidateDisplay();
    } 
  }
  
  DateTime _displayedDate = new DateTime.now();
  
  @published int firstDayOfWeek = 0;
  
  List<String> weekDayNames = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
  List<String> monthNames = ["January", "February", "March", "April", 
                             "May", "June", "July", "August", "September", 
                             "October", "November", "December"];
  
  TableRowElement _trWeeks;
  TableSectionElement _tableBody;
  Map<ButtonElement, DateTime> buttonData = new Map<ButtonElement, DateTime> ();
  
  void attached () { 
    _trWeeks = shadowRoot.querySelector("#week-day-row") as TableRowElement;
    _tableBody = shadowRoot.querySelector("#day-table-body") as TableSectionElement;
    invalidateProperties();
    invalidateDisplay();
  }
  
  @override
  void updateDisplay () {
    super.updateDisplay();
    displayWeekNames ();
    displayDays ();
  }
  
  @published String monthLabel;
  
  void displayWeekNames () {
    if (_weekDaysDirty && _trWeeks != null) {
      _trWeeks.children.clear();
      SpanElement weekLabel;
      for (int i = firstDayOfWeek; i < 7 + firstDayOfWeek; i++) {
        TableCellElement cell = new TableCellElement();
        weekLabel = new SpanElement()
          ..className = "week-label"
          ..appendText(weekDayNames[(i % 7)]);
        cell.append (weekLabel);
        _trWeeks.append(cell);
      }
      _weekDaysDirty = false;
    }
  }
  
  void _initButtonData () {
    buttonData = new Map<ButtonElement, DateTime> ();
  }
  
  void displayDays () {
    int lastDayOfWeek = (firstDayOfWeek + 6) % 7; /* TODO: QUITAR ESTE HARDCODE. ESTO DEBE DEPENDER DE firstDayOfWeek */
    _initButtonData ();
    DateTime firstDate = new DateTime (_displayedDate.year, _displayedDate.month, 1, 0, 0);
    while ((firstDate.weekday - firstDayOfWeek % 7) > (firstDayOfWeek - firstDayOfWeek % 7)) {
      firstDate = firstDate.subtract(new Duration(days:1));
    }
    DateTime lastDate = new DateTime (_displayedDate.year, _displayedDate.month + 1, 1, 0, 0);
    lastDate.subtract(new Duration (days:1));
    while ((lastDate.weekday % 7) != (lastDayOfWeek % 7)) {
      lastDate = lastDate.add(new Duration(days:1));
    }
    
    _tableBody.children = new List<Element> ();
    
    DateTime currentDate = firstDate;
    int dayCounter = 0;
    TableRowElement tr;
    for (DateTime currentDate = firstDate; 
              currentDate.difference(lastDate).inDays <= 0; 
              currentDate = currentDate.add(new Duration (days:1))) {
      if (dayCounter % 7 == 0) { // Must create a new row
        tr = new TableRowElement();
        _tableBody.append(tr);
      }
      tr.append(new TableCellElement()
                  ..append(createButtonElement (currentDate))
                );
      dayCounter++;
    }
  }
  
  void dayButtonClick (MouseEvent event) {
    selectedDate = copyDateTime (buttonData[event.target]);
    invalidateDisplay();
  }
  
  DateTime copyDateTime (DateTime d) {
    return new DateTime (d.year, d.month, d.day);
  }
  
  ButtonElement createButtonElement (DateTime currentDate)  {
    ButtonElement button = new ButtonElement() 
      ..appendText("${currentDate.day}");
    if (currentDate.month != _displayedDate.month) {
      button.className = "day-button other-month-day-button";
    }
    else {
      if (selectedDate != null && currentDate.difference(truncatedSelectedDate).inHours == 0) {
        button.className = "day-button selected-day";
      }
      else {
        button.className = "day-button";
      }
    }
    
    buttonData[button] = currentDate;
    button.onClick.listen(dayButtonClick);
    return button;
  }
  
  void prevMonth() {
    _displayedDate = new DateTime (_displayedDate.year, _displayedDate.month-1, _displayedDate.day);
    invalidateProperties();
    invalidateDisplay();
  }
  
  void nextMonth() {
    _displayedDate = new DateTime (_displayedDate.year, _displayedDate.month+1, _displayedDate.day);
    invalidateProperties();
    invalidateDisplay();
  }
  
  @override 
  void commitProperties () {
    monthLabel = "${monthNames[_displayedDate.month - 1]} - ${_displayedDate.year}";
  }
  
}
  