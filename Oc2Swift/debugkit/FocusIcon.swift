//
//  FocusIcon.swift
//  Oc2Swift
//
//  Created by behind47 on 2023/4/3.
/// 组件检查工具，用来定位组件的⭕️。
/// 包含一个⭕️——focusView，一个显示组件信息的panel——focusPanel
///
/// 需要解决的问题：
/// 1. 从根视图开始做BFS，可以找到最接近focusView的级。但是同一级上有多层重叠的view，如何判断哪一个view在上面呢？
/// 2. focusView所在的window上的坐标，和view所在的vc.view里的坐标似乎不是一个坐标轴的。用view的frame判断focusView是否在其中，存在误差。在scrollView里的view也会有误差。有系统API可以直接获取view在window坐标系里的坐标吗？还是只能从根视图开始计算view的坐标呢？

import Foundation
import SwiftUI
import SnapKit

/// 找到FocusIcon定位坐标上，最上层的UIView，最上层包含层与级两个概念
class FocusIcon : UIView {
    static let shared = FocusIcon()
    var debugMenu : FocusIcon!
    var focusView : UIView
    var focusPanel : UIView
    var focusLabel : UILabel
    var targetView : UIView?
    let closeBtn : UIButton
    
    private init() {
        focusView = UIView()
        focusPanel = UIView()
        focusLabel = UILabel()
        closeBtn = UIButton()
        super.init(frame: CGRect.zero)
        guard let topView = UIApplication.shared.windows.first else {return}
        topView.addSubview(self)
        self.snp.makeConstraints { make in
            make.edges.equalTo(topView)
        }
        topView.bringSubviewToFront(self) // 把self放在window上，以便全局展示
        topView.backgroundColor = .gray
        
        addSubview(focusView)
        focusView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(drageMove)))
        focusView.backgroundColor = .red
        focusView.snp.makeConstraints { make in
            make.center.equalTo(self)
            make.width.height.equalTo(50)
        }
        
        addSubview(focusPanel)
        focusPanel.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(drageMove)))
        focusPanel.backgroundColor = .green
        focusPanel.snp.makeConstraints { make in
            make.left.equalTo(self).offset(20)
            make.right.bottom.equalTo(self).offset(-20)
        }
        
        focusPanel.addSubview(focusLabel)
        focusPanel.setContentHuggingPriority(UILayoutPriority.required, for: NSLayoutConstraint.Axis.vertical)
        focusLabel.snp.makeConstraints { make in
            make.left.top.equalTo(focusPanel).offset(10)
            make.right.bottom.equalTo(focusPanel).offset(-10)
            make.height.equalTo(focusLabel)
        }
        
        focusPanel.addSubview(closeBtn)
        closeBtn.setBackgroundImage(UIImage(named: "close.png"), for: UIControl.State.normal)
        closeBtn.addTarget(self, action: #selector(closeFocusIcon), for: UIControl.Event.touchUpInside)
        closeBtn.snp.makeConstraints { make in
            make.right.equalTo(focusPanel).offset(-5)
            make.top.equalTo(focusPanel).offset(5)
            make.width.height.equalTo(10)
        }
        
        isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Event
    @objc func closeFocusIcon() {
        isHidden = true
    }
    
    @objc func drageMove(_ recognizer : UIPanGestureRecognizer) {
        guard let sender = recognizer.view else { return }
        let translation = recognizer.translation(in: sender) // 点击位置与sender原来位置的偏移值
        
        if recognizer.state == UIPanGestureRecognizer.State.changed {
            sender.center = CGPoint(x: sender.center.x + translation.x, y: sender.center.y + translation.y)
            recognizer.setTranslation(CGPoint.zero, in: sender)
        }
    }
    
    var viewArr : [UIView] = []
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let topView = UIApplication.shared.windows.first else {return}
        var tmpView : UIView = topView
        /// 从根节点开始，遍历每一个层级，找到包含point的层级最高的view
        var array = Array<UIView>()
        array.append(tmpView)
        while array.count > 0 {
            tmpView = array.popLast()!
            tmpView.subviews.forEach { view in
                if point(point: focusView.center, inside: view) {
                    array.append(view)
                }
            }
        }
        targetView = tmpView
        updateDetail()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    /// point是否在view里
    func point(point: CGPoint, inside view: UIView) -> Bool {
        /// 先把view的坐标换算到point所在坐标系，即window坐标系
        var x = view.frame.origin.x
        var y = view.frame.origin.y
        /// 递归到Window，计算view左上角相对于window左上角的偏移量
        var tmpView = view.superview
        while !(tmpView?.isKind(of: UIWindow.self) ?? true) {
            x += tmpView!.frame.origin.x
            y += tmpView!.frame.origin.y
            if tmpView!.isKind(of: UIScrollView.self) {
                let tmpScrollView = tmpView as! UIScrollView
                x -= tmpScrollView.contentOffset.x
                y -= tmpScrollView.contentOffset.y
            }
            tmpView = tmpView!.superview
        }
        if x < point.x && x + view.frame.size.width > point.x
            && y < point.y && y + view.frame.size.height > point.y {
            return true
        }
        return false
    }
    
    /// 更新显示的信息
    func updateDetail() {
        guard let view = targetView else {return}
        view.backgroundColor = .systemPink // TODO: 用边框代替背景色
        focusLabel.text = "\(view.self)"
        focusLabel.numberOfLines = 0
    }
    
}
