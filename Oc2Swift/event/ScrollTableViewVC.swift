//
//  ScrollTableViewVC.swift
//  Oc2Swift
//
//  Created by behind47 on 2023/4/17.
//
/// 一个实践中遇到的bug：
/// UIScrollView嵌套UITableView时，滑动UITableView，UIScrollView也跟着滑动。
/// 1. 当前的使用方法下，UIScrollView与UITableView的滑动事件没有冲突。焦点在哪个上面，就由哪个来响应滑动事件。

import Foundation
import UIKit

class ScrollTableViewVC : BaseVC {
    let mainScroll : UIScrollView
    var viewModels : [ViewModel]
    var fastCellList : FastCellList
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        viewModels = [ViewModel]()
        fastCellList = FastCellList()
        mainScroll = UIScrollView()
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        commonInit()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainScroll.delegate = self
        mainScroll.backgroundColor = .white
        self.view.addSubview(mainScroll)
        mainScroll.snp.makeConstraints { make in
            make.edges.equalTo(self.view)
        }
        let contentView = UIView()
        contentView.backgroundColor = .green
        mainScroll.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(mainScroll)
            make.width.equalTo(mainScroll)
            make.height.greaterThanOrEqualTo(0)
        }
        
        let vc1 = UIView()
        vc1.backgroundColor = .blue
        contentView.addSubview(vc1)
        vc1.snp.makeConstraints { make in
            make.width.height.equalTo(mainScroll)
            make.top.equalTo(contentView)
        }
        mainScroll.addSubview(fastCellList)
        fastCellList.backgroundColor = .yellow
        fastCellList.snp.makeConstraints { make in
            make.width.equalTo(mainScroll)
            make.height.equalTo(mainScroll).dividedBy(3)
            make.top.equalTo(vc1.snp.bottom)
            make.left.equalTo(vc1)
        }
        let vc2 = UIView()
        vc2.backgroundColor = .gray
        contentView.addSubview(vc2)
        vc2.snp.makeConstraints { make in
            make.width.height.equalTo(mainScroll)
            make.top.equalTo(fastCellList.snp.bottom)
            make.left.equalTo(vc1)
            make.bottom.equalTo(contentView)
        }
    }
    
    func commonInit() {
        mainScroll.delegate = self
        viewModels.append(ViewModel.init(title: "触摸事件传递流程", subTitle: "测试"))
        viewModels.append(ViewModel.init(title: "scrollView嵌套UITableView的坑", subTitle: "测试"))
        viewModels.append(ViewModel.init(title: "scrollView嵌套UITableView的坑", subTitle: "测试"))
        viewModels.append(ViewModel.init(title: "scrollView嵌套UITableView的坑", subTitle: "测试"))
        viewModels.append(ViewModel.init(title: "scrollView嵌套UITableView的坑", subTitle: "测试"))
        viewModels.append(ViewModel.init(title: "scrollView嵌套UITableView的坑", subTitle: "测试"))
        viewModels.append(ViewModel.init(title: "scrollView嵌套UITableView的坑", subTitle: "测试"))
        viewModels.append(ViewModel.init(title: "scrollView嵌套UITableView的坑", subTitle: "测试"))
        viewModels.append(ViewModel.init(title: "scrollView嵌套UITableView的坑", subTitle: "测试"))
        fastCellList.updateWithViewModels(vms: viewModels)
    }
}

extension ScrollTableViewVC : UIScrollViewDelegate {
    
}


