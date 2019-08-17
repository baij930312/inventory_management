package com.app.inventorymanagement;

import android.Manifest;
import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothDevice;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.pm.PackageManager;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.Bundle;
import android.util.Log;


import com.gprinter.command.EscCommand;
import com.gprinter.command.LabelCommand;

import java.io.ByteArrayInputStream;
import java.io.InputStream;
import java.lang.ref.SoftReference;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.Set;

import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;
import androidx.multidex.MultiDex;
import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.BasicMessageChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.StandardMessageCodec;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {

    private static final int REQUEST_CODE = 0x004;

    BasicMessageChannel<Object> mMapBasicMessageChannel = null;

    public static final String ACTION_USB_ACCESSORY_ATTACHED = "android.hardware.usb.action.USB_ACCESSORY_ATTACHED";
    public static final String ACTION_USB_ACCESSORY_DETACHED = "android.hardware.usb.action.USB_ACCESSORY_DETACHED";
    public static final String ACTION_USB_DEVICE_ATTACHED = "android.hardware.usb.action.USB_DEVICE_ATTACHED";
    public static final String ACTION_USB_DEVICE_DETACHED = "android.hardware.usb.action.USB_DEVICE_DETACHED";
    public static final String ACTION_USB_PERMISSION = "com.android.example.USB_PERMISSION";
    public static final String ACTION_QUERY_PRINTER_STATE = "action_query_printer_state";
    public static final int CONN_STATE_DISCONNECT = 0x90;
    public static final String ACTION_CONN_STATE = "action_connect_state";
    private String[] permissions = {
            Manifest.permission.ACCESS_FINE_LOCATION,
            Manifest.permission.ACCESS_COARSE_LOCATION,
            Manifest.permission.BLUETOOTH
    };
    ArrayList<String> per = new ArrayList<>();


    public static final int CONN_STATE_FAILED = CONN_STATE_DISCONNECT << 2;


    final Map<String, String> bluetoothDevices = new HashMap<>();

    BroadcastReceiver receiver = new BroadcastReceiver() {
        @Override
        public void onReceive(Context context, Intent intent) {

            final String action = intent.getAction();
            Log.d("11111", "onReceive: action=" + action);
            if (BluetoothAdapter.ACTION_DISCOVERY_FINISHED.equals(action)) {
                Set<Map.Entry<String, String>> entries = bluetoothDevices.entrySet();
                ArrayList<HashMap<String, String>> devices = new ArrayList<>();
                for (Map.Entry<String, String> entry : entries) {
                    HashMap<String, String> device = new HashMap<>();
                    device.put("name", entry.getValue());
                    device.put("uuid", entry.getKey());
                    devices.add(device);
                }
                HashMap<String, Object> map = new HashMap<>();
                map.put("code", 0);
                map.put("data", devices);
                map.put("type", "data");
                mMapBasicMessageChannel.send(map);
            } else if (BluetoothDevice.ACTION_FOUND.equals(action)) {
                BluetoothDevice bluetoothDevice = intent
                        .getParcelableExtra(BluetoothDevice.EXTRA_DEVICE);
                final String name = bluetoothDevice.getName();
                String address = bluetoothDevice.getAddress();
                if (name == null || address == null) {
                    return;
                }
                bluetoothDevices.put(address, name);

                Set<Map.Entry<String, String>> entries = bluetoothDevices.entrySet();
                ArrayList<HashMap<String, String>> devices = new ArrayList<>();
                for (Map.Entry<String, String> entry : entries) {
                    HashMap<String, String> device = new HashMap<>();
                    device.put("name", entry.getValue());
                    device.put("uuid", entry.getKey());
                    devices.add(device);
                }
                HashMap<String, Object> map = new HashMap<>();
                map.put("code", 0);
                map.put("data", devices);
                map.put("type", "data");
                mMapBasicMessageChannel.send(map);
            } else if (BluetoothAdapter.ACTION_STATE_CHANGED.equals(action)) {
                final int state = intent.getIntExtra(BluetoothAdapter.EXTRA_STATE, -1);
                String stateStr;
                int code;
                if (BluetoothAdapter.STATE_ON == state) {
                    stateStr = "Bluetooth powered on.";
                    code = 1;
                } else if (BluetoothAdapter.STATE_OFF == state) {
                    stateStr = "Bluetooth powered off.";
                    code = 2;
                } else {
                    return;
                }
                HashMap<String, Object> map = new HashMap<>();
                map.put("code", code);
                map.put("data", stateStr);
                map.put("type", "state");
                mMapBasicMessageChannel.send(map);
            } else if (BluetoothAdapter.ACTION_CONNECTION_STATE_CHANGED.equals(action)) {
                HashMap<String, Object> map = new HashMap<>();
                final int state = intent.getIntExtra(BluetoothAdapter.EXTRA_CONNECTION_STATE, -1);
                String stateStr;
                int code;
                if (BluetoothAdapter.STATE_CONNECTED == state) {
                    stateStr = "connected";
                    code = -1;
                } else if (BluetoothAdapter.STATE_CONNECTING == state) {
                    stateStr = "connecting...";
                    code = -2;
                } else if (BluetoothAdapter.STATE_DISCONNECTED == state) {
                    stateStr = "disconnected";
                    code = -3;
                } else if (BluetoothAdapter.STATE_DISCONNECTING == state) {
                    stateStr = "disconnecting";
                    code = -4;
                } else {
                    return;
                }
                map.put("code", code);
                map.put("data", stateStr);
                map.put("type", "state");
                mMapBasicMessageChannel.send(map);
            }
        }
    };
    private BluetoothAdapter mBluetoothAdapter = BluetoothAdapter.getDefaultAdapter();

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        GeneratedPluginRegistrant.registerWith(this);
        mMapBasicMessageChannel = new BasicMessageChannel<>(
                getFlutterView(),
                "plugins.flutter.io/printer_message",
                StandardMessageCodec.INSTANCE);


        IntentFilter filter = new IntentFilter();
        filter.addAction(BluetoothDevice.ACTION_FOUND);
        filter.addAction(BluetoothAdapter.ACTION_DISCOVERY_FINISHED);
        filter.addAction(BluetoothAdapter.ACTION_CONNECTION_STATE_CHANGED);
        filter.addAction(BluetoothAdapter.ACTION_STATE_CHANGED);
        // filter.addAction(ACTION_CONN_STATE);
        // filter.addAction(BluetoothAdapter.ACTION_DISCOVERY_FINISHED);
        registerReceiver(receiver, filter);

        new MethodChannel(getFlutterView(), "plugins.flutter.io/printer_method")
                .setMethodCallHandler(new MethodChannel.MethodCallHandler() {
                    @Override
                    public void onMethodCall(MethodCall call, MethodChannel.Result result) {
                        if (call.method.equals("connect")) {
                            int id = 1;
                            new DeviceConnFactoryManager.Build()
                                    .setId(id)
                                    //设置连接方式
                                    .setConnMethod(DeviceConnFactoryManager.CONN_METHOD.BLUETOOTH)
                                    //设置连接的蓝牙mac地址
                                    .setMacAddress(call.arguments.toString())
                                    .build();
                            //打开端口
                            DeviceConnFactoryManager.getDeviceConnFactoryManagers()[id].openPort();
                            HashMap<String, Object> map = new HashMap<>();
                            map.put("code", 0);
                            map.put("data", "");
                            map.put("message", "");
                            result.success(map);
                        } else if (call.method.equals("start")) {

                            if (mBluetoothAdapter.isDiscovering()) {
                                mBluetoothAdapter.cancelDiscovery();
                            }
                            // Request discover from BluetoothAdapter
                            mBluetoothAdapter.startDiscovery();

                        } else if (call.method.equals("stop")) {
                        } else if (call.method.equals("print")) {
                            // this.print((HashMap<String, Object>) call.arguments);
                            HashMap<String, Object> arguments = (HashMap<String, Object>) call.arguments;
                            print(arguments);
                        } else {
                            result.notImplemented();
                        }
                    }
                });

        this.checkPermission();
        this.requestPermission();

    }

    @Override
    protected void attachBaseContext(Context base) {
        super.attachBaseContext(base);
        MultiDex.install(this);
    }

    @Override
    protected void onStart() {
        super.onStart();


    }

    private void checkPermission() {
        for (String permission : permissions) {
            if (PackageManager.PERMISSION_GRANTED != ContextCompat
                    .checkSelfPermission(this, permission)) {
                per.add(permission);
            }
        }
    }

    private void requestPermission() {
        if (per.size() > 0) {
            String[] p = new String[per.size()];
            ActivityCompat.requestPermissions(this, per.toArray(p), REQUEST_CODE);
        }
    }

    private void print(HashMap<String, Object> args) {
        if ("std".equals(args.get("type"))) {
            final ArrayList<HashMap<String, Object>> data = (ArrayList<HashMap<String, Object>>) args.get("data");
            for (HashMap<String, Object> item: data){
                int count = (int) item.get("count");
                byte[] imageData = (byte[]) item.get("imageData");
                final LabelCommand tsc = new LabelCommand();
                tsc.addSize(100, 300);
                tsc.addGap(2);
                tsc.addQueryPrinterStatus(LabelCommand.RESPONSE_MODE.BATCH);
                tsc.addReference(0, 0);
                tsc.addTear(EscCommand.ENABLE.ON);
                tsc.addCls();
                Bitmap bitmap = null;

                byte[] imgByte = imageData;
                InputStream input = null;
                BitmapFactory.Options options=new BitmapFactory.Options();
                options.inSampleSize = 8;
                input = new ByteArrayInputStream(imgByte);
                 SoftReference softRef = new SoftReference(BitmapFactory.decodeStream(input, null, options));
                bitmap = (Bitmap)softRef.get();
                tsc.addBitmap(100, 30, 300, bitmap);

                tsc.addPrint(count);
                DeviceConnFactoryManager
                        .getDeviceConnFactoryManagers()[1]
                        .sendDataImmediately(tsc.getCommand());
            }
        } else if (args.get("type").equals("stk")) {
            final HashMap<String, Object> data = (HashMap<String, Object>) args.get("data");
            final int count = (int) data.get("count");

            final LabelCommand tsc = new LabelCommand();
            this.printAllInfoLabel(tsc, data);
            tsc.addPrint(count);
            DeviceConnFactoryManager
                    .getDeviceConnFactoryManagers()[1]
                    .sendDataImmediately(tsc.getCommand());
        }

    }

    private void printImage(LabelCommand tsc, HashMap<String, Object> data) {

    }


    private LabelCommand printAllInfoLabel(LabelCommand tsc, HashMap<String, Object> data) {
        //configuration
        tsc.addDensity(LabelCommand.DENSITY.DNESITY15);
        tsc.addSize(75, 50);
        tsc.addGap(2);
        tsc.addDirection(LabelCommand.DIRECTION.FORWARD, LabelCommand.MIRROR.NORMAL);
        tsc.addQueryPrinterStatus(LabelCommand.RESPONSE_MODE.ON);
        tsc.addReference(0, 0);
        tsc.addTear(EscCommand.ENABLE.ON);
        tsc.addCls();

        tsc.addSound(2, 100);

        //format
        tsc.addBox(0, 20, 560, 390, 1);
        tsc.addBox(0, 20, 560, 150, 1);
        tsc.addBox(0, 20, 560, 270, 1);
        tsc.addBox(0, 270, 260, 390, 1);
        tsc.addBox(260, 270, 400, 390, 1);

        //TOP LEFT
        tsc.addText(5, 24, LabelCommand.FONTTYPE.FONT_1, LabelCommand.ROTATION.ROTATION_0, LabelCommand.FONTMUL.MUL_1, LabelCommand.FONTMUL.MUL_1, "STOCK NO.");
        tsc.addText(25, 48, LabelCommand.FONTTYPE.FONT_4, LabelCommand.ROTATION.ROTATION_0, LabelCommand.FONTMUL.MUL_1, LabelCommand.FONTMUL.MUL_1,
                data.get("part_no_to_show").toString());
        tsc.add1DBarcode(25, 86, LabelCommand.BARCODETYPE.CODE128, 40, LabelCommand.READABEL.DISABLE, LabelCommand.ROTATION.ROTATION_0, 3, 5
                , data.get("part_no").toString());

        // Middle
        tsc.addText(25, 179, LabelCommand.FONTTYPE.FONT_3, LabelCommand.ROTATION.ROTATION_0, LabelCommand.FONTMUL.MUL_1, LabelCommand.FONTMUL.MUL_1, data
                .get("desc").toString());
        // tsc.addText(25, 215, LabelCommand.FONTTYPE.FONT_3, LabelCommand.ROTATION.ROTATION_0, LabelCommand.FONTMUL.MUL_1, LabelCommand.FONTMUL.MUL_1, "CHILD SEAT TETHER BRACKET CHILD ");

        //BOTTOM LEFT
        tsc.addText(5, 274, LabelCommand.FONTTYPE.FONT_1, LabelCommand.ROTATION.ROTATION_0, LabelCommand.FONTMUL.MUL_1, LabelCommand.FONTMUL.MUL_1, "LOT NO.");
        tsc.addText(25, 298, LabelCommand.FONTTYPE.FONT_3, LabelCommand.ROTATION.ROTATION_0, LabelCommand.FONTMUL.MUL_1, LabelCommand.FONTMUL.MUL_1, data.get("lot_to_show").toString());
        tsc.add1DBarcode(25, 330, LabelCommand.BARCODETYPE.CODE128, 50, LabelCommand.READABEL.DISABLE, LabelCommand.ROTATION.ROTATION_0, 2, 4,
                data.get("lot").toString());

        //BOTTOM Middle
        tsc.addText(265, 274, LabelCommand.FONTTYPE.FONT_1, LabelCommand.ROTATION.ROTATION_0, LabelCommand.FONTMUL.MUL_1, LabelCommand.FONTMUL.MUL_1, "QTY");
        tsc.addText(290, 320, LabelCommand.FONTTYPE.FONT_4, LabelCommand.ROTATION.ROTATION_0, LabelCommand.FONTMUL.MUL_1, LabelCommand.FONTMUL.MUL_1, data.get("sap_qty").toString());

        //BOTTOM RIGHT
        tsc.addText(405, 274, LabelCommand.FONTTYPE.FONT_1, LabelCommand.ROTATION.ROTATION_0, LabelCommand.FONTMUL.MUL_1, LabelCommand.FONTMUL.MUL_1, "LOCATION");
        tsc.addText(435, 320, LabelCommand.FONTTYPE.FONT_4, LabelCommand.ROTATION.ROTATION_0, LabelCommand.FONTMUL.MUL_1, LabelCommand.FONTMUL.MUL_1, data.get("loc_to_show").toString());
        return tsc;
    }
}
