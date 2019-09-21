import 'package:fast_qr_reader_view/fast_qr_reader_view.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:inventory_management/agent/api.dart';
import 'package:inventory_management/inventory_page/scanner_page/page.dart';
import 'package:inventory_management/inventory_page/scanner_page/state.dart';
import 'package:inventory_management/login_page/model/user_model.dart';
import 'package:inventory_management/route/router.dart';
import 'package:inventory_management/welcome_page/model/cache_model.dart';
import 'action.dart';
import 'state.dart';

Effect<InventoryState> buildEffect() {
  return combineEffects(<Object, Effect<InventoryState>>{
    InventoryAction.onScan: _onScan,
    Lifecycle.dispose: _dispose,
    Lifecycle.initState: _onInit,
    InventoryAction.onSave: _onSave,
  });
}

void _onInit(Action action, Context<InventoryState> ctx) async {
  InventoryState state = ctx.state.clone();
  try {
    state.cameras = await availableCameras();
    state.controller =
        QRReaderController(state.cameras[0], ResolutionPreset.high, [
      CodeFormat.qr,
      CodeFormat.code128,
      CodeFormat.code39,
      CodeFormat.code93,
    ], (String value) async {
      if (value == null) {
        await Future.delayed(
            const Duration(seconds: 1), ctx.state.controller.startScanning);
        return;
      }

      await ctx.state.player.playLocal();
      Initial initial = cacheModel.user.initials;
      String code = '';
      String flag = '';
      if (RegExp('^[${initial.tag}].*').matchAsPrefix(value) != null) {
        code = value.substring(1);
        flag = 'TAG';
      } else if (RegExp("^[${initial.part}].*").matchAsPrefix(value) != null) {
        flag = 'PART';
        code = value.substring(1);
      } else if (RegExp("^[${initial.lot}].*").matchAsPrefix(value) != null) {
        flag = 'LOT';
        code = value.substring(1);
      } else if (RegExp("^[${initial.loc}].*").matchAsPrefix(value) != null) {
        flag = 'LOC';
        code = value.substring(1);
      } else {
        await showDialog(
            context: ctx.context,
            builder: (_) {
              return AlertDialog(
                title: Text("Invalid Barcode:${value.toString()}"),
                actions: <Widget>[
                  new FlatButton(
                    child: new Text("Close"),
                    onPressed: () {
                      Navigator.of(ctx.context).pop();
                    },
                  )
                ],
              );
            });
        await Future.delayed(
            const Duration(seconds: 1), ctx.state.controller.startScanning);
        return;
      }
      ctx.dispatch(
          InventoryActionCreator.scaned({'flag': flag, 'value': code}));
      await Future.delayed(
          const Duration(seconds: 1), ctx.state.controller.startScanning);
    });
    await state.controller.initialize();
    ctx.dispatch(InventoryActionCreator.init(state));
    await state.controller.startScanning();
  } catch (e) {
    state.cameras = [];
  }
}

void _onScan(Action action, Context<InventoryState> ctx) async {
  ScannerState result = await appRouter
      .pushScreen(ctx.context, routerNameForScannerPage, arguments: ctx.state);

  if (result?.isfull() ?? false) {
    // ctx.dispatch(InventoryActionCreator.scaned(result));
  }
}

void _onSave(Action action, Context<InventoryState> ctx) async {
  ApiModel result = await api.tagScan(
    partNo: ctx.state.stockNumber.text,
    tagNo: ctx.state.tagNumber.text,
    loc: ctx.state.location.text,
    qty: int.parse(ctx.state.qty.text ?? '0'),
    lot: ctx.state.lotNumber.text,
  );
  if (!result.isError()) {
    await showDialog(
        context: ctx.context,
        builder: (_) {
          return AlertDialog(
            title: Text("Save success!"),
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
                  ctx.dispatch(InventoryActionCreator.clean());
                  Navigator.of(ctx.context).pop();
                },
              ),
            ],
          );
        });
  } else {
    await showDialog(
        context: ctx.context,
        builder: (_) {
          return AlertDialog(
            title: Text(result.errMsg ,style: TextStyle(color: Colors.black
            ),

             ),
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
                  Navigator.of(ctx.context).pop();
                },
              ),
            ],
          );
        });
  }
}

void _dispose(Action action, Context<InventoryState> ctx) async {
  ctx.state.controller?.dispose();
}
