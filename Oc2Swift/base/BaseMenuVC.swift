//
//  BaseMenuVC.swift
//  Oc2Swift
//
//  Created by behind47 on 2023/6/9.
//

import Foundation

class BaseMenuVC: BaseVC {
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
        fastCellList.updateWithViewModels(vms: viewModels)
    }
}
