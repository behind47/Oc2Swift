//
//  WebViewMenuVC.swift
//  Oc2Swift
//
//  Created by behind47 on 2024/7/29.
//

import Foundation

class WebViewMenuVC : BaseMenuVC {
    override func commonInit() {
        viewModels.append(ViewModel.init(title: "网页适配刘海屏", subTitle: "inset", callback: {
            self.navigationController?.pushViewController(CustomWebView(), animated: true)
        }))
        super.commonInit()
    }
}
