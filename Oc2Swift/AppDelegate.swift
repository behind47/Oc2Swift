//
//  AppDelegate.swift
//  Oc2Swift
//
//  Created by behind47 on 2022/5/18.
//

import UIKit
import Flutter
import FlutterPluginRegistrant

@UIApplicationMain
@objcMembers
public class AppDelegate: FlutterAppDelegate {

    lazy var flutterEngine = FlutterEngine(name: "behind47 engine")

    public override func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        #if DEBUG
        do {
            let injectionBundle = Bundle.init(path: "/Users/behind47/Downloads/InjectionIII.app/Contents/Resources/iOSInjection.bundle")
            if let bundle = injectionBundle {
                try bundle.loadAndReturnError()
            } else {
                debugPrint("Injection注入失败,未能检测到Injection")
            }
        } catch {
            debugPrint("Injection注入失败\(error)")
        }
        #endif
//        GeneratedPluginRegistrant.register(with: self)
        self.flutterEngine.run()
        return true
    }

    // MARK: UISceneSession Lifecycle

    public override func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

}

