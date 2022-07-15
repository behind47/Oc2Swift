//
//  ViewController.swift
//  Oc2Swift
//
//  Created by behind47 on 2022/5/18.
//
/// 暂时用于作为首页的一个列表

import UIKit

struct ViewModel {
    var title : String
    var subTitle : String
    var callback : (() -> Void)?
}

public class ViewController: BaseVC, UITableViewDelegate, UITableViewDataSource {
    let tableView : UITableView
    var viewModels : [ViewModel]

    override public func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
        tableView.frame = self.view.frame
        tableView.reloadData()
    }
    
    override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        tableView = UITableView()
        viewModels = [ViewModel]()
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        tableView = UITableView()
        viewModels = [ViewModel]()
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        MGJRouter.registerURLPattern("learnios://native_add") { arguments in
            print("\(#function) MGJRouterParameterURL: \(String(describing: arguments?[MGJRouterParameterURL])) MGJRouterParameterUserInfo: \(String(describing: arguments?[MGJRouterParameterUserInfo]))")
            self.navigationController?.pushViewController(C2OcTestVC(), animated: true)
        }
        viewModels.append(ViewModel.init(title: "native add", subTitle: "测试", callback: {
            MGJRouter.openURL("learnios://native_add?a=1&b=false&c=sdfsdfsdf", withUserInfo: ["name":"grad", "color": "white"], completion: nil)
        }))
        viewModels.append(ViewModel.init(title: "iOS布局流程", subTitle: "测试", callback: {
            self.navigationController?.pushViewController(LayoutTestVC(), animated: true)
        }))
        viewModels.append(ViewModel.init(title: "iOS约束布局流程", subTitle: "测试", callback: {
            self.navigationController?.pushViewController(AutoLayoutTestVC(), animated: true)
        }))
        viewModels.append(ViewModel.init(title: "iOS约束布局tableHeaderView高度自适应", subTitle: "测试", callback: {
            self.navigationController?.pushViewController(AutoTableHeaderVC(), animated: true)
        }))
        viewModels.append(ViewModel.init(title: "run loop的fake实现", subTitle: "测试", callback: {
            self.navigationController?.pushViewController(RunLoopVC(), animated: true)
        }))
        viewModels.append(ViewModel.init(title: "invocation测试", subTitle: "反射", callback: {
            self.navigationController?.pushViewController(NSInvocationVC(), animated: true)
        }))
        viewModels.append(ViewModel.init(title: "frame-bound测试", subTitle: "修改bound.origin", callback: {
            self.navigationController?.pushViewController(FrameBoundVC(), animated: true)
        }))
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") ?? UITableViewCell() as UITableViewCell
        cell.textLabel?.text = viewModels[indexPath.row].title
        cell.detailTextLabel?.text = viewModels[indexPath.row].subTitle
        return cell
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModels[indexPath.row].callback.unsafelyUnwrapped()
    }
}

