//
//  Contacts.swift
//  Oc2Swift
//
//  Created by behind47 on 2022/7/19.
//

import Foundation
open class Contacts : BaseVC {
    open override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
        let content = UILabel()
        content.text = "Contacts"
        self.view.addSubview(content)
        content.snp.makeConstraints { make in
            make.center.equalTo(self.view)
        }
    }
}
