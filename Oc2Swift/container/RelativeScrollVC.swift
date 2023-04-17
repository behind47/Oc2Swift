//
//  RelativeScrollVC.swift
//  Oc2Swift
//
//  Created by behind47 on 2022/7/15.
//
/// 测试ScrollView与SnapKit结合使用
/// ScrollView使用contentSize来规划内容空间，contentSize比size大，所以能实现滚动效果
/// 使用snapKit可以让子view的尺寸撑起父view
/// 在scrollView上添加一个contentView，然后将其尺寸撑起，用它的尺寸作为contentSize
/// TODO: 了解UIScrollView是如何实现滚动功能的？

import Foundation
import UIKit
import SnapKit

open class RelativeScrollVC : BaseVC, UIScrollViewDelegate {
    open override func viewDidLoad() {
        super.viewDidLoad()
        let mainScroll = UIScrollView()
        mainScroll.delegate = self
        mainScroll.backgroundColor = .white
        self.view.addSubview(mainScroll)
        mainScroll.snp.makeConstraints { make in
            make.edges.equalTo(self.view)
        }
        let contentView = UIView()
        contentView.backgroundColor = .green
        mainScroll.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(mainScroll)
            make.width.equalTo(mainScroll)
            make.height.greaterThanOrEqualTo(0)
        }
        
        let vc1 = UIView()
        vc1.backgroundColor = .blue
        contentView.addSubview(vc1)
        vc1.snp.makeConstraints { make in
            make.width.height.equalTo(mainScroll)
            make.top.equalTo(contentView)
        }
        let vc2 = UIView()
        vc2.backgroundColor = .gray
        contentView.addSubview(vc2)
        vc2.snp.makeConstraints { make in
            make.width.height.equalTo(mainScroll)
            make.top.equalTo(vc1.snp.bottom)
            make.left.equalTo(vc1)
        }
        let vc3 = UIView()
        vc3.backgroundColor = .yellow
        contentView.addSubview(vc3)
        vc3.snp.makeConstraints { make in
            make.width.height.equalTo(mainScroll)
            make.top.equalTo(vc2.snp.bottom)
            make.left.equalTo(vc2)
            make.bottom.equalTo(contentView)
        }
    }
}
