//
//  LayoutTestVC.swift
//  Oc2Swift
//
//  Created by behind47 on 2022/7/3.
//
/// 测试iOS布局流程的类——从VC开始自上而下的触发layout方法,确定UIView的frame，因此会出现子UIView被父UIView部分遮挡的情况。
/// 1. viewLayoutMarginsDidChange触发
/// 2. viewDidLayoutSubviews触发
/// 3. layoutSubviews触发
///

import Foundation

let sWidth = UIScreen.main.bounds.width

open class LayoutTestVC : BaseVC {
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        let topicView = TopicView()
        self.view.addSubview(topicView)
        topicView.frame = CGRect(x: 0, y: 200, width: sWidth, height: 50)
        topicView.backgroundColor = UIColor.white
    }
    
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        NSLog("\(#file) \(String(describing: object_getClass(self))) \(#function)")// step 3
    }
    
    open override func viewLayoutMarginsDidChange() {
        super.viewLayoutMarginsDidChange()
        NSLog("\(#file) \(String(describing: object_getClass(self))) \(#function)")// step 1, 2
    }
    
    open override func updateViewConstraints() {
        super.updateViewConstraints()
        NSLog("\(#file) \(String(describing: object_getClass(self))) \(#function)")
    }
}

class TopicView : UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        let title = UILabel()
        title.frame = CGRect(x: 0, y: 0, width: sWidth, height: 20)
        title.text = "title"
        self.addSubview(title)
        
        let subTitle = UILabel()
        subTitle.frame = CGRect(x: 0, y: 25, width: sWidth, height: 20)
        subTitle.text = "subTitle"
        self.addSubview(subTitle)
        
        let topic = TopicCell()
        topic.frame = CGRect(x: 0, y: 50, width: sWidth, height: 20)
        self.addSubview(topic)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
      }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        NSLog("\(#file) \(String(describing: object_getClass(self))) \(#function)")// step 4
    }
    
    override func layoutMarginsDidChange() {
        super.layoutMarginsDidChange()
        NSLog("\(#file) \(String(describing: object_getClass(self))) \(#function)")
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        NSLog("\(#file) \(String(describing: object_getClass(self))) \(#function)")
    }
}

class TopicCell : UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.green
        let topic = UILabel()
        topic.frame = CGRect(x: 0, y: 0, width: sWidth, height: 30)
        topic.text = "topic"
        self .addSubview(topic)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        NSLog("\(#file) \(String(describing: object_getClass(self))) \(#function)")// step 5
    }
    
    override func layoutMarginsDidChange() {
        super.layoutMarginsDidChange()
        NSLog("\(#file) \(String(describing: object_getClass(self))) \(#function)")
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        NSLog("\(#file) \(String(describing: object_getClass(self))) \(#function)")
    }
}
