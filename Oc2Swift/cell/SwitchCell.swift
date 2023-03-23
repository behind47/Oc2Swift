//
//  SwitchCell.swift
//  Oc2Swift
//
//  Created by behind47 on 2023/3/23.
//

import Foundation

class SwitchCell : BaseCell {
    
    var switchControl : UISwitch
    var block : ((_ isOn: Bool)-> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        switchControl = UISwitch()
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        switchControl.addTarget(self, action: #selector(showDebugIcon), for: UIControl.Event.touchUpInside)
        contentView.addSubview(switchControl)
        switchControl.snp.makeConstraints { make in
            make.top.bottom.right.equalTo(contentView)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateWith(model : ViewModel) {
        super.updateWith(model: model)
        block = model.switchBlock
    }
    
    // MARK: Event
    @objc func showDebugIcon(_ sender : UISwitch) {
        block?(sender.isOn)
    }
    
}
