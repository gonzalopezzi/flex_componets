import 'package:polymer/polymer.dart';
import 'dart:html';

@CustomTag('main-app-gmail')
class MainAppLayout extends PolymerElement {
  @observable String imagesManagement = 'always';
  @observable String replyManagement = 'replyAll';
  @observable String rightToLeft = 'rightToLeftOff';
  
  @observable bool languageOptionsVisible = false;
  
  MainAppLayout.created() : super.created();
  
  void toggleLanguageOptions (MouseEvent e) {
    languageOptionsVisible = !languageOptionsVisible;
  }
}