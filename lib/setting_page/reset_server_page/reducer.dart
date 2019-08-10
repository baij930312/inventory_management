import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<ResetServerPageState> buildReducer() {
  return asReducer(
    <Object, Reducer<ResetServerPageState>>{
      RouteAction.route: _route,
    },
  );
}

ResetServerPageState _route(ResetServerPageState state, Action action) {
  return initState(action.payload).clone();
}
