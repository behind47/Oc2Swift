//
//  TabScrollView.swift
//  Oc2Swift
//
//  Created by behind47 on 2022/7/20.
//
/// tabVCs可以滚动，小于30%回弹，超过30%切换

import Foundation

open class TabScrollView : UIScrollView {
    var contentView : UIView
    
    public required init?(coder: NSCoder) {
        fatalError()
    }
    
    public init() {
        contentView = UIView()
        super.init(frame: CGRect.zero)
        commonInit()
    }
    
    func commonInit() {
        self.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(self)
            make.height.equalTo(self)
            make.width.greaterThanOrEqualTo(0)
        }
        updateData()
    }
    
    open func updateData() {
        // TODO:可以继承Fragment，支持任意数量的Fragment
        let homePage = HomePage()
        let contacts = Contacts()
        let personal = Personal()
        contentView.addSubview(homePage.view)
        homePage.view.snp.makeConstraints { make in
            make.left.equalTo(contentView)
            make.top.height.width.equalTo(self)
        }
        contentView.addSubview(contacts.view)
        contacts.view.snp.makeConstraints { make in
            make.left.equalTo(homePage.view.snp.right)
            make.top.height.width.equalTo(self)
        }
        contentView.addSubview(personal.view)
        personal.view.snp.makeConstraints { make in
            make.left.equalTo(contacts.view.snp.right)
            make.top.height.width.equalTo(self)
            make.right.equalTo(contentView)
        }
    }
}
