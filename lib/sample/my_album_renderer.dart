import 'package:polymer/polymer.dart';
import 'package:flex_components/flex_components.dart';

/**
 * A Polymer my-album-renderer element.
 */
@CustomTag('my-album-renderer')

class MyAlbumRenderer extends PolymerElement implements DataRenderer {

  @published dynamic data;
  
  /// Constructor used to create instance of MyAlbumRenderer.
  MyAlbumRenderer.created() : super.created() {
  }
  
}
