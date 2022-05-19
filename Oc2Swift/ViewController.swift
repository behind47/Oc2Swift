//
//  ViewController.swift
//  Oc2Swift
//
//  Created by behind47 on 2022/5/18.
//

import UIKit

struct ViewModel {
    var title : String
    var subTitle : String
    var callback : (() -> Void)?
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    
    let tableView : UITableView
    var viewModels : [ViewModel]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    required init?(coder: NSCoder) {
        tableView = UITableView()
        viewModels = [ViewModel]()
        super.init(coder: coder)
        tableView.delegate = self
        viewModels.append(ViewModel.init(title: "native add", subTitle: "测试", callback: {
            self.navigationController?.pushViewController(C2OcTestVC(), animated: true)
        }))
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") ?? UITableViewCell() as UITableViewCell
        cell.textLabel?.text = viewModels[indexPath.row].title
        cell.detailTextLabel?.text = viewModels[indexPath.row].subTitle
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModels[indexPath.row].callback
    }
}

