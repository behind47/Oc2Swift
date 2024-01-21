//
//  RunLoopMenuVC.swift
//  Oc2Swift
//
//  Created by behind47 on 2023/7/8.
//

import Foundation

class RunLoopMenuVC: BaseMenuVC {
    override func commonInit() {
        viewModels.append(ViewModel.init(title: "run loop的fake实现", subTitle: "测试", callback: {
            self.navigationController?.pushViewController(RunLoopVC(), animated: true)
        }))
        viewModels.append(ViewModel.init(title: "机遇runloop监听frame变化的UIView", subTitle: "测试", callback: {
            self.navigationController?.pushViewController(DynamicUIViewCheckVC(), animated: true)
        }))
        fastCellList.updateWithViewModels(vms: viewModels)
    }
}
