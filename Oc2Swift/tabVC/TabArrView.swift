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
        self.addSubview(title)
        title.setContentHuggingPriority(UILayoutPriority.required, for: NSLayoutConstraint.Axis.horizontal)
        title.snp.makeConstraints { make in
            make.center.equalTo(self)
            make.width.equalTo(title)
        }
        title.highlightedTextColor = .yellow
        title.textColor = .white
        title.backgroundColor = .black
    }
    
    open func update(with model: TabModel) {
        title.text = model.text
    }
}

open class TabArrView : UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    var collectionView : UICollectionView
    var tabArr : [TabModel]
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public init() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionView.ScrollDirection.horizontal
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        tabArr = [TabModel]()
        super.init(frame: CGRect.zero)
        commonInit()
    }
    
    func commonInit() {
        backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(TabView.self, forCellWithReuseIdentifier: "TabView")
        self.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.height.equalTo(self) // 把这个注销，self的高度就会变0，然后因为不能接受drag事件导致collectionView无法滑动
            make.width.equalTo(UIScreen.main.bounds.size.width)
            make.height.equalTo(50)
        }
        updateData()
    }
    
    open func updateData() {
        tabArr.append(TabModel(text: "HomePage", highlightColor: nil, normalColor: nil))
        tabArr.append(TabModel(text: "Contacts", highlightColor: nil, normalColor: nil))
        tabArr.append(TabModel(text: "Personal", highlightColor: nil, normalColor: nil))
        collectionView.reloadData()
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
    
    // MARK: UICollectionViewDelegateFlowLayout
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: 150, height: 50)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15;
    }
    
    // MARK: UICollectionViewDelegate
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // TODO: 点击时切换tabVCs
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
