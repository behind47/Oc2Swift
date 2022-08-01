//
//  BaseVC.swift
//  Oc2Swift
//
//  Created by behind47 on 2022/7/3.
//
/// 基类，可以承载一些通用的方法，比如InjectionIII的injected方法

import Foundation
import UIKit

open class BaseVC : UIViewController {
    /// InjectionIII需要的方法，在这个hook里的方法会在热更新触发时被调用
    @objc func injected() {
        #if DEBUG
        self.viewDidLoad()
        #endif
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
}
