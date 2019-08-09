import 'package:fish_redux/fish_redux.dart';
import 'package:inventory_management/login_page/model/user_model.dart';
import 'package:inventory_management/welcome_page/model/cache_model.dart';

import 'action.dart';
import 'state.dart';

Reducer<MemoSaveState> buildReducer() {
  return asReducer(
    <Object, Reducer<MemoSaveState>>{
      MemoSaveAction.switchSendMail: _switchSendMail,
      MemoSaveAction.selectCategory: _selectCategory,
      MemoSaveAction.changeLoading: _changeLoading,
      RouteAction.route: _route,
    },
  );
}

MemoSaveState _route(MemoSaveState state, Action action) {
  final MemoSaveState newState = initState(action.payload).clone();
  List<Categorie> categories = List.from(cacheModel.user.categories ?? []);
  if (categories.length > 0 && newState.activity == null) {
    newState.activity = categories[0].category;
  }

  newState.allActivities = categories;
  return newState;
}

MemoSaveState _changeLoading(MemoSaveState state, dynamic action) {
  final MemoSaveState newState = state.clone();
  newState.loading = action.payload;
  return newState;
}

MemoSaveState _switchSendMail(MemoSaveState state, Action action) {
  final MemoSaveState newState = state.clone();
  newState.sendEmail = action.payload;
  return newState;
}

MemoSaveState _selectCategory(MemoSaveState state, Action action) {
  final MemoSaveState newState = state.clone();
  newState.activity = action.payload;
  return newState;
}
