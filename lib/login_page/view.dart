import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:inventory_management/common/colors.dart';
import 'package:inventory_management/common/images.dart';
import 'package:inventory_management/common/utils.dart';

import 'action.dart';
import 'state.dart';

Widget buildView(LoginState state, Dispatch dispatch, ViewService viewService) {
  return Scaffold(
    key: state.scaffoldkey,
    body: Theme(
      data: Theme.of(viewService.context).copyWith(
        inputDecorationTheme: InputDecorationTheme(
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: loginTextColor, width: 0.5)),
          focusedBorder:
              UnderlineInputBorder(borderSide: BorderSide(width: 0.5)),
          labelStyle: TextStyle(
            color: loginTextColor,
            fontSize: 40,
          ),
          contentPadding: EdgeInsets.all(10.0),
        ),
      ),
      child: Builder(
        builder: (BuildContext context) {
          return Container(
            color: Colors.white,
            child: Form(
              onChanged: () {
                if (state.formKey.currentState.validate()) {
                  dispatch(LoginActionCreator.changeCanLogin(true));
                } else {
                  dispatch(LoginActionCreator.changeCanLogin(false));
                }
              },
              key: state.formKey,
              child: SingleChildScrollView(

                child: Column(
                  children: [
                    Stack(children: <Widget>[
                      Image.asset(
                        ImageAssets.loginTitle,
                        width: Utils.getScreenWidth(context)/1.3,
                        fit: BoxFit.fitWidth,
                        height: Utils.getScreenWidth(context)/1.3,
                      ),
                      Positioned(
                        bottom: 16,
                        right: 16,
                        child: buildVersionText(state, dispatch, viewService),
                      )
                    ]),
                    // SizedBox(height: 30),
                    buildAccountTextField(state, dispatch, viewService),
                    buildPasswordTextField(state, dispatch, viewService),
                    buildServerTextField(state, dispatch, viewService),
                    buildLinkWordTextField(state, dispatch, viewService),
                    SizedBox(height: 20.0),
                    buildSubmitBottom(state, dispatch, viewService),
                    SizedBox(height: 50.0),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    ),
  );
}

Widget buildAccountTextField(
    LoginState state, Dispatch dispatch, ViewService viewService) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 31),
    child: TextFormField(
      controller: state.account,
      textCapitalization: TextCapitalization.words,
      validator: (text) {
        return text.isEmpty ? 'account is invalid' : null;
      },
      style: TextStyle(fontSize: 20),
      decoration: InputDecoration(
        labelText: 'Account',
        enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: loginTextColor, width: 0.5)),
        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(width: 0.5)),
        labelStyle: TextStyle(
          color: loginTextColor,
          fontSize: 20,
        ),
        contentPadding: EdgeInsets.all(10.0),
      ),
    ),
  );
}

Widget buildPasswordTextField(
    LoginState state, Dispatch dispatch, ViewService viewService) {
  return Container(
      padding: EdgeInsets.symmetric(horizontal: 31),
      child: TextFormField(
        controller: state.password,
        textCapitalization: TextCapitalization.words,
        obscureText: true,
        validator: (text) {
          return text.isEmpty ? 'password is invalid' : null;
        },
        style: TextStyle(fontSize: 20),
        decoration: const InputDecoration(
          hintText: 'Please enter your password',
          labelText: 'Password',
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: loginTextColor, width: 0.5)),
          focusedBorder:
              UnderlineInputBorder(borderSide: BorderSide(width: 0.5)),
          labelStyle: TextStyle(
            color: loginTextColor,
            fontSize: 20,
          ),
          contentPadding: EdgeInsets.all(10.0),
        ),
      ));
}

Widget buildServerTextField(
    LoginState state, Dispatch dispatch, ViewService viewService) {
  return Container(
      padding: EdgeInsets.symmetric(horizontal: 31),
      child: TextFormField(
        controller: state.hostUrl,
        textCapitalization: TextCapitalization.words,
        validator: (text) {
          return text.isEmpty ? 'server address is invalid' : null;
        },
        style: TextStyle(fontSize: 20),
        decoration: const InputDecoration(
          hintText: 'Please enter server host address',
          labelText: 'Server Address',
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: loginTextColor, width: 0.5)),
          focusedBorder:
              UnderlineInputBorder(borderSide: BorderSide(width: 0.5)),
          labelStyle: TextStyle(
            color: loginTextColor,
            fontSize: 20,
          ),
          contentPadding: EdgeInsets.all(10.0),
        ),
      ));
}

Widget buildLinkWordTextField(
    LoginState state, Dispatch dispatch, ViewService viewService) {
  return Container(
      padding: EdgeInsets.symmetric(horizontal: 31),
      child: TextFormField(
        controller: state.linkWord,
        textCapitalization: TextCapitalization.words,
        validator: (text) {
          return text.isEmpty ? 'link word is invalid' : null;
        },
        style: TextStyle(fontSize: 20),
        decoration: const InputDecoration(
          hintText: 'Please enter link word',
          labelText: 'Link Word',
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: loginTextColor, width: 0.5)),
          focusedBorder:
              UnderlineInputBorder(borderSide: BorderSide(width: 0.5)),
          labelStyle: TextStyle(
            color: loginTextColor,
            fontSize: 20,
          ),
          contentPadding: EdgeInsets.all(10.0),
        ),
      ));
}

Widget buildSubmitBottom(
    LoginState state, Dispatch dispatch, ViewService viewService) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 100),
    child: SizedBox(
      width: 200.0,
      height: 40.0,
      child: RaisedButton(
          color: Color(0xFF426478),
          disabledTextColor: Colors.white,
          textColor: Colors.white,
          child: state.loading
              ? Container(
                  color: mainColor,
                  child: SpinKitWave(
                    size: 20,
                    color: Colors.white,
                  ),
                )
              : Text(
                  'Login',
                  style: TextStyle(fontSize: 20),
                ),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(40))),
          onPressed: state.canDoLogin
              ? () async {
                  if (state.formKey.currentState.validate()) {
                    dispatch(LoginActionCreator.onLogin());
                  }
                }
              : null),
    ),
  );
}

Widget buildVersionText(
    LoginState state, Dispatch dispatch, ViewService viewService) {
  return Container(
    alignment: Alignment.bottomRight,
    child: Text(
      'Version:' + Utils.appVersion,
      style: TextStyle(color: loginTextColor, fontSize: 14),
    ),
  );
}
