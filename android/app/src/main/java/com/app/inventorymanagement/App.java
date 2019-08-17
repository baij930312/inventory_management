package com.app.inventorymanagement;

import android.content.Context;

import io.flutter.app.FlutterApplication;

/**
 * Created by Administrator
 *
 * @author 猿史森林
 *         Date: 2017/11/28
 *         Class description:
 */
public class App extends FlutterApplication {

    private static Context mContext;

    @Override
    public void onCreate() {
        super.onCreate();
        mContext = getApplicationContext();
    }

    public static Context getContext() {
        return mContext;
    }
}
