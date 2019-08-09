import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:inventory_management/login_page/model/user_model.dart';
import 'package:inventory_management/memo/memo_edit_page/memo_image_component/state.dart';
import 'package:inventory_management/memo/memo_list_page/memo_list_tile_component/state.dart';

import 'package:inventory_management/route/app_state.dart';

class MemoSaveState implements Cloneable<MemoSaveState> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController keywordController = TextEditingController();
  bool sendEmail = false;
  String notes = '';
  bool loading = false;
  String activity;
  List<Categorie> allActivities = [];
  List<MemoImageState> images = [];
  MemoListTileState listTileState = MemoListTileState();

  @override
  MemoSaveState clone() {
    return MemoSaveState()
      ..scaffoldKey = scaffoldKey
      ..keywordController = keywordController
      ..sendEmail = sendEmail
      ..notes = notes
      ..activity = activity
      ..images = images
      ..loading = loading
      ..listTileState = listTileState.clone()
      ..allActivities = allActivities;
  }
}

MemoSaveState initState(Map<String, dynamic> args) {
  MemoListTileState state = args['tileState'];
  return MemoSaveState()
    ..notes = args['notes']
    ..listTileState = state
    ..keywordController = TextEditingController(text: state.keyword)
    ..activity = state.category
    ..images = args['images'].cast<MemoImageState>();
}

class SettingItem {
  Function onDone;
  Widget child;
  SettingItem({this.onDone, this.child});
}

class MemoSaveConnector extends ConnOp<AppState, MemoSaveState> {
  @override
  MemoSaveState get(AppState appState) {
    final MemoSaveState state = appState.memoSaveState.clone();
    return state;
  }

  @override
  void set(AppState appState, MemoSaveState subState) {
    appState.memoSaveState = subState.clone();
  }
}
