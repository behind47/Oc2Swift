//
//  ViewController.swift
//  Oc2Swift
//
//  Created by behind47 on 2022/5/18.
//
/// 暂时用于作为首页的一个列表

import UIKit

public class ViewController: BaseVC {
    var viewModels : [ViewModel]
    var fastCellList : FastCellList

    override public func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(fastCellList)
        fastCellList.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
    }
    
    override public init(frame: CGRect) {
        viewModels = [ViewModel]()
        fastCellList = FastCellList()
        super.init(frame: frame)
        commonInit()
    }

    public required init?(coder: NSCoder) {
        fatalError()
    }
    
    func commonInit() {
        viewModels.append(ViewModel.init(title: "native add", subTitle: "测试", callback: {
            self.navigationController?.pushViewController(C2OcTestVC(), animated: true)
        }))
        viewModels.append(ViewModel.init(title: "UI布局", subTitle: "测试", callback: {
            self.navigationController?.pushViewController(LayoutMenuVC(), animated: true)
        }))
        viewModels.append(ViewModel.init(title: "UI容器", subTitle: "测试", callback: {
            self.navigationController?.pushViewController(ContainerMenuVC(), animated: true)
        }))
        viewModels.append(ViewModel.init(title: "UI优化", subTitle: "测试", callback: {
            self.navigationController?.pushViewController(UIOptimizationVC(), animated: true)
        }))
        viewModels.append(ViewModel.init(title: "弹窗", subTitle: "", callback: {
            self.navigationController?.pushViewController(PopMenuView(), animated: true)
        }))
        viewModels.append(ViewModel.init(title: "runloop menu", subTitle: "测试", callback: {
            self.navigationController?.pushViewController(RunLoopMenuVC(), animated: true)
        }))
        viewModels.append(ViewModel.init(title: "invocation测试", subTitle: "反射", callback: {
            self.navigationController?.pushViewController(NSInvocationVC(), animated: true)
        }))
        viewModels.append(ViewModel.init(title: "runtime测试", subTitle: "", callback: {
            self.navigationController?.pushViewController(RuntimeMenuVC(), animated: true)
        }))
        viewModels.append(ViewModel.init(title: "泛型测试", subTitle: "", callback: {
            self.navigationController?.pushViewController(MathFunctionVC(), animated: true)
        }))
        viewModels.append(ViewModel.init(title: "键盘", subTitle: "", callback: {
            self.navigationController?.pushViewController(KeyBoardVC(), animated: true)
        }))
        viewModels.append(ViewModel.init(title: "动画", subTitle: "", callback: {
            self.navigationController?.pushViewController(AnimationVC(), animated: true)
        }))
        viewModels.append(ViewModel.init(title: "图片加载", subTitle: "", callback: {
            self.navigationController?.pushViewController(ImageVC(), animated: true)
        }))
        viewModels.append(ViewModel.init(title: "网络", subTitle: "", callback: {
            self.navigationController?.pushViewController(NSURLSessionMenuVC(), animated: true)
        }))
        viewModels.append(ViewModel.init(title: "Operation使用", subTitle: "", callback: {
            self.navigationController?.pushViewController(OperationVC(), animated: true)
        }))
        viewModels.append(ViewModel.init(title: "内存泄漏", subTitle: "", callback: {
            self.navigationController?.pushViewController(LeaksVC(), animated: true)
        }))
        viewModels.append(ViewModel.init(title: "KVO", subTitle: "", callback: {
            self.navigationController?.pushViewController(KVOVC(), animated: true)
        }))
        viewModels.append(ViewModel.init(title: "DebugKit", subTitle: "", identifier: "SwitchCell", switchBlock: { (isOn: Bool) in
            DebugIcon.shared.isHidden = !isOn
        }))
        viewModels.append(ViewModel.init(title: "事件菜单", subTitle: "", callback: {
            self.navigationController?.pushViewController(EventMenuVC(), animated: true)
        }))
        viewModels.append(ViewModel.init(title: "自定义绘制菜单", subTitle: "", callback: {
            self.navigationController?.pushViewController(CustomDrawMenuVC(), animated: true)
        }))
        fastCellList.updateWithViewModels(vms: viewModels)
    }
}

