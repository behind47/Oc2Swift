//
//  BaseVC.swift
//  Oc2Swift
//
//  Created by behind47 on 2022/7/3.
//

import Foundation
import UIKit

open class BaseVC : UIViewController {
    @objc func injected() {
        #if DEBUG
        self.viewDidLoad()
        #endif
    }
}
