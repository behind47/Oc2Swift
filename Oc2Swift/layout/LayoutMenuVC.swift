//
//  LayoutMenuVC.swift
//  Oc2Swift
//
//  Created by behind47 on 2023/3/29.
//

import Foundation

class LayoutMenuVC: BaseVC {
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
        viewModels.append(ViewModel.init(title: "iOS布局流程", subTitle: "测试", callback: {
            self.navigationController?.pushViewController(LayoutTestVC(), animated: true)
        }))
        viewModels.append(ViewModel.init(title: "iOS约束布局流程", subTitle: "测试", callback: {
            self.navigationController?.pushViewController(LayoutOrderTestVC(), animated: true)
        }))
        viewModels.append(ViewModel.init(title: "iOS约束布局tableHeaderView高度自适应", subTitle: "测试", callback: {
            self.navigationController?.pushViewController(AutoTableHeaderVC(), animated: true)
        }))
        viewModels.append(ViewModel.init(title: "frame-bound测试", subTitle: "修改bound.origin", callback: {
            self.navigationController?.pushViewController(FrameBoundVC(), animated: true)
        }))
        viewModels.append(ViewModel.init(title: "flex布局", subTitle: "", callback: {
            self.navigationController?.pushViewController(FlexVC(), animated: true)
        }))
        viewModels.append(ViewModel.init(title: "坐标系", subTitle: "", callback: {
            self.navigationController?.pushViewController(CordinateVC(), animated: true)
        }))
        viewModels.append(ViewModel.init(title: "UIWindow中UIView添加相对布局的坑", subTitle: "", callback: {
            self.navigationController?.pushViewController(ReviewInWindowVC(), animated: true)
        }))
        viewModels.append(ViewModel.init(title: "Masonry使用的注意事项", subTitle: "", callback: {
            self.navigationController?.pushViewController(ErrorMasonryVC(), animated: true)
        }))
        viewModels.append(ViewModel.init(title: "Auto Layout的案例", subTitle: "", callback: {
            self.navigationController?.pushViewController(AutoLayoutTestVC(), animated: true)
        }))
        fastCellList.updateWithViewModels(vms: viewModels)
    }
}
