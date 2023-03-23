//
//  BaseCell.swift
//  Oc2Swift
//
//  Created by behind47 on 2023/3/23.
//

import Foundation

class BaseCell : UITableViewCell {
    func updateWith(model : ViewModel) {
        textLabel?.text = model.title
        detailTextLabel?.text = model.subTitle
    }
}
