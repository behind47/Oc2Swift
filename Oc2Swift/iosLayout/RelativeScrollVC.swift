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

import Foundation
import UIKit
import SnapKit

open class RelativeScrollVC : UIViewController {
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
