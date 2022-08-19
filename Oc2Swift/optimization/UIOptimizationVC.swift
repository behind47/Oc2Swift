//
//  UIOptimizationVC.swift
//  Oc2Swift
//
//  Created by behind47 on 2022/8/18.
//

import Foundation

class UIOptimizationVC : BaseVC {
    var viewModels : [ViewModel]!
    var fasterCellList : FastCellList!
    
    override func viewDidLoad() {
        viewModels = [
            ViewModel(title: "列表滑动优化", subTitle: "", callback: {
                self.navigationController?.pushViewController(TableViewOptimizationVC(), animated: true)
            })
        ]
        fasterCellList = FastCellList()
        super.viewDidLoad()
        view.addSubview(fasterCellList)
        fasterCellList.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
        fasterCellList.updateWithViewModels(vms: viewModels)
    }
}

