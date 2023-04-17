//
//  EventMenuVC.swift
//  Oc2Swift
//
//  Created by behind47 on 2023/3/29.
//

import Foundation

class EventMenuVC: BaseVC {
    var viewModels : [ViewModel]
    var fastCellList : FastCellList

    override public func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(fastCellList)
        fastCellList.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
    }
    
    override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        viewModels = [ViewModel]()
        fastCellList = FastCellList()
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        viewModels = [ViewModel]()
        fastCellList = FastCellList()
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        viewModels.append(ViewModel.init(title: "触摸事件传递流程", subTitle: "测试", callback: {
            self.navigationController?.pushViewController(TouchEventVC(), animated: true)
        }))
        viewModels.append(ViewModel.init(title: "scrollView嵌套UITableView的坑", subTitle: "测试", callback: {
            self.navigationController?.pushViewController(ScrollTableViewVC(), animated: true)
        }))
        fastCellList.updateWithViewModels(vms: viewModels)
    }
}
