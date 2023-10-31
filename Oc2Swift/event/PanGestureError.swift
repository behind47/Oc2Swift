//
//  PanGestureError.swift
//  Oc2Swift
//
//  Created by behind47 on 2023/10/31.
//

import Foundation

class PanGestureError : BaseVC {
    override func viewDidLoad() {
        super.viewDidLoad()
        let recognizer = UIPanGestureRecognizer()
        recognizer.require(toFail: nil)
    }
}
