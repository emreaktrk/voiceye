// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'camera_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$CameraStore on _CameraStore, Store {
  final _$_CameraStoreActionController = ActionController(name: '_CameraStore');

  @override
  void takePicture(BuildContext context) {
    final _$actionInfo = _$_CameraStoreActionController.startAction();
    try {
      return super.takePicture(context);
    } finally {
      _$_CameraStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  Future<File> compress(File file) {
    final _$actionInfo = _$_CameraStoreActionController.startAction();
    try {
      return super.compress(file);
    } finally {
      _$_CameraStoreActionController.endAction(_$actionInfo);
    }
  }
}
