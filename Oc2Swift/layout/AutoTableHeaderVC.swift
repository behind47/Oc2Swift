//
//  AutoTableHeaderVC.swift
//  Oc2Swift
//
//  Created by behind47 on 2022/7/5.
//
/// 用约束布局实现tableHeaderView自适应

import Foundation
import UIKit


class AutoTableHeaderView : UIView {
    
    var namelable : UILabel // 昵称
    var avatar : UIImageView // 头像
    var desc : UILabel // 简介
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        namelable = UILabel()
        namelable.text = "namelablenamelablenamelablenamelablenamelable"
        namelable.setContentHuggingPriority(UILayoutPriority.required, for: NSLayoutConstraint.Axis.vertical)
        namelable.numberOfLines = 0
        namelable.preferredMaxLayoutWidth = UIScreen.main.bounds.size.width
        avatar = UIImageView()
        desc = UILabel.init()
        desc.setContentHuggingPriority(UILayoutPriority.required, for: NSLayoutConstraint.Axis.vertical)
        desc.numberOfLines = 0
        desc.preferredMaxLayoutWidth = UIScreen.main.bounds.size.width
        desc.text = "测试一下tableHeaderView如何自适应高度"
        super.init(frame: frame)
        self.addSubview(namelable)
        namelable.snp.makeConstraints { make in
            make.left.top.equalTo(self)
            make.width.equalTo(self)
        }
        self.addSubview(avatar)
        avatar.sd_setImage(with: URL(string: "https://img0.baidu.com/it/u=3453945757,207386596&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=500"))
        avatar.snp.makeConstraints { make in
            make.left.equalTo(self)
            make.top.equalTo(namelable.snp.bottom)
            make.width.height.equalTo(100)
        }
        self.addSubview(desc)
        desc.snp.makeConstraints { make in
            make.left.equalTo(self)
            make.top.equalTo(avatar.snp.bottom)
            make.bottom.equalTo(self)
        }
    }
}

open class AutoTableHeaderVC : BaseVC, UITableViewDelegate, UITableViewDataSource {
    var tableView : UITableView
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        tableView = UITableView()
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.view.backgroundColor = .gray
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.left.top.right.bottom.equalTo(self.view)
        }
        let headView = AutoTableHeaderView()
        headView.backgroundColor = .green
        // 方案1 systemLayoutSizeFitting开销大，慎用
//        let compressedFrame = headView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
//        headView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: compressedFrame.height)
        // 方案2
        tableView.tableHeaderView = headView
        headView.snp.makeConstraints { make in
            make.width.equalToSuperview()
        }
        tableView.tableHeaderView?.layoutIfNeeded()
        
        tableView.tableHeaderView = headView
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "defaultCell")
        if (cell == nil) {
            cell = UITableViewCell.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: "defaultCell")
        }
        return cell!
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
}
