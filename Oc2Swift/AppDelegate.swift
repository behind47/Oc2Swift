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

    /// 程序载入后
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
        print("程序载入后\(#function)")
        return true
    }
    
    /// app将要进入非活动状态时执行，在此期间，app不接收事件
    public override func applicationWillResignActive(_ application: UIApplication) {
        super.applicationWillResignActive(application)
        print("app将要进入非活动状态时执行，在此期间，app不接收事件\(#function)")
    }
    
    /// app进入活动状态时执行
    public override func applicationDidBecomeActive(_ application: UIApplication) {
        super.applicationDidBecomeActive(application)
        print("app进入活动状态时执行\(#function)")
    }
    
    /// app进入后台
    public override func applicationDidEnterBackground(_ application: UIApplication) {
        super.applicationDidEnterBackground(application)
        print("app进入后台\(#function)")
    }
    
    /// app进入前台
    public override func applicationWillEnterForeground(_ application: UIApplication) {
        super.applicationWillEnterForeground(application)
        print("app进入前台\(#function)")
    }
    
    /// app将要退出时，常用于保存数据和一些退出前的清理工作
    public override func applicationWillTerminate(_ application: UIApplication) {
        super.applicationWillTerminate(application)
        print("app将要退出时，常用于保存数据和一些退出前的清理工作\(#function)")
    }
    
    /// statusBar即将变化时
    public override func application(_ application: UIApplication, willChangeStatusBarFrame newStatusBarFrame: CGRect) {
        super.application(application, willChangeStatusBarFrame: newStatusBarFrame)
        print("statusBar即将变化时\(#function)")
    }
 
    /// statusBar变化完成后执行
    public override func application(_ application: UIApplication, didChangeStatusBarFrame oldStatusBarFrame: CGRect) {
        super.application(application, didChangeStatusBarFrame: oldStatusBarFrame)
        print("statusBar变化完成后执行\(#function)")
    }
    
    /// statusBar方向将要改变时
    public override func application(_ application: UIApplication, willChangeStatusBarOrientation newStatusBarOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        super.application(application, willChangeStatusBarOrientation: newStatusBarOrientation, duration: duration)
        print("statusBar方向将要改变时\(#function)")
    }
    
    /// statusBar方向改变后执行
    public override func application(_ application: UIApplication, didChangeStatusBarOrientation oldStatusBarOrientation: UIInterfaceOrientation) {
        super.application(application, didChangeStatusBarOrientation: oldStatusBarOrientation)
        print("statusBar方向改变后执行\(#function)")
    }
    
    /// 系统时间改变时执行
    public override func applicationSignificantTimeChange(_ application: UIApplication) {
        super.applicationSignificantTimeChange(application)
        print("系统时间改变时执行\(#function)")
    }

    // MARK: UISceneSession Lifecycle

    public override func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

}


import SwiftUI

// This code can be found in the Swift package:
// https://github.com/johnno1962/HotSwiftUI

#if DEBUG
import Combine

private var loadInjectionOnce: () = {
    guard objc_getClass("InjectionClient") == nil else {
        return
    }
    #if os(macOS)
    let bundleName = "macOSInjection.bundle"
    #elseif os(tvOS)
    let bundleName = "tvOSInjection.bundle"
    #elseif targetEnvironment(simulator)
    let bundleName = "iOSInjection.bundle"
    #else
    let bundleName = "maciOSInjection.bundle"
    #endif
    Bundle(path: "/Applications/InjectionIII.app/Contents/Resources/"+bundleName)!.load()
}()

public let injectionObserver = InjectionObserver()

public class InjectionObserver: ObservableObject {
    @Published var injectionNumber = 0
    var cancellable: AnyCancellable? = nil
    let publisher = PassthroughSubject<Void, Never>()
    init() {
        cancellable = NotificationCenter.default.publisher(for:
            Notification.Name("INJECTION_BUNDLE_NOTIFICATION"))
            .sink { [weak self] change in
            self?.injectionNumber += 1
            self?.publisher.send()
        }
    }
}

extension SwiftUI.View {
    public func eraseToAnyView() -> some SwiftUI.View {
        _ = loadInjectionOnce
        return AnyView(self)
    }
    public func loadInjection() -> some SwiftUI.View {
        return eraseToAnyView()
    }
    public func onInjection(bumpState: @escaping () -> ()) -> some SwiftUI.View {
        return self
            .onReceive(injectionObserver.publisher, perform: bumpState)
            .eraseToAnyView()
    }
}
#else
extension SwiftUI.View {
    @inline(__always)
    public func eraseToAnyView() -> some SwiftUI.View { return self }
    @inline(__always)
    public func loadInjection() -> some SwiftUI.View { return self }
    @inline(__always)
    public func onInjection(bumpState: @escaping () -> ()) -> some SwiftUI.View {
        return self
    }
}
#endif
