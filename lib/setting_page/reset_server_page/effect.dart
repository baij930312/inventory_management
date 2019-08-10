import 'package:fish_redux/fish_redux.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:inventory_management/agent/agent.dart';
import 'package:inventory_management/common/utils.dart';
import 'package:inventory_management/welcome_page/model/cache_model.dart';
import 'action.dart';
import 'state.dart';

Effect<ResetServerPageState> buildEffect() {
  return combineEffects(<Object, Effect<ResetServerPageState>>{
    ResetServerPageAction.onSave: _onSave,
  });
}

void _onSave(Action action, Context<ResetServerPageState> ctx) async {
  cacheModel.hostUrl = ctx.state.serverHost.text;
  bool ok = await cacheModel.setLoaclCache();
  if (ok) {
    httpUtil.changeHostUrl('http://' + ctx.state.serverHost.text);
    Fluttertoast.showToast(
      msg: 'Success',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIos: 1,
    );
  } else {
    Fluttertoast.showToast(
      msg: 'Error',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIos: 1,
    );
  }
}
