import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:inventory_management/inventory_page/scanner_page/state.dart';
import 'package:inventory_management/login_page/state.dart';
import 'package:inventory_management/main_page/state.dart';
import 'package:inventory_management/material/material_detail_page/state.dart';
import 'package:inventory_management/material/material_list_page/state.dart';
import 'package:inventory_management/memo/memo_edit_page/ocr_list_page/state.dart';
import 'package:inventory_management/memo/memo_edit_page/state.dart';
import 'package:inventory_management/memo/memo_list_page/state.dart';
import 'package:inventory_management/memo/memo_save_page/state.dart';
import 'package:inventory_management/printing/printing_page/page.dart';
import 'package:inventory_management/printing/printing_page/state.dart';
import 'package:inventory_management/printing/std_label_page/state.dart';
import 'package:inventory_management/printing/stk_label_page/state.dart';
import 'package:inventory_management/route/app_state.dart';
import 'package:inventory_management/setting_page/reset_password_page/state.dart';
import 'package:inventory_management/setting_page/reset_server_page/page.dart';
import 'package:inventory_management/setting_page/reset_server_page/state.dart';
import 'package:inventory_management/setting_page/state.dart';
import 'package:inventory_management/tab_page/state.dart';
import 'package:inventory_management/welcome_page/page.dart';
import 'package:inventory_management/welcome_page/state.dart';
import 'package:inventory_management/setting_page/reset_password_page/page.dart';
import 'package:inventory_management/setting_page/page.dart';
import 'package:inventory_management/tab_page/page.dart';
import 'package:inventory_management/memo/memo_save_page/page.dart';
import 'package:inventory_management/memo/memo_list_page/page.dart';
import 'package:inventory_management/memo/memo_edit_page/page.dart';
import 'package:inventory_management/memo/memo_edit_page/ocr_list_page/page.dart';
import 'package:inventory_management/login_page/page.dart';
import 'package:inventory_management/inventory_page/page.dart';
import 'package:inventory_management/inventory_page/scanner_page/page.dart';
import 'package:inventory_management/printing/std_label_page/page.dart';
import 'package:inventory_management/printing/stk_label_page/page.dart';
import 'package:inventory_management/material/material_detail_page/page.dart';
import 'package:inventory_management/material/material_list_page/page.dart';
import 'package:inventory_management/main_page/page.dart';

class AppRoute {
  AppRoutes<AppState> router;
  AppRoute._internal() {
    router = AppRoutes<AppState>(preloadedState: AppState(), slots: {
      routerNameForWelcomePage: WelcomeConnector() + WelcomePage(),
      routerNameForLoginPage: LoginConnector() + LoginPage(),
      routerNameForInventoryPage: InventoryConnector() + InventoryPage(),
      routerNameForScannerPage: ScannerConnector() + ScannerPage(),
      routerNameForMainPage: MainConnector() + MainPage(),
      routerNameForTabPage: TabConnector() + TabPage(),
      routerNameForMaterialListPage:
          MaterialListConnector() + MaterialListPage(),
      routerNameForMaterialDetailPage:
          MaterialDetailConnector() + MaterialDetailPage(),
      routerNameForMemoSavePage: MemoSaveConnector() + MemoSavePage(),
      routerNameForMemoListPage: MemoListConnector() + MemoListPage(),
      routerNameForMemoEditPage: MemoEditConnector() + MemoEditPage(),
      routerNameForOcrListPage: OcrListConnector() + OcrListPage(),
      routerNameForStkLabelPage: StkLabelConnector() + StkLabelPage(),
      routerNameForStdLabelPage: StdLabelConnector() + StdLabelPage(),
      routerNameForSettingPage: SettingConnector() + SettingPage(),
      routerNameForPrintingPage:
          createDependent(PrintingConnector(), PrintingPage()),
      routerNameForResetPasswordPage:
          ResetPasswordConnector() + ResetPasswordPage(),
      routerNameForResetServerPage:
          ResetServerPageConnector() + ResetServerPage(),
    });
  }
  //保存单例
  static AppRoute _singleton = AppRoute._internal();

  //工厂方法
  factory AppRoute() => _singleton;

  Widget buildPage(
    String routeName, {
    Object arguments,
  }) {
    return router.buildPage(routeName, arguments);
  }

  // 页面跳转
  Future pushScreen(
    BuildContext context,
    String routeName, {
    Object arguments,
  }) {
    Widget screen = router.buildPage(routeName, arguments);

    return Navigator.of(context).push(
      MaterialPageRoute(
        settings: RouteSettings(name: routeName),
        builder: (BuildContext context) {
          return screen;
        },
      ),
    );
  }

  // 页面弹出
  bool popScreen<T>(BuildContext context, [T result]) {
    return Navigator.of(context).pop<T>(result);
  }

//替换当前页面
  Future replaceScreen(
    BuildContext context,
    String routeName, {
    Object arguments,
  }) {
    Widget screen = router.buildPage(routeName, arguments);

    return Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        settings: RouteSettings(name: routeName),
        builder: (BuildContext context) {
          return screen;
        },
      ),
    );
  }

//pop页面站知道只有一个页面
  void popAll(BuildContext context) {
    Navigator.of(context).popUntil((Route router) {
      if (router.isFirst) {
        return true;
      }
      return false;
    });
  }

//推出指定个数页面
  void popNum(BuildContext context, int number) {
    int i = 0;
    Navigator.of(context).popUntil((Route router) {
      if ((router.isFirst) || (i == number)) {
        return true;
      }
      i++;
      return false;
    });
  }

  void popUtil(BuildContext context, String url) {
    Navigator.of(context).popUntil((Route route) => route.settings.name == url);
  }
}

final AppRoute appRouter = AppRoute();
