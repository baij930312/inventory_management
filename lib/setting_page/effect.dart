import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:inventory_management/common/utils.dart';
import 'package:inventory_management/login_page/page.dart';
import 'package:inventory_management/route/router.dart';
import 'package:inventory_management/setting_page/model/blue_tooth_model.dart';
import 'package:inventory_management/setting_page/reset_password_page/page.dart';
import 'package:inventory_management/setting_page/reset_server_page/page.dart';
import 'package:inventory_management/welcome_page/model/cache_model.dart';
import 'package:printer/printer.dart';
import 'action.dart';
import 'state.dart';

Effect<SettingState> buildEffect() {
  return combineEffects(<Object, Effect<SettingState>>{
    SettingAction.onJumpToResetPassword: _onJumpToResetPassword,
    SettingAction.onJumpToResetServer: _onJumpToResetServer,
    SettingAction.onSignOut: _onSignOut,
    SettingAction.onClearCache: _onClearCache,
    SettingAction.onConnenctBluetooth: _onConnenctBluetooth,
    SettingAction.onServerManagerment: _onServerManagerment,
    Lifecycle.initState: _onInit,
    Lifecycle.dispose: _onDispose,
  });
}

void _onDispose(Action action, Context<SettingState> ctx) async {
  Printer.stop();
}

void _onInit(Action action, Context<SettingState> ctx) async {
  Printer.init((value) {
    if (value['type'] == 'data') {
      List list = value['data'];
      List<BlueToothModel> blueTooths = list.map((item) {
        return BlueToothModel.fromJson(Map<String, dynamic>.from(item));
      }).toList();
      print(blueTooths);
      ctx.dispatch(SettingActionCreator.updateBlueTooth(blueTooths));
      if ((cacheModel.bluetourhName != '') && (ctx.state.flag != 'connected')) {
        ctx.dispatch(
            SettingActionCreator.onConnenctBluetooth(cacheModel.bluetourhName));
      }
    } else {
      if (value['data'] == 'connected') {
        cacheModel.bluetourhName = ctx.state.activity;
        cacheModel.setLoaclCache();
      }
      if (value['code'] > 0) {
        //蓝牙设备状态
        //清除activity
        ctx.dispatch(SettingActionCreator.updateActivity(null));
      }
      ctx.dispatch(SettingActionCreator.updateFlag(value['data']));
    }
  });
  await Printer.start();
}

void _onJumpToResetPassword(Action action, Context<SettingState> ctx) {
  appRouter.pushScreen(ctx.context, routerNameForResetPasswordPage);
}

void _onJumpToResetServer(Action action, Context<SettingState> ctx) {
  appRouter.pushScreen(ctx.context, routerNameForResetServerPage);
}

void _onConnenctBluetooth(Action action, Context<SettingState> ctx) {
  String name = action.payload;

  try {
    BlueToothModel target =
        ctx.state.blueToothList.firstWhere((model) => model.name == name);
    Printer.connect(target.uuid);
    ctx.dispatch(SettingActionCreator.updateActivity(name));
  } catch (e) {
    print('no target');
  }
}

void _onClearCache(Action action, Context<SettingState> ctx) async {
  int cacheSize = await DiskCache().cacheSize();
  await showDialog(
      context: ctx.context,
      builder: (_) {
        return AlertDialog(
          title: Text("Clear cache (${Utils.getRollupSize(cacheSize)})"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Cancel"),
              onPressed: () {
                Navigator.of(ctx.context).pop();
              },
            ),
            new FlatButton(
              child: new Text("Confirm"),
              onPressed: () async {
                await DiskCache().clear();
                Navigator.of(ctx.context).pop();
              },
            ),
          ],
        );
      });
}

void _onServerManagerment(Action action, Context<SettingState> ctx) {
  // Utils.showSnackBar(ctx.context, text: 'Cache has been cleaned.');
}

void _onSignOut(Action action, Context<SettingState> ctx) {
  showDialog(
      context: ctx.context,
      builder: (_) {
        return AlertDialog(
          title: Text("Confirm sign out?"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(ctx.context).pop();
              },
            ),
            new FlatButton(
              child: new Text("Sign out"),
              onPressed: () {
                Navigator.of(ctx.context).pop();
                appRouter.popAll(ctx.context);
                appRouter.replaceScreen(
                  ctx.context,
                  routerNameForLoginPage,
                  arguments: {
                    'account': cacheModel.account,
                    'password': cacheModel.password,
                    'hostUri': cacheModel.hostUrl,
                    'linkWord': cacheModel.linkword,
                  },
                );
              },
            ),
          ],
        );
      });
}
