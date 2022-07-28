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
        view.backgroundColor = .red
        let content = UILabel()
        content.text = "HomePage"
        self.view.addSubview(content)
        content.snp.makeConstraints { make in
            make.center.equalTo(self.view)
        }
        
        navigationItem.title = "home page"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.search, target: self, action: #selector(back))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "自定义文案", style: UIBarButtonItem.Style.plain, target: self, action: nil)
        navigationItem.prompt = "如果不设置这个属性就不会显示这一行"
    }
    
    @objc
    func back() {
        dismiss(animated: true)
    }
}
