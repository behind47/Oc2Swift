//
//  AutoLayoutTestVC.swift
//  Oc2Swift
//
//  Created by behind47 on 2022/7/3.
//
/// 测试iOS约束布局流程的类
/// 1. vc触发viewLayoutMarginsDidChange——为什么是两次？与vc.view addSubView的次数无关
/// 2. 自底向上更新约束，UIView.updateConstraints, UIViewController.updateViewConstraints
/// 3. 自顶向下更新布局，UIViewController.viewDidLayoutSubviews, UIView.layoutSubviews
/// 4. 2、3的更新是DFS的方式

import Foundation
import UIKit
import SnapKit

open class AutoLayoutTestVC : BaseVC {
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .green
        let autoTopicView = AutoTopicView()
        self.view.addSubview(autoTopicView)
        autoTopicView.snp.makeConstraints { make in
            make.left.right.equalTo(self.view)
            make.top.equalTo(self.view).offset(200)
        }
        
        let title = UILabel()
        title.text = "title"
        self.view.addSubview(title)
        title.snp.makeConstraints { make in
            make.left.right.equalTo(self.view)
            make.top.equalTo(autoTopicView.snp.bottom)
        }
        
        let subTitle = UILabel()
        subTitle.text = "subTitle"
        self.view.addSubview(subTitle)
        subTitle.snp.makeConstraints { make in
            make.left.right.equalTo(self.view)
            make.top.equalTo(title.snp.bottom)
        }
        
        let autoTopicView2 = AutoTopicView()
        self.view.addSubview(autoTopicView2)
        autoTopicView2.snp.makeConstraints { make in
            make.left.right.equalTo(self.view)
            make.top.equalTo(subTitle.snp.bottom)
        }
    }
    
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        NSLog("\(#file) \(String(describing: object_getClass(self))) \(#function)")// step 6
    }
    
    open override func viewLayoutMarginsDidChange() {
        super.viewLayoutMarginsDidChange()
        NSLog("\(#file) \(String(describing: object_getClass(self))) \(#function)")// step 1, 2
    }
    
    open override func updateViewConstraints() {
        super.updateViewConstraints()
        NSLog("\(#file) \(String(describing: object_getClass(self))) \(#function)")// step 5
    }
}

class AutoTopicView : UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        let title = UILabel()
        title.text = "autoTtitle"
        self.addSubview(title)
        title.snp.makeConstraints { make in
            make.top.left.right.equalTo(self)
        }
        
        let autoTopicCell = AutoTopicCell()
        self.addSubview(autoTopicCell)
        autoTopicCell.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(self)
            make.top.equalTo(title.snp.bottom)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
      }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        NSLog("\(#file) \(String(describing: object_getClass(self))) \(#function)")// step 7
    }
    
    override func layoutMarginsDidChange() {
        super.layoutMarginsDidChange()
        NSLog("\(#file) \(String(describing: object_getClass(self))) \(#function)")
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        NSLog("\(#file) \(String(describing: object_getClass(self))) \(#function)") // step 4
    }
}

class AutoTopicCell : UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .yellow
        let title = UILabel()
        title.text = "AutoTopicCell"
        self.addSubview(title)
        title.snp.makeConstraints { make in
            make.left.top.equalTo(self)
        }
        
        let rightTitle = UILabel()
        rightTitle.text = "rightTitle"
        self.addSubview(rightTitle)
        rightTitle.snp.makeConstraints { make in
            make.top.right.equalTo(self)
        }
        
        let pinkRect = UIView()
        pinkRect.backgroundColor = .systemPink
        self.addSubview(pinkRect)
        pinkRect.snp.makeConstraints { make in
            make.top.equalTo(title.snp.bottom)
            make.left.bottom.equalTo(self)
            make.height.width.equalTo(25)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
      }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        NSLog("\(#file) \(String(describing: object_getClass(self))) \(#function)")// step 8
    }
    
    override func layoutMarginsDidChange() {
        super.layoutMarginsDidChange()
        NSLog("\(#file) \(String(describing: object_getClass(self))) \(#function)")
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        NSLog("\(#file) \(String(describing: object_getClass(self))) \(#function)")// step 3
    }
}
