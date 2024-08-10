//
//  LayoutOrderTestVC.swift
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

open class LayoutOrderTestVC : BaseVC {
    var autoTopicView : UIView
    var autoTopicView2 : UIView
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override init(frame: CGRect) {
        autoTopicView = AutoTopicView()
        autoTopicView2 = AutoTopicView()
        super.init(frame: frame)
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .green
        self.view.addSubview(autoTopicView)
        autoTopicView.snp.makeConstraints { make in
            make.left.right.equalTo(self.view)
            make.top.equalTo(self.view).offset(200)
        }
        
        let title = UILabel()
        title.numberOfLines = 0;
        title.text = "⬆️父view和子view都使用约束布局，子view可以将父view的尺寸撑开"
        self.view.addSubview(title)
        title.snp.makeConstraints { make in
            make.left.right.equalTo(self.view)
            make.top.equalTo(autoTopicView.snp.bottom)
        }
        
        let subTitle = UILabel()
        subTitle.numberOfLines = 0;
        subTitle.text = "⬇️父view使用了frame时，就以frame的尺寸为准，此时可能导致父view遮挡子view"
        self.view.addSubview(subTitle)
        subTitle.snp.makeConstraints { make in
            make.left.right.equalTo(self.view)
            make.top.equalTo(title.snp.bottom)
        }
        
        /// 父view使用frame + 子view使用约束布局 可以结合使用，由于layoutSubviews是自顶向下的，父view的frame优先生效
        /// 因此，需要使用systemLayoutSizeFitting(_ targetSize: CGSize)方法来基于子view的约束计算尺寸，再通过frame设置给父view
        self.view.addSubview(autoTopicView2)
//        autoTopicView2.snp.makeConstraints { make in
//            make.left.right.equalTo(self.view)
//            make.top.equalTo(subTitle.snp.bottom)
//        }
        var frame = CGRect(x: 0, y: 350, width: UIScreen.main.bounds.size.width, height: 0)
        let size = autoTopicView2.systemLayoutSizeFitting(UIView.layoutFittingExpandedSize)
        frame.size.height = size.height // 只有height需要子view撑开
        autoTopicView2.frame = frame
    }
    
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        NSLog("\(#file) \(String(describing: object_getClass(self))) \(#function)")// step 6
        print("autotopicview2 frame : \(autoTopicView2.frame)")
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
