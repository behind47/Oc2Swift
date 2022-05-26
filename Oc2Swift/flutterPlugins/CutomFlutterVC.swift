//
//  CutomFlutterVC.swift
//  Oc2Swift
//
//  Created by behind47 on 2022/5/23.
//

import Foundation
import Flutter

class CustomFlutterVC : FlutterViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
//        没有效果，注册失败
//        FlutterMethodChannel(name: "platform", binaryMessenger: self.binaryMessenger).setMethodCallHandler({
//              (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
//          // Note: this method is invoked on the UI thread.
//          // Handle battery messages.
//            switch call.method {
//            case "getBatteryLevel":
//                self.receiveBatteryLevel(result: result)
//                break
//            case "getPlatformVersion":
//                result("iOS " + UIDevice.current.systemVersion)
//                break
//            default:
//                result(FlutterMethodNotImplemented)
//                break
//            }
//        })
    }
    
//    private func receiveBatteryLevel(result: FlutterResult) {
//        let device = UIDevice.current
//        device.isBatteryMonitoringEnabled = true
//        if device.batteryState == UIDevice.BatteryState.unknown {
//            result(FlutterError(code: "UNAVAILABLE", message: "Battery info unavailable", details: nil))
//        } else {
//            result(Int(device.batteryLevel * 100))
//        }
//    }
}
