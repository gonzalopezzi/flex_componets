// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:polymer/polymer.dart';

@CustomTag('main-app-gmail')
class MainAppLayout extends PolymerElement {
  @observable String imagesManagement = 'always';
  @observable String replyManagement = 'replyAll';
  MainAppLayout.created() : super.created();
}