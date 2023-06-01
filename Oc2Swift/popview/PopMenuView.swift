//
//  PopMenuView.swift
//  Oc2Swift
//
//  Created by behind47 on 2023/5/11.
//

import Foundation

class PopMenuView : BaseVC {
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
        viewModels.append(ViewModel.init(title: "半屏弹窗", subTitle: "承载自定义View", callback: {
            let halfScreenPopView = HalfScreenPopView()
            halfScreenPopView.modalPresentationStyle = UIModalPresentationStyle.custom
            self.present(halfScreenPopView, animated: true)
        }))
        fastCellList.updateWithViewModels(vms: viewModels)
    }
}
