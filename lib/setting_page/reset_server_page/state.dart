import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:inventory_management/route/app_state.dart';
import 'package:inventory_management/welcome_page/model/cache_model.dart';

class ResetServerPageState implements Cloneable<ResetServerPageState> {
  TextEditingController serverHost = TextEditingController();

  @override
  ResetServerPageState clone() {
    return ResetServerPageState()..serverHost = serverHost;
  }
}

ResetServerPageState initState(Map<String, dynamic> args) {
  return ResetServerPageState()
    ..serverHost = TextEditingController(text: cacheModel.hostUrl);
}

class ResetServerPageConnector extends ConnOp<AppState, ResetServerPageState> {
  @override
  ResetServerPageState get(AppState appState) {
    final ResetServerPageState state = appState.reserServerState.clone();
    return state;
  }

  @override
  void set(AppState appState, ResetServerPageState subState) {
    appState.reserServerState = subState.clone();
  }
}
