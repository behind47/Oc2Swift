//
//  ReviewInWindowVC.swift
//  Oc2Swift
//
//  Created by behind47 on 2023/4/26.
//
/// 记录一个问题：创建UIWindow对象，并调用makeKeyAndVisible()，但是从图层debug模式上看，它没有被添加到图层树上。
/// 原因：
/// iOS13.0之后的UIWindowScene，在原来APP直属Window UI下增加了一个更加细粒度的UI管理器UIScene
/// 自定义的window必须注册到SceneDelegate中

import Foundation
import SwiftUI

class ReviewInWindowVC : UIViewController {
    var testWindow : UIWindow!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        ReviewInWindow.sharedInstance.show()
        testWindow = UIWindow()
        testWindow.windowLevel = UIWindow.Level.statusBar + 55
        testWindow.isHidden = false
        testWindow.frame = CGRect(x: 0, y: 0, width: SCREENWIDTH, height: SCREENHEIGHT)
        testWindow.backgroundColor = .green
        UIApplication.shared.connectedScenes.forEach { scene in
            if scene.activationState == UIScene.ActivationState.foregroundActive {
                testWindow.windowScene = scene as? UIWindowScene
            }
        }
    }
}

private class ReviewInWindow : UIWindow {
    
    static let sharedInstance = ReviewInWindow(frame: UIApplication.shared.windows.first?.frame ?? CGRect.zero)
    var infoPanel : UIView?
    
    private override init(frame: CGRect) {
        infoPanel = UIView()
        infoPanel?.backgroundColor = .green
        super.init(frame: frame)
        windowLevel = UIWindow.Level.statusBar + 55
        backgroundColor = .yellow
//        self.addSubview(infoPanel!)
//        infoPanel!.snp.makeConstraints { make in
//            make.center.equalTo(CGPoint(x: self.frame.width/2, y: self.frame.height/2))
//            make.width.height.equalTo(60)
//        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func show() {
        isHidden = false
    }
    
    func hide() {
        isHidden = true
    }
}
