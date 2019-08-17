package com.app.printer;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;



/**
 * PrinterPlugin
 */
public class PrinterPlugin implements MethodCallHandler {
    public static void registerWith(Registrar registrarFor) {

    }

    @Override
    public void onMethodCall(MethodCall methodCall, Result result) {

    }

    // /**
    //  * Plugin registration.
    //  */
    // private BluetoothAdapter mBluetoothAdapter;
    //
    // public static void registerWith(Registrar registrar) {
    //     final MethodChannel channel = new MethodChannel(registrar
    //             .messenger(), "plugins.flutter.io/printer_method");
    //     channel.setMethodCallHandler(new PrinterPlugin());
    // }
    //
    // @Override
    // public void onMethodCall(MethodCall call, Result result) {
    //     if (call.method.equals("connect")) {
    //         result.success("Android " + Build.VERSION.RELEASE);
    //     } else if (call.method.equals("start")) {
    //
    //         if (mBluetoothAdapter.isDiscovering()) {
    //             mBluetoothAdapter.cancelDiscovery();
    //         }
    //         // Request discover from BluetoothAdapter
    //         mBluetoothAdapter.startDiscovery();
    //
    //     } else if (call.method.equals("stop")) {
    //     } else if (call.method.equals("print")) {
    //         // this.print((HashMap<String, Object>) call.arguments);
    //     } else {
    //         result.notImplemented();
    //     }
    // }
    //
    // private void print(HashMap<String, Object> args) {
    //     if (args.get("type").equals("std")) {
    //         // TODO
    //     } else if (args.get("type").equals("stk")) {
    //         final HashMap<String, Object> data = (HashMap<String, Object>) args.get("data");
    //         final int count = (int) data.get("count");
    //
    //         final LabelCommand tsc = new LabelCommand();
    //         this.printAllInfoLabel(tsc, data);
    //         tsc.addPrint(count);
    //         DeviceConnFactoryManager
    //                 .getDeviceConnFactoryManagers()[0]
    //                 .sendDataImmediately(tsc.getCommand());
    //     } else {
    //     }
    //
    // }
    //
    // private LabelCommand printAllInfoLabel(LabelCommand tsc, HashMap<String, Object> data) {
    //     //configuration
    //     tsc.addDensity(LabelCommand.DENSITY.DNESITY15);
    //     tsc.addSize(75, 50);
    //     tsc.addGap(2);
    //     tsc.addDirection(LabelCommand.DIRECTION.FORWARD, LabelCommand.MIRROR.NORMAL);
    //     tsc.addQueryPrinterStatus(LabelCommand.RESPONSE_MODE.ON);
    //     tsc.addReference(0, 0);
    //     tsc.addTear(EscCommand.ENABLE.ON);
    //     tsc.addCls();
    //     tsc.addPrint(1, 1);
    //     tsc.addSound(2, 100);
    //
    //     //format
    //     tsc.addBox(0, 20, 560, 390, 1);
    //     tsc.addBox(0, 20, 560, 150, 1);
    //     tsc.addBox(0, 20, 560, 270, 1);
    //     tsc.addBox(0, 270, 260, 390, 1);
    //     tsc.addBox(260, 270, 400, 390, 1);
    //
    //     //TOP LEFT
    //     tsc.addText(5, 24, LabelCommand.FONTTYPE.FONT_1, LabelCommand.ROTATION.ROTATION_0, LabelCommand.FONTMUL.MUL_1, LabelCommand.FONTMUL.MUL_1, "STOCK NO.");
    //     tsc.addText(25, 48, LabelCommand.FONTTYPE.FONT_4, LabelCommand.ROTATION.ROTATION_0, LabelCommand.FONTMUL.MUL_1, LabelCommand.FONTMUL.MUL_1, "P091046000AB");
    //     tsc.add1DBarcode(25, 86, LabelCommand.BARCODETYPE.CODE128, 40, LabelCommand.READABEL.DISABLE, LabelCommand.ROTATION.ROTATION_0, 3, 5
    //             , "P091046000AB");
    //
    //     // Middle
    //     tsc.addText(25, 179, LabelCommand.FONTTYPE.FONT_3, LabelCommand.ROTATION.ROTATION_0, LabelCommand.FONTMUL.MUL_1, LabelCommand.FONTMUL.MUL_1, "CHILD SEAT TETHER BRACKET CHILD ");
    //     tsc.addText(25, 215, LabelCommand.FONTTYPE.FONT_3, LabelCommand.ROTATION.ROTATION_0, LabelCommand.FONTMUL.MUL_1, LabelCommand.FONTMUL.MUL_1, "CHILD SEAT TETHER BRACKET CHILD ");
    //
    //
    //     // tsc.addText(508, 128, LabelCommand.FONTTYPE.FONT_2, LabelCommand.ROTATION.ROTATION_0, LabelCommand.FONTMUL.MUL_1, LabelCommand.FONTMUL.MUL_1, "EA");
    //
    //
    //     //BOTTOM LEFT
    //     tsc.addText(5, 274, LabelCommand.FONTTYPE.FONT_1, LabelCommand.ROTATION.ROTATION_0, LabelCommand.FONTMUL.MUL_1, LabelCommand.FONTMUL.MUL_1, "LOT NO.");
    //     tsc.addText(25, 298, LabelCommand.FONTTYPE.FONT_3, LabelCommand.ROTATION.ROTATION_0, LabelCommand.FONTMUL.MUL_1, LabelCommand.FONTMUL.MUL_1, "050718");
    //     tsc.add1DBarcode(25, 330, LabelCommand.BARCODETYPE.CODE128, 50, LabelCommand.READABEL.DISABLE, LabelCommand.ROTATION.ROTATION_0, 2, 4, "050718");
    //
    //     //BOTTOM Middle
    //     tsc.addText(265, 274, LabelCommand.FONTTYPE.FONT_1, LabelCommand.ROTATION.ROTATION_0, LabelCommand.FONTMUL.MUL_1, LabelCommand.FONTMUL.MUL_1, "QTY");
    //     tsc.addText(290, 320, LabelCommand.FONTTYPE.FONT_4, LabelCommand.ROTATION.ROTATION_0, LabelCommand.FONTMUL.MUL_1, LabelCommand.FONTMUL.MUL_1, "49");
    //
    //     //BOTTOM RIGHT
    //     tsc.addText(405, 274, LabelCommand.FONTTYPE.FONT_1, LabelCommand.ROTATION.ROTATION_0, LabelCommand.FONTMUL.MUL_1, LabelCommand.FONTMUL.MUL_1, "LOCATION");
    //     tsc.addText(435, 320, LabelCommand.FONTTYPE.FONT_4, LabelCommand.ROTATION.ROTATION_0, LabelCommand.FONTMUL.MUL_1, LabelCommand.FONTMUL.MUL_1, "PP00");
    //     return tsc;
    // }
    //
    // @Override
    // public void onReceive(Context context, Intent intent) {
    //     Toast.makeText(context,"开机启动！",Toast.LENGTH_LONG).show();
    //
    // }
}
