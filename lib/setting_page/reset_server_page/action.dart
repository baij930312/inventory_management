import 'package:fish_redux/fish_redux.dart';

enum ResetServerPageAction { onSave }

class ResetServerPageActionCreator {
  static Action onSave() {
    return const Action(ResetServerPageAction.onSave);
  }
}
