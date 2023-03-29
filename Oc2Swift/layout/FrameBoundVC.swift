//
//  FrameBoundVC.swift
//  Oc2Swift
//
//  Created by behind47 on 2022/7/15.
//
/// 测试一下bound修改origin会移动子view的位置
/// 1. 修改bounds.origin，是修改了superView的坐标原点
/// 2. childView的frame是childView左上角（而不是childView自身坐标系原点）相对于superView的坐标原点的位置
/// 所以在相对位置不变但是参考原点修改的情况下，childView的位置会变
/// UIView自身的坐标系原点不一定是UIView左上角，只是默认情况下重合，
/// 修改自身坐标系原点不影响左上角在父坐标系里的位置，即修改bounds.origin不影响frame.origin

import Foundation
import UIKit

open class FrameBoundVC : BaseVC {
    open override func viewDidLoad() {
        super.viewDidLoad()
        let superView = UIView(frame: CGRect(x: 0, y: 100, width: 200, height: 100))
        self.view.addSubview(superView)
        superView.backgroundColor = .white
        let childView = UIView();
        superView.addSubview(childView)
        childView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        childView.backgroundColor = .green
        superView.bounds.origin = CGPoint(x: -20, y: -10)
        print("childView.bounds : \(childView.bounds) superView.bounds: \(superView.bounds)")
        childView.bounds.origin = CGPoint(x: -20, y: -10)
        print("childView.bounds : \(childView.bounds) childView.frame: \(childView.frame)")
    }
}
