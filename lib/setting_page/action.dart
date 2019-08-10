import 'package:fish_redux/fish_redux.dart';

enum SettingAction {
  onJumpToResetPassword,
  onJumpToResetServer,
  onClearCache,
  onSignOut,
  onServerManagerment,
  updateFlag,
  updateBlueTooth,
  updateActivity,
  onConnenctBluetooth,
}

class SettingActionCreator {
  static Action onJumpToResetPassword() {
    return const Action(SettingAction.onJumpToResetPassword);
  }

  static Action onJumpToResetServer() {
    return const Action(SettingAction.onJumpToResetServer);
  }

  static Action onClearCache() {
    return const Action(SettingAction.onClearCache);
  }

  static Action onSignOut() {
    return const Action(SettingAction.onSignOut);
  }

  static Action onServerManagerment() {
    return const Action(SettingAction.onServerManagerment);
  }

  static Action updateFlag(String flag) {
    return Action(SettingAction.updateFlag, payload: flag);
  }

  static Action updateActivity(String updateActivity) {
    return Action(SettingAction.updateActivity, payload: updateActivity);
  }

  static Action onConnenctBluetooth(String name) {
    return Action(SettingAction.onConnenctBluetooth, payload: name);
  }

  static Action updateBlueTooth(List blueToothList) {
    return Action(SettingAction.updateBlueTooth, payload: blueToothList);
  }
}
