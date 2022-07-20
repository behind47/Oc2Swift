//
//  TabScrollView.swift
//  Oc2Swift
//
//  Created by behind47 on 2022/7/20.
//
/// tabVCs可以滚动，小于30%回弹，超过30%切换

import Foundation

open class TabScrollView : UIScrollView, UIScrollViewDelegate {
    var contentView : UIView
    
    public required init?(coder: NSCoder) {
        fatalError()
    }
    
    public init() {
        contentView = UIView()
        super.init(frame: CGRect.zero)
        commonInit()
    }
    
    func commonInit() {
        self.delegate = self
        self.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(self)
            make.height.equalTo(self)
            make.width.greaterThanOrEqualTo(0)
        }
        updateData()
    }
    
    open func updateData() {
        // TODO:可以继承Fragment，支持任意数量的Fragment
        let homePage = HomePage()
        let contacts = Contacts()
        let personal = Personal()
        contentView.addSubview(homePage.view)
        homePage.view.snp.makeConstraints { make in
            make.left.equalTo(contentView)
            make.top.height.width.equalTo(self)
        }
        contentView.addSubview(contacts.view)
        contacts.view.snp.makeConstraints { make in
            make.left.equalTo(homePage.view.snp.right)
            make.top.height.width.equalTo(self)
        }
        contentView.addSubview(personal.view)
        personal.view.snp.makeConstraints { make in
            make.left.equalTo(contacts.view.snp.right)
            make.top.height.width.equalTo(self)
            make.right.equalTo(contentView)
        }
    }
    
    // MARK: UIScrollViewDelegate

    /// 流程有两个：
    /// 1. 拖动停止后，如果有惯性，则异步停止惯性滚动。惯性滚动停止后，设置滚动换页动画
    /// 2. 如果没有惯性，则直接设置滚动换页动画
    ///
    /// TODO：回弹的速度太快了，怎么处理？
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        // tabVCs可以滚动，小于50%左弹，超过50%右弹
        // 首先取消惯性滚动
        if (decelerate) {
            DispatchQueue.main.async {
                scrollView.setContentOffset(CGPoint(x: round(scrollView.contentOffset.x / self.bounds.width) * self.bounds.width, y: 0), animated: false)
            }
        } else {
            // 以scrollView的宽度为计量单位，将contentOffset四舍五入
            // 拖动事件发生时，布局已经完成，因此认为self.bounds.width是scrollView的宽度
            scrollView.setContentOffset(CGPoint(x: round(scrollView.contentOffset.x / self.bounds.width) * self.bounds.width, y: 0),
                                        animated: true)
        }
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // 以scrollView的宽度为计量单位，将contentOffset四舍五入
        // 拖动事件发生时，布局已经完成，因此认为self.bounds.width是scrollView的宽度
        scrollView.setContentOffset(CGPoint(x: round(scrollView.contentOffset.x / self.bounds.width) * self.bounds.width, y: 0),
                                    animated: true)
    }
}
