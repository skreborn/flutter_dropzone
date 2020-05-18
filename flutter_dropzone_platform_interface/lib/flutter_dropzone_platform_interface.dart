import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'method_channel_flutter_dropzone.dart';

enum DragOperation { copy, move, link, copyMove, copyLink, linkMove, all }

abstract class FlutterDropzonePlatform extends PlatformInterface {
  static final _token = Object();
  final events = StreamController<DropzoneEvent>.broadcast();
  static FlutterDropzonePlatform _instance = MethodChannelFlutterDropzone();

  FlutterDropzonePlatform() : super(token: _token);

  /// The default instance of [FlutterDropzonePlatform] to use.
  static FlutterDropzonePlatform get instance => _instance;

  /// Platform-specific plugins should set this with their own platform-specific
  /// class that extends [FlutterDropzonePlatform] when they register themselves.
  static set instance(FlutterDropzonePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  void init(Map<String, dynamic> params, {@required int viewId}) {
    throw UnimplementedError('init');
  }

  Future<bool> setOperation(DragOperation operation, {@required int viewId}) async {
    throw UnimplementedError('setOperation');
  }

  Future<bool> setMIME(List<String> mime, {@required int viewId}) async {
    throw UnimplementedError('setMIME');
  }

  Stream<DropzoneLoadedEvent> onLoaded({@required int viewId}) {
    return events.stream //
        .where((event) => event.viewId == viewId && event is DropzoneLoadedEvent)
        .cast<DropzoneLoadedEvent>();
  }

  Stream<DropzoneErrorEvent> onError({@required int viewId}) {
    return events.stream //
        .where((event) => event.viewId == viewId && event is DropzoneErrorEvent)
        .cast<DropzoneErrorEvent>();
  }

  Stream<DropzoneDropEvent> onDrop({@required int viewId}) {
    return events.stream //
        .where((event) => event.viewId == viewId && event is DropzoneDropEvent)
        .cast<DropzoneDropEvent>();
  }

  Widget buildView(Map<String, dynamic> creationParams, Set<Factory<OneSequenceGestureRecognizer>> gestureRecognizers, PlatformViewCreatedCallback onPlatformViewCreated) {
    throw UnimplementedError('buildView');
  }

  void dispose() {
    events.close();
  }
}

class DropzoneEvent<T> {
  final int viewId;
  final T value;

  DropzoneEvent(this.viewId, [this.value]);
}

class DropzoneLoadedEvent extends DropzoneEvent {
  DropzoneLoadedEvent(int viewId) : super(viewId, null);
}

class DropzoneErrorEvent extends DropzoneEvent<String> {
  DropzoneErrorEvent(int viewId, String error) : super(viewId, error);
}

class DropzoneDropEvent extends DropzoneEvent<dynamic> {
  DropzoneDropEvent(int viewId, dynamic file) : super(viewId, file);
}
