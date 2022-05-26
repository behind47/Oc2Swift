//
//  PlatformPlugin.swift
//  Oc2Swift
//
//  Created by behind47 on 2022/5/23.
//

import Flutter
import UIKit

public class SwiftLearnflutterPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "learnflutter", binaryMessenger: registrar.messenger())
    let instance = SwiftLearnflutterPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    result("iOS " + UIDevice.current.systemVersion)
  }
}
