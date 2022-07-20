//
//  HomePage.swift
//  Oc2Swift
//
//  Created by behind47 on 2022/7/19.
//

import Foundation

open class HomePage : BaseVC {
    open override func viewDidLoad() {
        super.viewDidLoad()
        let content = UILabel()
        content.text = "HomePage"
        self.view.addSubview(content)
        content.snp.makeConstraints { make in
            make.center.equalTo(self.view)
        }
    }
}
