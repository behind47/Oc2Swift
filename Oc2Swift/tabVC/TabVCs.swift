//
//  TabVCs.swift
//  Oc2Swift
//
//  Created by behind47 on 2022/7/19.
//
/// tabs+tabVCs
/// 1. tabVCs可以滚动，小于30%回弹，超过30%切换
/// 2. 切换tabVC时，切换tab
/// 3. 点击tab，切换tabVC

import Foundation

open class TabVCs : BaseVC {
    var headView : HeadView!
    var tabArrView : TabArrView!
    var tabVCs : [UIViewController]!
    var tabScrollView : TabScrollView!
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        headView = HeadView()
        tabArrView = TabArrView()
        tabVCs = [UIViewController]()
        tabScrollView = TabScrollView()
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(headView)
        headView.snp.makeConstraints { make in
            make.left.top.right.equalTo(self.view)
            make.height.equalTo(100)
        }
        self.view.addSubview(tabArrView)
        tabArrView.snp.makeConstraints { make in
            make.left.right.equalTo(self.view)
            make.top.equalTo(headView.snp.bottom)
        }
        self.view.addSubview(tabScrollView)
        tabScrollView.snp.makeConstraints { make in
            make.top.equalTo(tabArrView.snp.bottom)
            make.left.right.bottom.equalTo(self.view)
        }
    }
}

open class HeadView : UIView {
    public init() {
        super.init(frame: CGRect.zero)
        backgroundColor = .blue
    }
    
    public required init?(coder: NSCoder) {
        fatalError()
    }
}

