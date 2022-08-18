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
    var callback : (() -> Void)?
}

class FastCellList : UIView, UITableViewDelegate, UITableViewDataSource {
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
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "defaultCell")
        self.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
    }
    
    func updateWithViewModels(vms: [ViewModel]) {
        viewModels = vms
        tableView.reloadData()
    }
    
    //MARK: UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "defaultCell", for: indexPath) as UITableViewCell
        cell.textLabel?.text = viewModels[indexPath.row].title
        cell.detailTextLabel?.text = viewModels[indexPath.row].subTitle
        return cell
    }
    
    //MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModels[indexPath.row].callback.unsafelyUnwrapped()
    }
}
