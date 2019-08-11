import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:inventory_management/bloc/bloc_provider.dart';
import 'package:inventory_management/common/colors.dart';
import 'package:inventory_management/route/router.dart';
import 'package:inventory_management/welcome_page/page.dart';

void main() async {
  FlutterError.onError = (FlutterErrorDetails details) async {
    Fluttertoast.showToast(
      msg: details.exceptionAsString(),
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIos: 1,
    );
    print(details);
  };
  runApp(
    BlocProvider(
      bloc: appBloc,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Inventory Management',
        theme: ThemeData(
          primaryColor: mainColor,
          textTheme: TextTheme(
            body1: TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
            body2: TextStyle(
              fontSize: 20,
              color: Colors.black,
            ),
          ),
        ),
        home: AppRoute().router.buildPage(routerNameForWelcomePage, null),
        onGenerateRoute: (RouteSettings settings) {
          return MaterialPageRoute<Object>(builder: (BuildContext context) {
            return AppRoute()
                .router
                .buildPage(settings.name, settings.arguments);
          });
        },
      ),
    ),
  );
}
