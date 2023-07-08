//
//  RunLoopMenuVC.swift
//  Oc2Swift
//
//  Created by behind47 on 2023/7/8.
//

import Foundation

class RunLoopMenuVC: BaseVC {
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
        viewModels.append(ViewModel.init(title: "run loop的fake实现", subTitle: "测试", callback: {
            self.navigationController?.pushViewController(RunLoopVC(), animated: true)
        }))
        viewModels.append(ViewModel.init(title: "机遇runloop监听frame变化的UIView", subTitle: "测试", callback: {
            self.navigationController?.pushViewController(DynamicUIViewCheckVC(), animated: true)
        }))
        fastCellList.updateWithViewModels(vms: viewModels)
    }
}
