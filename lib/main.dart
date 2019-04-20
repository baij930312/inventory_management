import 'package:flutter/material.dart';
import 'package:inventory_management/bloc/bloc_provider.dart';
import 'package:inventory_management/common/colors.dart';
import 'package:inventory_management/route/router.dart';
import 'package:inventory_management/welcome_page/page.dart';

void main() async {
  runApp(
    BlocProvider(
      bloc: appBloc,
      child: MaterialApp(
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
