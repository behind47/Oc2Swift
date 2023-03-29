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
        viewModels.append(ViewModel.init(title: "run loop的fake实现", subTitle: "测试", callback: {
            self.navigationController?.pushViewController(RunLoopVC(), animated: true)
        }))
        viewModels.append(ViewModel.init(title: "invocation测试", subTitle: "反射", callback: {
            self.navigationController?.pushViewController(NSInvocationVC(), animated: true)
        }))
        viewModels.append(ViewModel.init(title: "runtime测试", subTitle: "", callback: {
            self.navigationController?.pushViewController(RuntimeVC(), animated: true)
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
            self.navigationController?.pushViewController(NSURLSessionVC(), animated: true)
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
        viewModels.append(ViewModel.init(title: "触摸事件传递流程", subTitle: "", callback: {
            self.navigationController?.pushViewController(TouchEventVC(), animated: true)
        }))
        fastCellList.updateWithViewModels(vms: viewModels)
    }
}

