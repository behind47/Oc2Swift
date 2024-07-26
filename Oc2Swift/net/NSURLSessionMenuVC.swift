//
//  NSURLSessionMenuVC.swift
//  Oc2Swift
//
//  Created by behind47 on 2024/6/12.
//

import UIKit

class NSURLSessionMenuVC: BaseMenuVC {

    override func commonInit() {
        viewModels.append(ViewModel.init(title: "Fetching website data into memory", subTitle: "测试", callback: {
            self.navigationController?.pushViewController(URLSessionMemoryVC(), animated: true)
        }))
        
        fastCellList.updateWithViewModels(vms: viewModels)
    }
}
