import 'package:fast_qr_reader_view/fast_qr_reader_view.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:inventory_management/common/utils.dart';

import 'action.dart';
import 'state.dart';

Widget buildView(
    InventoryState state, Dispatch dispatch, ViewService viewService) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Inventory'),
      actions: <Widget>[
        RawMaterialButton(
          textStyle: TextStyle(color: Colors.white),
          child: Text('Save'),
          onPressed: () => dispatch(InventoryActionCreator.save()),
        ),
      ],
    ),
    // bottomNavigationBar: Container(
    //   height: 44,
    //   child: FlatButton(
    //       onPressed: () => dispatch(InventoryActionCreator.onScan()),
    //       child: Column(
    //         children: <Widget>[
    //           Image.asset(
    //             ImageAssets.scan,
    //             color: Colors.black,
    //             width: 20,
    //           ),
    //           Text('scan')
    //         ],
    //       )),
    // ),
    body: Container(
      padding: EdgeInsets.all(16.0),
      child: ListView(
        children: <Widget>[
          Container(
            width: Utils.getScreenWidth(viewService.context),
            height: Utils.getScreenWidth(viewService.context),
            child: () {
              if (state.controller == null ||
                  !state.controller.value.isInitialized) {
                return new Container();
              }
              return Stack(
                children: <Widget>[
                  new Container(
                    width: Utils.getScreenWidth(viewService.context),
                    height: Utils.getScreenWidth(viewService.context),
                    child: AspectRatio(
                      aspectRatio: state.controller.value.aspectRatio,
                      child: new QRReaderPreview(state.controller),
                    ),
                  ),
                  Center(
                    child: SizedBox(
                      height: h(100),
                      width: w(600),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.green, width: 1.0),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }(),
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: TextField(
                  style: TextStyle(color: Color(0Xfff999999)),
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      labelText: 'Tag Number',
                      hintText: 'Please enter tag number',
                      hintStyle:
                          TextStyle(fontSize: 16, color: Color(0XFF999999)),
                      labelStyle: TextStyle(fontSize: 20, color: Colors.black)),
                  controller: state.tagNumber,
                ),
              )
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: TextField(
                  style: TextStyle(color: Color(0Xfff999999)),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    labelText: 'Stock Code',
                    hintText: 'Please enter stock code',
                    hintStyle:
                        TextStyle(fontSize: 16, color: Color(0XFF999999)),
                    labelStyle: TextStyle(fontSize: 20, color: Colors.black),
                  ),
                  controller: state.stockNumber,
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: TextField(
                    style: TextStyle(color: Color(0Xfff999999)),
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        labelText: 'Location',
                        hintText: 'Please enter location',
                        hintStyle:
                            TextStyle(fontSize: 16, color: Color(0XFF999999)),
                        labelStyle:
                            TextStyle(fontSize: 20, color: Colors.black)),
                    controller: state.location),
              )
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: TextField(
                    style: TextStyle(color: Color(0Xfff999999)),
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        labelText: 'Lot Number',
                        hintText: 'Please enter lot number',
                        hintStyle:
                            TextStyle(fontSize: 16, color: Color(0XFF999999)),
                        labelStyle:
                            TextStyle(fontSize: 20, color: Colors.black)),
                    controller: state.lotNumber),
              )
            ],
          ),
          Row(
            children: <Widget>[
              // SizedBox(width: 100, child: Text('QTY')),
              Expanded(
                child: TextField(
                  style: TextStyle(color: Color(0Xfff999999)),
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    labelText: 'QTY',
                    hintText: 'Please enter qty',
                    hintStyle:
                        TextStyle(fontSize: 16, color: Color(0XFF999999)),
                    labelStyle: TextStyle(fontSize: 20, color: Colors.black),
                    suffixIcon: Container(
                      // color: Colors.white,
                      width: 100,
                      child: Row(
                        children: <Widget>[
                          IconButton(
                            icon: Icon(Icons.remove_circle_outline),
                            onPressed: () {
                              dispatch(InventoryActionCreator.subtract());
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.add_circle_outline),
                            onPressed: () {
                              dispatch(InventoryActionCreator.add());
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  controller: state.qty,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
