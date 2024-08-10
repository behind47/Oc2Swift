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
    var mainScrollView : UIScrollView!
    var mainContentView : UIView!
    var tabScrollView : TabScrollView!
    var lastScrollOffsetX : CGFloat! // 记录偏移量，用来计算滑动方向
    var lastScrollOffsetY : CGFloat! // 记录偏移量，用来计算滑动方向
    
    let TAB_HEIGHT = 50
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override init!(frame: CGRect) {
        headView = HeadView()
        tabArrView = TabArrView()
        tabVCs = [UIViewController]()
        mainScrollView = UIScrollView()
        mainContentView = UIView()
        tabScrollView = TabScrollView()
        lastScrollOffsetX = 0.0
        lastScrollOffsetY = 0.0
        super.init(frame: frame)
        tabArrView.delegate = self
        mainScrollView.delegate = self
        tabScrollView.delegate = self
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(mainScrollView)
        mainScrollView.snp.makeConstraints { make in
            make.edges.equalTo(self.view)
        }
        mainScrollView.addSubview(mainContentView)
        mainContentView.snp.makeConstraints { make in
            make.edges.equalTo(mainScrollView)
            make.width.equalTo(mainScrollView)
            make.height.greaterThanOrEqualTo(0)
        }
        mainContentView.addSubview(headView)
        headView.snp.makeConstraints { make in
            make.left.top.right.equalTo(mainContentView)
            make.height.equalTo(100)
        }
        mainContentView.addSubview(tabArrView)
        tabArrView.snp.makeConstraints { make in
            make.top.equalTo(headView.snp.bottom)
            make.left.right.equalTo(mainContentView)
            make.height.equalTo(TAB_HEIGHT)
        }
        mainContentView.addSubview(tabScrollView)
        tabScrollView.snp.makeConstraints { make in
            make.top.equalTo(tabArrView.snp.bottom)
            make.left.right.bottom.equalTo(mainContentView)
            make.height.equalTo(self.view)
        }
    }
    
    // 切换到第index个page
    func scrollToPage(_ index: CGFloat, _ scrollView: UIScrollView) {
        // 以scrollView的宽度为计量单位，将contentOffset四舍五入
        // 拖动事件发生时，布局已经完成，因此认为scrollView.bounds.width是scrollView的宽度
        scrollView.setContentOffset(CGPoint(x: index * tabScrollView.bounds.width, y: scrollView.contentOffset.y),
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
        // UIScrollView似乎已经处理了滑动冲突的问题，所以不需要考虑同时拖动纵向与横向的情况，按顺序处理就行。
        let dir = scrollView.contentOffset.x - lastScrollOffsetX
        guard dir < CGFLOAT_EPSILON && dir > -CGFLOAT_EPSILON else {// 大于0是向左划手指，小于0是向右划手指
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
                    scrollView.setContentOffset(CGPoint(x: index * tabScrollView.bounds.width, y: scrollView.contentOffset.y), animated: false)
                }
            } else {
                scrollToPage(index, scrollView)
            }
            return
        }
        lastScrollOffsetX = scrollView.contentOffset.x
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView.contentOffset.y - lastScrollOffsetY > 0) {
            // TODO: 滚动到tabArr置顶时停止
            let navBarHeight = navigationController?.navigationBar.frame.height ?? 0.0
            let topPadding = headView.frame.height - (navBarHeight + Device.statusBarHeight)
            if (scrollView.contentOffset.y > topPadding) {
                scrollView.setContentOffset(CGPoint(x: scrollView.contentOffset.x, y: topPadding), animated: false)
            }
        }
        lastScrollOffsetY = scrollView.contentOffset.y
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

