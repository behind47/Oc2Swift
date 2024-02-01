//
//  RuntimeMenuVC.swift
//  Oc2Swift
//
//  Created by behind47 on 2024/1/21.
//

import Foundation

class RuntimeMenuVC: BaseMenuVC {
    override func commonInit() {
        viewModels.append(ViewModel.init(title: "runtime消息机制", subTitle: "待拆分", callback: {
            self.navigationController?.pushViewController(RuntimeVC(), animated: true)
        }))
        viewModels.append(ViewModel.init(title: "NS_DESIGNATED_INITIALIZER", subTitle: "待拆分", callback: {
            self.navigationController?.pushViewController(DesignClientViewController(), animated: true)
        }))
        fastCellList.updateWithViewModels(vms: viewModels)
    }
}
