import 'package:fish_redux/fish_redux.dart';
import 'package:inventory_management/inventory_page/scanner_page/state.dart';
import 'package:inventory_management/inventory_page/state.dart';
import 'package:inventory_management/login_page/state.dart';
import 'package:inventory_management/main_page/state.dart';
import 'package:inventory_management/material/material_detail_page/state.dart';
import 'package:inventory_management/material/material_list_page/state.dart';
import 'package:inventory_management/memo/memo_edit_page/ocr_list_page/state.dart';
import 'package:inventory_management/memo/memo_edit_page/state.dart';
import 'package:inventory_management/memo/memo_list_page/state.dart';
import 'package:inventory_management/memo/memo_save_page/state.dart';
import 'package:inventory_management/printing/printing_page/state.dart';
import 'package:inventory_management/printing/std_label_page/state.dart';
import 'package:inventory_management/printing/stk_label_page/state.dart';
import 'package:inventory_management/setting_page/reset_password_page/state.dart';
import 'package:inventory_management/setting_page/reset_server_page/state.dart';
import 'package:inventory_management/setting_page/state.dart';
import 'package:inventory_management/tab_page/state.dart';
import 'package:inventory_management/welcome_page/state.dart';

class AppState implements Cloneable<AppState> {
  WelcomeState welcomeState = WelcomeState();
  LoginState loginState = LoginState();
  InventoryState inventoryState = InventoryState();
  ScannerState scannerState = ScannerState();
  MainState mainState = MainState();
  TabState tabState = TabState();
  MaterialListState materialListState = MaterialListState();
  MaterialDetailState materialDetailState = MaterialDetailState();
  MemoSaveState memoSaveState = MemoSaveState();
  MemoListState memoListState = MemoListState();
  MemoEditState memoEditState = MemoEditState();
  StkLabelState stkLabelState = StkLabelState();
  OcrListState ocrListState = OcrListState();
  StdLabelState stdLabelState = StdLabelState();
  SettingState settingState = SettingState();
  ResetPasswordState resetPasswordState = ResetPasswordState();
  PrintingState printingState = PrintingState();
  ResetServerPageState reserServerState = ResetServerPageState();

  @override
  AppState clone() {
    return AppState()
      ..welcomeState = welcomeState.clone()
      ..inventoryState = inventoryState.clone()
      ..loginState = loginState.clone()
      ..scannerState = scannerState.clone()
      ..mainState = mainState.clone()
      ..tabState = tabState.clone()
      ..materialListState = materialListState.clone()
      ..materialDetailState = materialDetailState.clone()
      ..memoSaveState = memoSaveState.clone()
      ..memoEditState = memoEditState.clone()
      ..memoListState = memoListState.clone()
      ..memoListState = memoListState.clone()
      ..ocrListState = ocrListState.clone()
      ..stkLabelState = stkLabelState.clone()
      ..stdLabelState = stdLabelState.clone()
      ..resetPasswordState = resetPasswordState.clone()
      ..printingState = printingState.clone()
      ..reserServerState = reserServerState.clone()
      ..settingState = settingState.clone();
  }
}
