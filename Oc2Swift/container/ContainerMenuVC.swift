//
//  ContainerMenuVC.swift
//  Oc2Swift
//
//  Created by behind47 on 2023/3/29.
//

import Foundation

class ContainerMenuVC: BaseVC {
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
        viewModels.append(ViewModel.init(title: "scrollView测试", subTitle: "结合masonry实现滚动", callback: {
            self.navigationController?.pushViewController(RelativeScrollVC(), animated: true)
        }))
        viewModels.append(ViewModel.init(title: "用scrollView做一个tabVCs", subTitle: "", callback: {
            self.navigationController?.pushViewController(TabVCs(), animated: true)
        }))
        viewModels.append(ViewModel.init(title: "pageVC测试", subTitle: "", callback: {
            self.navigationController?.pushViewController(MyPageControllerVC(), animated: true)
        }))
        viewModels.append(ViewModel.init(title: "导航页NavigationVC", subTitle: "", callback: {
            let navigationVC = NavigationVC(rootViewController: HomePage())
//            navigationVC.viewControllers = [HomePage(), Personal(), Contacts()] // 可以设置stack里的VCs，像这样，present之后最上层显示的就是Contacts
            self.present(navigationVC, animated: true)
        }))
        fastCellList.updateWithViewModels(vms: viewModels)
    }
}
