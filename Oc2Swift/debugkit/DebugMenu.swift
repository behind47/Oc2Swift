//
//  DebugKitVC.swift
//  DebugMenu
//
//  Created by behind47 on 2023/3/23.
// debug菜单

import Foundation
import UIKit

class DebugMenu : BaseVC {
    var viewModels : [ViewModel]
    var fastCellList : FastCellList
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        viewModels = [ViewModel]()
        fastCellList = FastCellList()
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        commonInit()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(fastCellList)
        fastCellList.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
    }
    
    func commonInit() {
        viewModels.append(ViewModel.init(title: "组件检查工具", subTitle: "测试", callback: {
            self.dismiss(animated: true)
            FocusIcon.shared.show(type: FocusIconType.component)
        }))
        viewModels.append(ViewModel.init(title: "取色器", subTitle: "测试", callback: {
            self.dismiss(animated: true) {
                FocusIcon.shared.show(type: FocusIconType.color)
            }
        }))
        viewModels.append(ViewModel.init(title: "对齐标尺", subTitle: "测试", callback: {
            self.dismiss(animated: true)
            FocusIcon.shared.show(type: FocusIconType.rod)
        }))
        viewModels.append(ViewModel.init(title: "边框检查器", subTitle: "测试", callback: {
            self.dismiss(animated: true)
            UIViewCheckMenu.shared.show()
        }))
        fastCellList.updateWithViewModels(vms: viewModels)
    }
}
