//
//  FastCellList.swift
//  Oc2Swift
//
//  Created by behind47 on 2022/8/18.
//
/// 快速导航列表，绑定ViewModel数组就行

import Foundation

struct ViewModel {
    var title : String
    var subTitle : String
    var identifier : String = "defaultCell"
    var callback : (() -> Void)? = nil
    var switchBlock : ((_ isOn: Bool) -> Void)? = nil
}

class FastCellList : UIView {
    var viewModels : [ViewModel]
    let tableView : UITableView
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override init(frame: CGRect) {
        tableView = UITableView()
        viewModels = [ViewModel]()
        super.init(frame: frame)
        commonInit()
    }

    func commonInit() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(BaseCell.self, forCellReuseIdentifier: "defaultCell")
        tableView.register(SwitchCell.self, forCellReuseIdentifier: "SwitchCell")
        self.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
    }
    
    func updateWithViewModels(vms: [ViewModel]) {
        viewModels = vms
        tableView.reloadData()
    }
}

extension FastCellList : UITableViewDelegate {
    // MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModels[indexPath.row].callback?()
    }
}

extension FastCellList : UITableViewDataSource {
    //MARK: UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = viewModels[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: model.identifier, for: indexPath) as! BaseCell
        cell.updateWith(model: model)
        return cell as UITableViewCell
    }
}
