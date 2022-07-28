//
//  TabVCs.swift
//  Oc2Swift
//
//  Created by behind47 on 2022/7/19.
//
/// tabs+tabVCs
/// 1. tabVCs可以滚动，小于30%回弹，超过30%切换
/// 2. 切换tabVC时，切换tab
/// 3. 点击tab，切换tabVC

import Foundation

open class TabVCs : BaseVC, UIScrollViewDelegate, UICollectionViewDelegateFlowLayout {
    var headView : HeadView!
    var tabArrView : TabArrView!
    var tabVCs : [UIViewController]!
    var tabScrollView : TabScrollView!
    var scrollOffsetX : Double! // 记录偏移量，用来计算滑动方向
    
    let TAB_HEIGHT = 50
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        headView = HeadView()
        tabArrView = TabArrView()
        tabVCs = [UIViewController]()
        tabScrollView = TabScrollView()
        scrollOffsetX = 0.0
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        tabArrView.delegate = self
        tabScrollView.delegate = self
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(headView)
        headView.snp.makeConstraints { make in
            make.left.top.right.equalTo(self.view)
            make.height.equalTo(100)
        }
        self.view.addSubview(tabArrView)
        tabArrView.snp.makeConstraints { make in
            make.top.equalTo(headView.snp.bottom)
            make.left.right.equalTo(self.view)
            make.height.equalTo(TAB_HEIGHT)
        }
        self.view.addSubview(tabScrollView)
        tabScrollView.snp.makeConstraints { make in
            make.top.equalTo(tabArrView.snp.bottom)
            make.left.right.bottom.equalTo(self.view)
        }
    }
    
    // 切换到第index个page
    func scrollToPage(_ index: CGFloat, _ scrollView: UIScrollView) {
        // 以scrollView的宽度为计量单位，将contentOffset四舍五入
        // 拖动事件发生时，布局已经完成，因此认为scrollView.bounds.width是scrollView的宽度
        scrollView.setContentOffset(CGPoint(x: index * tabScrollView.bounds.width, y: 0.0),
                                    animated: true)
        // 切换page时切换选中的tab
        let indexPath = IndexPath(row: Int(index), section: 0)
        tabArrView.selectItem(at: indexPath, animated: true, scrollPosition: UICollectionView.ScrollPosition.centeredHorizontally)
        // TODO:触发第index个tab被选中的事件
    }
    
    // MARK: UIScrollViewDelegate

    /// 流程有两个：
    /// 1. 拖动停止后，如果有惯性，则异步停止惯性滚动。惯性滚动停止后，设置滚动换页动画
    /// 2. 如果没有惯性，则直接设置滚动换页动画
    ///
    /// TODO：回弹的速度太快了，怎么处理？
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        // tabVCs可以滚动，小于30%回弹，超过30%翻页
        let dir = scrollView.contentOffset.x - scrollOffsetX
        var index : CGFloat
        if (dir > 0) {
            index = ceil(scrollView.contentOffset.x / tabScrollView.bounds.width - 0.3)
        } else {
            index = ceil(scrollView.contentOffset.x / tabScrollView.bounds.width - 0.7)
        }
        if (index < 0) { // 因为有-0的情况
            index = 0
        }
        if (decelerate) {
            // 首先取消惯性滚动
            DispatchQueue.main.async { [self] in
                scrollView.setContentOffset(CGPoint(x: index * tabScrollView.bounds.width, y: 0), animated: false)
            }
        } else {
            scrollToPage(index, scrollView)
        }
        scrollOffsetX = scrollView.contentOffset.x
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // 以scrollView的宽度为计量单位，将contentOffset四舍五入
        // 拖动事件发生时，布局已经完成，因此认为scrollView.bounds.width是scrollView的宽度
        let index = round(scrollView.contentOffset.x / tabScrollView.bounds.width)
        scrollToPage(index, scrollView)
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: 150, height: TAB_HEIGHT)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15;
    }
    
    // MARK: UICollectionViewDelegate
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! TabView
        cell.select(true)
        scrollToPage(CGFloat(indexPath.row), tabScrollView)
    }
    
    // 切换选中item时，原来选中的item就会调用这个方法
    public func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! TabView
        cell.select(false)
    }
}

open class HeadView : UIView {
    public init() {
        super.init(frame: CGRect.zero)
        backgroundColor = .blue
    }
    
    public required init?(coder: NSCoder) {
        fatalError()
    }
}

