//
//  EventMenuVC.swift
//  Oc2Swift
//
//  Created by behind47 on 2023/3/29.
//

import Foundation

class EventMenuVC: BaseMenuVC {
    override func commonInit() {
        viewModels.append(ViewModel.init(title: "触摸事件传递流程", subTitle: "测试", callback: {
            self.navigationController?.pushViewController(TouchEventVC(), animated: true)
        }))
        viewModels.append(ViewModel.init(title: "scrollView嵌套UITableView的坑", subTitle: "测试", callback: {
            self.navigationController?.pushViewController(ScrollTableViewVC(), animated: true)
        }))
        viewModels.append(ViewModel.init(title: "requireGestureRecognizerToFail的版本差异", subTitle: "测试", callback: {
            self.navigationController?.pushViewController(PanGestureError(), animated: true)
        }))
        fastCellList.updateWithViewModels(vms: viewModels)
    }
}
