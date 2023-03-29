//
//  TabArrView.swift
//  Oc2Swift
//
//  Created by behind47 on 2022/7/19.
//

import Foundation
import SwiftUI

open class TabView : UICollectionViewCell {
    var title : UILabel
    
    public required init?(coder: NSCoder) {
        fatalError()
    }
    
    public override init(frame: CGRect) {
        title = UILabel()
        super.init(frame: frame)
        commonInit()
    }
    
    public init() {
        title = UILabel()
        super.init(frame: CGRect.zero)
        commonInit()
    }
    
    func commonInit() {
        backgroundColor = .black
        self.addSubview(title)
        title.setContentHuggingPriority(UILayoutPriority.required, for: NSLayoutConstraint.Axis.horizontal)
        title.snp.makeConstraints { make in
            make.center.equalTo(self)
            make.width.equalTo(title)
        }
        title.textColor = .white
        title.backgroundColor = .none
    }
    
    open func update(with model: TabModel) {
        title.text = model.text
    }
    
    open func select(_ isSelected: Bool) {
        if (isSelected) {
            title.textColor = .yellow
        } else {
            title.textColor = .white
        }
    }
}

open class TabArrView : UICollectionView, UICollectionViewDataSource {
    var tabArr : [TabModel]
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public init() {
        tabArr = [TabModel]()
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionView.ScrollDirection.horizontal
        super.init(frame: CGRect.zero, collectionViewLayout: layout)
        commonInit()
    }
    
    func commonInit() {
        backgroundColor = .white
        dataSource = self
        register(TabView.self, forCellWithReuseIdentifier: "TabView")
        updateData()
    }
    
    open func updateData() {
        tabArr.append(TabModel(text: "HomePage", highlightColor: nil, normalColor: nil))
        tabArr.append(TabModel(text: "Contacts", highlightColor: nil, normalColor: nil))
        tabArr.append(TabModel(text: "Personal", highlightColor: nil, normalColor: nil))
        reloadData()
    }
    
    // MARK: UICollectionViewDataSource
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TabView", for: indexPath) as! TabView
        cell.update(with: tabArr[indexPath.row])
        return cell
    }
}

public struct TabModel {
    public var text : String
    public var highlightColor : Color
    public var normalColor : Color
    
    init(text : String?, highlightColor : Color?, normalColor : Color?) {
        self.text = text ?? "default Tab"
        self.highlightColor = highlightColor ?? Color.yellow
        self.normalColor = normalColor ?? Color.green
    }
}
