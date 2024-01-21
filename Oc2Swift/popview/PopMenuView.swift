//
//  PopMenuView.swift
//  Oc2Swift
//
//  Created by behind47 on 2023/5/11.
//

import Foundation

class PopMenuView : BaseMenuVC {
    
    override func commonInit() {
        viewModels.append(ViewModel.init(title: "半屏弹窗", subTitle: "承载自定义View", callback: {
            let halfScreenPopView = HalfScreenPopView()
            halfScreenPopView.modalPresentationStyle = UIModalPresentationStyle.custom
            self.present(halfScreenPopView, animated: true)
        }))
        fastCellList.updateWithViewModels(vms: viewModels)
    }
}
