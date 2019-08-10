import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';

import 'action.dart';
import 'state.dart';

Widget buildView(
    ResetServerPageState state, Dispatch dispatch, ViewService viewService) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Reset Password'),
      actions: <Widget>[
        RawMaterialButton(
            child: Text(
              'Save',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: ()=>dispatch(ResetServerPageActionCreator.onSave())),
      ],
    ),
    body: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          TextFormField(
            controller: state.serverHost,
            decoration: InputDecoration(
                hintText: 'Server Host', labelText: 'Please Enter Server Host'),
          ),
        ],
      ),
    ),
  );
}
