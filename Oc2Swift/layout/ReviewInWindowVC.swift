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

//class ReviewInWindowVC : UIViewController {
//    var testWindow : UIWindow!
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        ReviewInWindow.sharedInstance.show()
//    }
//}
//
//private class ReviewInWindow : UIWindow {
//    
//    static let sharedInstance = ReviewInWindow(frame: UIApplication.shared.windows.first?.frame ?? CGRect.zero)
//    var infoPanel : UIView?
//    
//    private override init(frame: CGRect) {
//        infoPanel = UIView()
//        infoPanel?.backgroundColor = .green
//        super.init(frame: frame)
//        windowLevel = UIWindow.Level.statusBar + 55
//        backgroundColor = .yellow
//        UIApplication.shared.connectedScenes.forEach { scene in
//            if scene.activationState == UIScene.ActivationState.foregroundActive {
//                windowScene = scene as? UIWindowScene
//            }
//        }
//        self.addSubview(infoPanel!)
//        infoPanel!.snp.makeConstraints { make in
//            make.center.equalTo(CGPoint(x: self.frame.width/2, y: self.frame.height/2))
//            make.width.height.equalTo(60)
//        }
//        let pan = UIPanGestureRecognizer(target: self, action: #selector(drageMove(_:)))
//        infoPanel?.addGestureRecognizer(pan)
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    func show() {
//        isHidden = false
//    }
//    
//    func hide() {
//        isHidden = true
//    }
//    
//    // MARK: event
//    @objc func drageMove(_ recognizer : UIPanGestureRecognizer) {
//        guard let sender = recognizer.view else { return }
//        let translation = recognizer.translation(in: sender) // 点击位置与sender原来位置的偏移值
//        
//        if recognizer.state == UIPanGestureRecognizer.State.changed {
//            sender.snp.updateConstraints { make in
//                make.center.equalTo(CGPoint(x: sender.center.x + translation.x, y: sender.center.y + translation.y))
//            }
//            recognizer.setTranslation(CGPoint.zero, in: sender)
//        }
//    }
//}
