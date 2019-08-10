import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

const routerNameForResetServerPage = 'router://ResetServerPage';

class ResetServerPage
    extends Page<ResetServerPageState, Map<String, dynamic>> {
  ResetServerPage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          dependencies: Dependencies<ResetServerPageState>(
              adapter: null,
              slots: <String, Dependent<ResetServerPageState>>{}),
          middleware: <Middleware<ResetServerPageState>>[],
        );
}
