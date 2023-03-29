//
//  Personal.swift
//  Oc2Swift
//
//  Created by behind47 on 2022/7/19.
//

import Foundation
open class Personal : BaseVC {
    open override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .orange
        let content = UILabel()
        content.text = "Personal"
        self.view.addSubview(content)
        content.snp.makeConstraints { make in
            make.center.equalTo(self.view)
        }
    }
}
