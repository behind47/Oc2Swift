//
//  Device.swift
//  Oc2Swift
//
//  Created by behind47 on 2022/7/29.
//

import Foundation

public struct Device {
    static var statusBarHeight : CGFloat!
    
    static var safeTopHeight : CGFloat!
    static var safeBottomHeight : CGFloat!
}

/// 获取最顶层的ViewController
/// 应用场景：1. presenVC需要用最顶层的ViewController，否则会报错。
func topViewController() -> UIViewController? {
    guard let rootVC = UIApplication.shared.windows.first?.rootViewController else { return nil }
    return _topViewController(viewController: rootVC)
}

private func _topViewController(viewController: UIViewController?) -> UIViewController? {
    guard let vc = viewController else { return viewController }
    if vc.isKind(of: UINavigationController.self) {
        let navVC = vc as! UINavigationController
        return _topViewController(viewController: navVC.topViewController)
    } else if vc.isKind(of: UITabBarController.self) {
        let tabVC = vc as! UITabBarController
        return _topViewController(viewController: tabVC.selectedViewController)
    } else {
        return vc
    }
}

let SCREENWIDTH = UIScreen.main.bounds.size.width
let SCREENHEIGHT = UIScreen.main.bounds.size.height
